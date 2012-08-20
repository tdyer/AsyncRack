require 'rubygems'
require 'rack/async'
require './em_async_app'

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

# start this rack app with thin on port 8111
#  thin --rackup config.ru start -p 8111

# same as above but logging request/response (much slower!)
# thin --rackup config.ru start -p 8111 -V

