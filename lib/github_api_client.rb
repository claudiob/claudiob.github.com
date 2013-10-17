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
    {name: 'dotfiles'},
    {name: 'id3_tags', owner: 'topspin', committer: 'topspindev'},
    {name: 'phdthesis'},
    {name: 'neverfails'},
    {name: 'csswaxer'},
    {name: 'monsters'},
    {name: 'rails3.github.com', owner: 'rails3'},
    {name: 'boxoffice'},
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
    {name: 'rails', owner: 'rails'},
    {name: 'developer.github.com', owner: 'github'},
    {name: 'rspec_api_documentation', owner: 'zipmark'},
    {name: 'rspec-expectations', owner: 'rspec'},
    {name: 'website', owner: 'emberjs'},
    {name: 'startupsanonymous', owner: 'bomatson'},
    {name: 'rspec-collection_matchers', owner: 'rspec'},
    {name: 'jbuilder', owner: 'rails'},
    {name: 'rails-perftest', owner: 'rails'},
    {name: 'rails_apps_composer', owner: 'RailsApps'},
    {name: 'py-github', owner: 'dustin'},
    {name: 'lettuce', owner: 'gabrielfalcao'},
    # {name: 'python-github2', owner: 'ask'}, old, only one commit
    # {name: 'crystallball', owner: 'bomatson'}, old, only one commit
    # {name: 'jsonloops', owner: 'marak'}, old, only one commit
  ]
end

def load_repo(repo, login, is_fork=false)
  response = get "/repos/#{repo.fetch(:owner, login)}/#{repo[:name]}"

  OpenStruct.new(JSON response.body).tap do |r|
    r.title = is_fork ? "#{repo[:owner]}/#{repo[:name]}" : repo[:name]
    r.description = repo.fetch(:description, r.description)[0..99]
    unless r.homepage.nil? || r.homepage.empty?
      r.description.gsub! /^(.*?)(\S*?\s*?\S*?\s*?\S*?)$/, %Q(\\1<a href="#{r.homepage}">\\2</a>)
    end
    r.description = "&nbsp;" if r.description.empty?
    r.committer = repo.fetch :committer, login
    r.new_commits, r.commits_count, r.old_commits_count = load_commits repo, login
  end
end

def load_commits(repo, login)
  response = get "/repos/#{repo.fetch(:owner, login)}/#{repo[:name]}/commits?author=#{repo.fetch(:committer, login)}&per_page=100"
  all_commits = JSON response.body
  three_commits = all_commits.take(3).map{|commit| load_commit commit}
  [three_commits, all_commits.size, [all_commits.size - 3, 0].max]
end

def load_commit(commit)
  OpenStruct.new(commit).tap do |c|
    c.short_sha = c.sha[0..6]
    c.timestamp = c.commit['author']['date']
    c.timestamp_ago = DateTime.parse(c.timestamp).ago
    c.message = c.commit['message'].split("\n").first[0..71]
  end
end