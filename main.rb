require 'sinatra'
require "sinatra/cookies"
require 'omniauth-twitter'
require 'twitter'
require 'json'
require 'time'
require "httparty"

def post_message(message, creds)
  puts "Found Creds #{creds.inspect}"
  puts "Got message #{message}"
  
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = creds[:oauth_token]
    config.access_token_secret = creds[:oauth_token_secret]
  end

  puts client.update(message).inspect
end

def post_image(url, creds)
  puts "Found Creds #{creds.inspect}"
  puts "Got URL #{url}"
  
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = creds[:oauth_token]
    config.access_token_secret = creds[:oauth_token_secret]
  end

  image = Tempfile.new('twitter.oauth')
  File.open(image, "wb") do |f| 
    f.write HTTParty.get(url).parsed_response
    puts "Downloaded Image to #{image.path}"
  end

  # puts client.update_with_media("I'm tweeting with @gem!", File.new("/path/to/media.png")).inspect
  puts client.update_with_media("Photo post #{Time.now.utc.to_i}", image).inspect
end
 
use OmniAuth::Builder do
  provider :twitter, ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"]
end
 
configure do
  enable :sessions
end
 
helpers do
  def admin?
    session[:admin]
  end
end
 
get '/public' do
  "This is the public page - everybody is welcome!"
end
 
get '/private' do
  halt(401,'Not Authorized') unless admin?
  "This is the private page - members only <br/> #{cookies[:tc]}"
end

get '/post/image/' do
  post_image(params[:url], JSON.parse(cookies[:tc], {:symbolize_names => true}))
end

get '/post/:message' do
  halt(401,'Not Authorized') unless admin?
  post_message(params[:message], JSON.parse(cookies[:tc], {:symbolize_names => true}))
end
 
get '/login' do
  redirect to("/auth/twitter")
end

get '/auth/twitter/callback' do
  session[:admin] = true
  cookies[:tc] = {
    oauth_token:        env['omniauth.auth']['credentials']['token'],
    oauth_token_secret: env['omniauth.auth']['credentials']['secret']}.to_json
  "<h1>Hi #{env['omniauth.auth']['info']['name']}!</h1><img src='#{env['omniauth.auth']['info']['image']}'> #{env.inspect}"
end
get '/auth/failure' do
  params[:message]
end
 
get '/logout' do
  session[:admin] = nil
  cookies[:tc] = nil
  "You are now logged out"
end