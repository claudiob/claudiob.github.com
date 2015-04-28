require 'faraday'
require 'json'
require 'ostruct'

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

def load_sources(login)
  sources.map.with_index{|source, i| load_repo source, login, i}
end

def sources
  [
    {name: 'bh',         background: '#be64b4', border: '#96508e', style: 'light', title: 'Bh',             year: '2014–',     url: 'fullscreen.github.io/bh',             owner: 'Fullscreen', lines: [%q{Bootstrap is a great framework, but requires you to write many lines of HTML code even for simple components (alerts, modals, …).}, %q{Bh is a Ruby gem I created to solve this issue. Using its helpers, you can get generate those lines of HTML with only a few keystrokes.}]},
    {name: 'yt',         background: '#10a17c', border: '#0e8c6d', style: 'light', title: 'Yt',             year: '2014–',     url: 'github.com/fullscreen/yt',            owner: 'Fullscreen', lines: [%q{YouTube offers a great data and analytics API, but not a good Ruby client to access it.}, %q{Yt is a Ruby gem I created to provide a clean and tested interface to interact with YouTube. Upload videos, monitor earnings, track views, handle claims and more from your Ruby apps!}]},
    {name: 'rails',      background: '#c3312b', border: '#ad2b26', style: 'light', title: 'Ruby on Rails',  year: '2012–',     url: 'github.com/rails/rails/commits',      owner: 'rails', query: '?author=claudiob', fork: true, lines: [%q{I learnt Rails in 2007 and loved it ever since.}, %q{As a member of the &ldquo;Rails Issues Team&rdquo;, I close issues on GitHub, merge documentation changes, write the weekly newsletter, spread the love.}, %q{I also organize the L.A. Ruby/Rails meetup.}]},
    {name: 'monsters',   background: '#91d2cb', border: '#82bdb7', style: 'dark',  title: 'Music Monsters', year: '2010',      url: 'musicmonsters.herokuapp.com', lines: [%q{What can you build in 24 hours?}, %q{I met Hannah on a Friday, worked with her the whole Saturday, and ended up creating this cool &ldquo;Music Hack Day&rdquo; project. Five years later, it’s still up and running!}]},
    {name: 'rspec-api',  background: '#d12655', border: '#a31d41', style: 'light', title: 'RSpec API',      year: '2013–2014', url: 'rspec-api.github.io',                 owner: 'rspec-api', lines: [%q{I built a gem on top of RSpec to help coders write concise tests for resourceful web APIs.}, %q{Whether you need to test a third-party API or are building your own, RSpec API can help you.}]},
    {name: 'boxoffice',  background: '#fff373', border: '#ebe06a', style: 'dark',  title: 'Boxoffice',      year: '2009',      url: 'sub.boxoffice.es', lines: [%q{Did you know that &ldquo;Titanic&rdquo; was still making money after 40 weeks in the theaters? Or that &ldquo;My Big Fat Greek Wedding&rdquo; had its strongest week 4 months after being released?}, %q{Plot and compare the box office results of any movie with this simple app I wrote in Python.}]},
    {name: 'csswaxer',   background: '#53c265', border: '#4bad5b', style: 'light', title: 'CSSWaxer',       year: '2010',      url: 'github.com/claudiob/csswaxer', lines: [%q{Go on, inspect the code of this page and check out how I write CSS files. How does it feel?}, %q{If you also think organizing rules by property is a good idea (color, typography, layout…), this Ruby script will help you clean your CSS.}]},
#    {name: 'neverfails', background: '#070d80', border: '#050961', style: 'light', title: 'Neverfails',     year: '2011',      url: 'speakerdeck.com/claudiob/neverfails',        }, # comment out (fix first and change speakerdeck link)
  ]
end

def load_repo(repo, login, index)
  response = connection.get "/repos/#{repo.fetch(:owner, login)}/#{repo[:name]}"
  body = JSON response.body

  OpenStruct.new(repo).tap do |r|
    r.description = body['description']
    r.count = repo[:fork] ? load_commits(repo, login) : body['watchers_count']
    r.icon  = repo[:fork] ? :commit : :star
    r.klass = index.even? ? 'left' : 'right'
  end
end

def load_commits(repo, login)
  response = connection.get "/repos/#{repo.fetch(:owner, login)}/#{repo[:name]}/commits?author=#{repo.fetch(:committer, login)}&per_page=100"
  JSON(response.body).size
end