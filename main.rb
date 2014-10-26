require 'sinatra'
require "sinatra/cookies"
require 'omniauth-twitter'
require 'twitter'
require 'json'
require 'time'
require "httparty"
 
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

  def twitter_client(creds)
    puts "Found Creds #{creds.inspect}"
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = creds[:oauth_token]
      config.access_token_secret = creds[:oauth_token_secret]
    end
  end

  def download_image(url)
    image = Tempfile.new('twitter.oauth')
    File.open(image, "wb") do |f| 
      f.write HTTParty.get(url).parsed_response
      puts "Downloaded Image to #{image.path}"
    end
    image
  end

  def post_message(text, creds)
    puts "Got message #{text}"
    client = twitter_client(creds)
    client.update(text).inspect
  end

  def post_image(url, creds)
    puts "Got URL #{url}"

    client = twitter_client(creds)
    image = download_image(url)
    
    client.update_with_media("Photo post #{Time.now.utc.to_i}", image).inspect
  end
end

###################################
##### App Routes 
get '/' do
  "Hello, welcome to Twitter OAuth Tutorial"
end

get '/test' do
  halt(401,'Not Authorized') unless admin?
  "#{cookies[:tc]}"
end
###################################



###################################
##### Twitter Updates

get '/post/image/' do
  halt(401,'Not Authorized') unless admin?
  post_image(params[:url], JSON.parse(cookies[:tc], {:symbolize_names => true}))
end

get '/post/message/' do
  halt(401,'Not Authorized') unless admin?
  post_message(params[:text], JSON.parse(cookies[:tc], {:symbolize_names => true}))
end
###################################


 
###################################
##### Session Handling 
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
###################################
