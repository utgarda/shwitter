require 'sinatra'
require 'sinatra_warden'
require 'user'
require 'post'

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
        if u.details[:new]
          puts u.details.to_s
          redirect! "/update/#{u.username}"
        else
          redirect! "/"
        end
      else
        fail!('could not login')
        redirect! "/"
      end
    end
  end

  get '/' do
    haml :main, :locals => {:users => User.users.keys,
                            :users_count => User.users.keys.length,
                            :posts => Post.posts}
  end

  get '/users/*' do |username|
    if User.users.has_key? username
      haml :user, :locals => {:details => User.users[username].details}
    else
      "404"
    end
  end

  get '/update/*' do |username|
    if User.users.has_key? username
      haml :user_update
    else
      "404"
    end
  end

  post '/profile' do
    if user
      User.update user, params
      "success (or is it?)"
    end
  end

  post '/post' do
    Post.new user, params[:message], params[:is_private]
    redirect '/'
  end

  delete '/post/*' do |id|
    Post.delete id
    redirect '/'
  end

end


Shwitter.run!