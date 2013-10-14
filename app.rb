require 'sinatra'
require 'sinatra/activerecord'
require 'securerandom'
require 'rack-flash'
require_relative 'models/listing'
require_relative 'models/user'


begin 
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

set :database, ENV['DATABASE_URL']
enable :sessions
use Rack::Flash


helpers do
  def listings
    @listings = Listing.all
  end

  def requested_listing
    @requested_listing ||= Listing.find(session[:listing_id])
  end

  def user
    @user ||= User.find(session[:user_id])
  end

  def logged_in?
    session[:user_id]
  end

  def authenticate

    if User.find_by user_name: (params[:user_name]) == nil
      auth = "user name incorrect"
    else
      user = User.find_by user_name: (params[:user_name])
      if user.password == params[:password]
        auth = "authenticated"
      else
        auth = "password incorrect"
      end
    end
  end
end


get '/' do
  erb :index
end

post '/' do
  listing = Listing.create({title: params[:title], price: params[:price], description: params[:description], secret_key: SecureRandom.hex(3)})
  if listing.valid?
    session[:listing_id]=listing.id
    redirect '/confirmsubmit'
  else
    flash[:notice] ="Please complete all fields."
    redirect '/'
  end
end

get '/signup' do
  erb :signup  
end

post '/signupcomplete' do
  user = User.new(params)
  user.save
  if user.save
    session[:user_id]=user.id
    redirect "/user"
  else
    if params[:password] == ""
      flash[:error]="Please fill in a password."
      redirect "/signup"
    else
      flash[:error]="Username already taken."
      redirect "/signup"
    end
  end
end

get '/user' do
  if logged_in?
    erb :user
  else
    flash[:notice]="You are not signed in."
    redirect "/"
  end
end


post '/userlistings' do
 listing = Listing.create({title: params[:title], price: params[:price], description: params[:description], user_id: user.id, secret_key: SecureRandom.hex(3)})
  if listing.valid?
    redirect '/userlistings'
  else
    flash[:error]="Form incomplete. #{user.user_name}, please complete all fields."
    redirect '/user'
  end
end

get '/userlistings' do
    if logged_in?
    erb :userlistings
    @mylistings = Listing.where(user_id: user.id)
  else
    flash[:notice]="You must be signed in to view your listings."
    redirect "/signin"
  end
end

get '/login' do
  erb :login
end

post '/logincomplete' do
    if authenticate == true
      p "Authetnicated!"
    # session[:user_id] = user.id
    # redirect '/user'
    elsif authenitcate == wrong_passord
    p "Not valid"
  end
end


get '/views/:secret_key' do
  erb :editlisting
end

get '/confirmsubmit' do
  erb :confirmsubmit
end
 
post '/confirmedit' do
  requested_listing.update(params)
  flash[:notice] = "Your listing has been successfully updated."
  redirect '/'
end
 