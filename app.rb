require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/listing'
require_relative 'models/user'

begin 
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

set :database, ENV['DATABASE_URL']

get '/' do
  # @listings = Listing.all
  erb :index
end

post '/' do
  Listing.create({title: params[:title], price: params[:price], description: params[:description]})
  # @listings = Listing.all
  redirect '/'
end

helpers do

  def listings
    @listings = Listing.all
  end
end