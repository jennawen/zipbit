require 'sinatra'
require 'sinatra/activerecord'
require 'securerandom'
require_relative 'models/listing'
require_relative 'models/user'
require 'sinatra/flash'

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

get '/' do
  erb :index
end

post '/' do
  @requested_listing = Listing.create({title: params[:title], price: params[:price], description: params[:description], secret_key: SecureRandom.hex(3)})
  "Thank you for your submission. Please go to http://zipbit.herokuapp.com/views/#{requested_listing.secret_key} to edit your post."
end


get "/views/:secret_key" do
  erb :editlisting
end
 
post '/confirmedit' do
  requested_listing.update(params)
  "Thank you!"
end
 