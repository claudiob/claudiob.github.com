require 'rubygems'
require 'erb'
require_relative 'lib/github_api_client'

template = File.read 'lib/template.html.erb'
erb = ERB.new template, 0, '<>'

repos = load_sources 'claudiob'
is_fork = false
File.open('index.html', 'w') {|f| f.puts erb.result}