require 'sinatra'
require 'sinatra/activerecord'
require 'securerandom'
require_relative 'models/listing'
require_relative 'models/user'
require 'rack-flash'
use Rack::Flash

enable :sessions

set :database, ENV['DATABASE_URL']


begin 
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

helpers do
  def listings
    @listings = Listing.all
  end

  def requested_listing
    @requested_listing ||= Listing.find_by(secret_key: params[:secret_key])
  end
end

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
  session[:listing_id]=listing.id
  redirect '/confirmsubmit'

end


get "/views/:secret_key" do
  erb :editlisting
end
 
post '/confirmedit' do
  requested_listing.update(params)
  flash[:notice] = "Your listing has been successfully updated."
  redirect '/'
end
 