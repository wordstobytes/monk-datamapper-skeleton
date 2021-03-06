ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"
require 'sinatra'

begin
  require File.expand_path("vendor/dependencies/lib/dependencies", File.dirname(__FILE__))
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "haml"
require "sass"
require "dm-core"
require "dm-aggregates"
require "dm-constraints"
require "dm-migrations"
require "dm-transactions"
require "dm-serializer"
require "dm-timestamps"
require "dm-validations"
require "dm-types"
require "spawn"
require "faker"

class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie
end

db = monk_settings(:database)
configure :development do
  DataMapper.setup(:default, "#{db[:adapter]}://#{Dir.pwd}//#{db[:database]}.db")
end

configure :test do
  DataMapper.setup(:default, " #{db[:adapter]}://#{db[:username]}:#{db[:password]}@#{db[:host]}:#{db[:port]}/#{db[:database]}")
end

configure :production do
  DataMapper.setup(:default, " #{db[:adapter]}://#{db[:username]}:#{db[:password]}@#{db[:host]}:#{db[:port]}/#{db[:database]}")
end


# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

DataMapper.finalize

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

Main.run! if Main.run?
