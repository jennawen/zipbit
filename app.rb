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
    flash[:error] ="Please complete all fields."
    redirect '/'
  end
end



get "/views/:secret_key" do
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
 