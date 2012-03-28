require 'sinatra'
require 'sinatra_warden'
require 'user'

$a = {:a => "b"}

class Shwitter < Sinatra::Base
register Sinatra::Warden

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Shwitter
end

Warden::Strategies.add(:password) do
  def valid?
    puts 'password strategy valid?'
    username = params["username"]
    username and username != ''
  end
  def authenticate!
    puts 'password strategy authenticate'
    u = User.authenticate params["username"], params["password"]
    if u
      success!(u)
    else
      fail!('could not login')
    end
  end
end

get '/hi' do
  authorize!('/login')
  "Hello World!" + $a[:a]
end

get '/hello' do
  "Hello World!" + $a[:a]
end

get '/' do
  haml :main, :locals => {:users => User.users.keys, :users_count => User.users.keys.length}
end

get '/users/*' do |username|
  if User.users.has_key? username
    haml :user, :locals => {:details => User.users[username].details}
  else 404 end
end


end


Shwitter.run!