require 'faraday'
require 'json'
require 'date'
require 'ostruct'
require 'date'

module DateTimeAgo
  def ago
    days_ago = (DateTime.now - self).to_i
    week = 7
    month = week*52/12
    year = month*12
    case days_ago
      when 0..1 then 'today'
      when 1..2 then 'yesterday'
      when 2..week then "#{days_ago} days ago"
      when week..2*week then 'last week'
      when 2*week..month then "#{(days_ago/week).to_i} weeks ago"
      when month..2*month then 'last month'
      when 2*month..year then "#{(days_ago/month).to_i} months ago"
      when year..2*year then 'last year'
      else "#{(days_ago/year).to_i} years ago"
    end
  end
end
DateTime.send :include, DateTimeAgo

def connection
  @connection ||= new_connection
end

def new_connection
  connection = Faraday.new 'https://api.github.com/' do |c|
    c.use Faraday::Adapter::NetHttp
  end.tap do |c|
    c.headers[:user_agent] = "GitHub API client"
    c.authorization :token, File.read('.github')
  end
end

def get(route)
  connection.get route
end

def load_user(login)
  response = get "/users/#{login}"

  OpenStruct.new(JSON response.body).tap do |user|
    user.joined_on = DateTime.parse(user.created_at).strftime('%b %d, %Y')
  end
end

def load_sources(login)
  sources.map{|source| load_repo source, login}
end

def load_forks(login)
  forks.map{|source| load_repo source, login, true}
end

def sources
  [
    {name: 'rspec-api', owner: 'rspec-api'},
    {name: 'csswaxer'},
    {name: 'neverfails'},
    {name: 'monsters'},
    {name: 'phdthesis', title: 'Ph.D. Thesis'},
    {name: 'rails3.github.com', owner: 'rails3', title: 'Video tutorial for Rails 3'},
    {name: 'boxoffice'},
    {name: 'dotfiles'},
    {name: 'id3_tags', owner: 'topspin', committer: 'topspindev', title: 'ID3 Tags'},
    {name: 'scouts'},
    {name: 'radiotagmap'},
    {name: 'django-sortable', owner: 'ff0000'},
    {name: 'available_twitter_usernames'},
    {name: 'affinity'},
    {name: 'ff0000.github.com', owner: 'ff0000'},
    {name: 'yesradio'},
  ]
end

def forks
  [
    {name: 'rails', owner: 'rails'}, #, title: 'Ruby on Rails', description: 'My web framework of choice since 2007. A great paradigm of well-organized huge codebase'},
    {name: 'developer.github.com', owner: 'github'}, #, title: 'GitHub API Documentation', description: 'The best example on how to build a document an API, online at <a href="http://developer.github.com">developer.github.com</a>'},
    {name: 'python-github2', owner: 'ask'}, #, title: 'Python client for GitHub API'},
    {name: 'website', owner: 'emberjs'}, #, title: 'Source for emberjs.com', description: 'HTML code for the documentation of the Javascript framework <a href="http://emberjs.com" title="Ember.js">Ember.js</a>'},
    {name: 'rspec_api_documentation', owner: 'zipmark'}, #, title: 'RSpec API Doc generator', description: 'Automatically generate pretty API documentation for your Rails APIs'},
  ]
end

def load_repo(repo, login, is_fork=false)
  response = get "/repos/#{repo.fetch(:owner, login)}/#{repo[:name]}"

  OpenStruct.new(JSON response.body).tap do |r|
    title = is_fork ? "#{repo[:owner]}/#{repo[:name]}" : repo[:name] # TODO: Humanize
    r.title = repo.fetch :title, title
    r.description = repo.fetch :description, r.description
    r.committer = repo.fetch :committer, login
    r.new_commits, r.old_commits_count = load_commits repo, login
  end
end

def load_commits(repo, login)
  response = get "/repos/#{repo.fetch(:owner, login)}/#{repo[:name]}/commits?author=#{repo.fetch(:committer, login)}&per_page=100"
  all_commits = JSON response.body
  three_commits = all_commits.take(3).map{|commit| load_commit commit}
  [three_commits, [all_commits.size - 3, 0].max]
end

def load_commit(commit)
  OpenStruct.new(commit).tap do |c|
    c.short_sha = c.sha[0..6]
    c.timestamp = c.commit['author']['date']
    c.timestamp_ago = DateTime.parse(c.timestamp).ago
    c.message = c.commit['message'].split("\n").first # TODO: Max 70 chars?
    1
  end
end