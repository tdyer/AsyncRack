require 'rubygems'
require 'logger'
require 'rack/async'
require './em_async_app'
require './tracker_heartbeat'
require './promo_judge'

use Rack::ShowExceptions

# Set the development, test or production environment
# development (the default)
# thin --rackup config.ru start -p 8111
# production
# thin --rackup config.ru start -p 8111 -e production
environment = ENV['RACK_ENV']
valid_environments = %w{development test production}
unless valid_environments.include?(environment)
  raise ArgumentError.new("Invalid environment #{environment}, must be #{valid_environments.join(' OR ')}") 
end

# set up the Apache-like logger
log = Logger.new("log/#{environment}.log", File::WRONLY | File::APPEND)
case environment
when 'development'
  log.level = Logger::DEBUG
when 'test'
  log.level = Logger::DEBUG
when 'production'
  log.level = Logger::INFO
else
  raise ArgumentError.new("Invalid environment #{environment}, must be #{valid_environments.join(' OR ')}") 
end
use Rack::CommonLogger, log

# for handling asyn requests
use Rack::Async

map "/rack" do
  run EMAsyncApp.new(:method => 'rack_standard')
end

map "/rack_async" do
  run EMAsyncApp.new(:method => 'rack_async')
end

map "/db_async" do
  run EMAsyncApp.new(:method => 'db_async', :query => 'select count(*) from categories')
end


map "/health_check" do
  run lambda{ |env| [200, {"Content-Type"=> "text/plain"}, ["Good to go!"]] }
end

map "/tracker/heartbeat/" do
  run TrackerHeartbeat.new
end
map "/api/promo_judge/click" do
  run PromoJudge.new(:method => :click, :logger => log, :environment => environment)
end

# start this rack app with thin on port 8111
#  thin --rackup config.ru start -p 8111

# same as above but logging request/response (much slower!)
# thin --rackup config.ru start -p 8111 -V

# run one request as one user
# ab -n 1 -c 1 http://127.0.0.1:8111/rack_async
# run 2 requests for each of the 50 users
# ab -n 100 -c 50 http://127.0.0.1:8111/rack_async
