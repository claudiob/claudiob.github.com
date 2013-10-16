require 'faraday'
require 'json'
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

conn = Faraday.new 'https://api.github.com/' do |c|
  c.use Faraday::Adapter::NetHttp
end

conn.headers[:user_agent] = 'Daily updates to claudiob.github.io'
conn.authorization :token, File.read('.github')

repos = [
  {me: 'claudiob', author: 'rspec-api', name: 'rspec-api', title: 'RSpec API', description: 'When you write a web API, you make a promise to the world. RSpec API helps you keep your promise'},
  {me: 'claudiob', author: 'claudiob', name: 'bin', title: 'dotfiles', description: 'My aliases and shortcuts to type and code faster in the Bash shell environment'},
  {me: 'claudiob', author: 'claudiob', name: 'phdthesis', title: 'Ph.D. Thesis', description: 'LaTeX sources for the Ph.D. thesis in Artificial Intelligence that I wrote and designed'},
  {me: 'topspindev', author: 'topspin', name: 'id3_tags', title: 'ID3 Tags', description: 'Ruby gem to read and write ID3 metadata from/to MP3 files'},
  {me: 'claudiob', author: 'claudiob', name: 'neverfails', title: 'Neverfails', description: 'Beyond BDD: step definitions that write by themselves the code to make tests pass'}
]

repos = [
  {me: 'claudiob', author: 'rails', name: 'rails', title: 'Ruby on Rails', description: 'My web framework of choice since 2007. A great paradigm of well-organized huge codebase'},
  {me: 'claudiob', author: 'github', name: 'developer.github.com', title: 'GitHub API Documentation', description: 'The best example on how to build a document an API, online at <a href="#">developer.github.com</a>.'},
  {me: 'claudiob', author: 'ask', name: 'python-github2', title: 'Python client for GitHub API', description: 'GitHub API v2 client in python, with issues support'},
  {me: 'claudiob', author: 'emberjs', name: 'website', title: 'Source for emberjs.com', description: 'HTML code for the documentation of the Javascript framework <a href="http://emberjs.com" title="Ember.js">Ember.js</a>'},
  {me: 'claudiob', author: 'zipmark', name: 'rspec_api_documentation', title: 'RSpec API Doc generator', description: 'Automatically generate pretty API documentation for your Rails APIs'}
]

buffers = repos.map do |repo|
  buffer = ""
  response = conn.get "/repos/#{repo[:author]}/#{repo[:name]}/commits?author=#{repo[:me]}&per_page=100"
  commits_body = JSON response.body
  commits_body.take(3).each do |commit|
    buffer << %Q(<li><a href="https://github.com/#{repo[:author]}/#{repo[:name]}/commit/#{commit['sha']}">#{commit['sha'][0..6]}</a> <time datetime="#{commit['commit']['author']['date']}">#{DateTime.strptime(commit['commit']['author']['date'], '%Y-%m-%dT%H:%M:%S%z').ago}</time>#{commit['commit']['message'].split("\n").first}</li>\n          )
  end

  size = commits_body.size == 100 ? "more than 100" : commits_body.size
  buffer << %Q(<li><a href="https://github.com/#{repo[:author]}/#{repo[:name]}/commits?author=#{repo[:me]}">&#9657; #{size} older commits</a></li>)

  # TODO: remove 3 from the last line, don't show if it's 3 or less

  response = conn.get "/repos/#{repo[:author]}/#{repo[:name]}"
  repo_body = JSON response.body

  # TODO: if it's contributions, I don't care about stars/watchers
  #       i want to show my number of commits

  buffer = <<-EOF
 <li>
     <span class="octicon mega repo"></span>
     <h2><a href="https://github.com/#{repo[:author]}/#{repo[:name]}">#{repo[:title]}</a></h2>
     <h3>#{repo_body['language']}<a title="#{repo[:title]} stargazers" href="https://github.com/#{repo[:author]}/#{repo[:name]}/stargazers"><span class="octicon git-star"></span>#{repo_body['watchers_count']}</a><a title="#{repo[:title]} network" href="https://github.com/#{repo[:author]}/#{repo[:name]}/network"><span class="octicon git-branch"></span>#{repo_body['forks_count']}</a></h3>
     <p>#{repo[:description]}.</p>
     <ul class="commits">
       #{buffer}
     </ul>
   </li>
  EOF
  buffer
end
buffers = buffers.join("\n")
p buffers