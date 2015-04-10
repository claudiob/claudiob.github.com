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
    {name: 'bh',         background: '#be64b4', border: '#96508e', style: 'light', title: 'Bh',             year: '2014–',     url: 'fullscreen.github.io/bh',             owner: 'Fullscreen'},
    {name: 'yt',         background: '#10a17c', border: '#0e8c6d', style: 'light', title: 'Yt',             year: '2014–',     url: 'github.com/fullscreen/yt',            owner: 'Fullscreen'},
    {name: 'rails',      background: '#c3312b', border: '#ad2b26', style: 'light', title: 'Ruby on Rails',  year: '2012–',     url: 'github.com/rails/rails/commits',      owner: 'rails', query: '?author=claudiob', fork: true},
    {name: 'rspec-api',  background: '#d12655', border: '#a31d41', style: 'light', title: 'RSpec API',      year: '2013–2014', url: 'rspec-api.github.io',                 owner: 'rspec-api'},
#    {name: 'monsters',   background: '#91d2cb', border: '#82bdb7', style: 'dark',  title: 'Music Monsters', year: '2010',      url: 'musicmonsters.herokuapp.com',         }, # comment out (fix first)
    {name: 'boxoffice',  background: '#fff373', border: '#ebe06a', style: 'dark',  title: 'Boxoffice',      year: '2009',      url: 'sub.boxoffice.es',                    },
    {name: 'csswaxer',   background: '#53c265', border: '#4bad5b', style: 'light', title: 'CSSWaxer',       year: '2010',      url: 'github.com/claudiob/csswaxer', },
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