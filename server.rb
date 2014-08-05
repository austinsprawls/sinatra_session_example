require 'sinatra'
require_relative 'lib/sesh.rb'

set :sessions, true

set :bind, "0.0.0.0"

get '/' do
  if session['sesh_example']
    @user = Sesh.dbi.get_user_by_username(session['sesh_example'])
  end

  erb :index
end

get '/signin' do
  erb :signin
end

post '/signin' do
  user = Sesh.dbi.get_user_by_username(params['username'])
  if user.has_password?(params['password'])
    session['sesh_example'] = user.username
    redirect to '/'
  else
    "THAT'S NOT THE RIGHT PASSWORD!!!!"
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @user = Sesh::User.new(params[:username], params[:password])
  @user.update_password(@user.password_digest)
  Sesh.dbi.persist_user(@user)
  erb :signup
end

get '/signout' do
  session.clear
  redirect to '/'
end
