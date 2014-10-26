# [twitter-oauth](https://github.com/cevaris/twitter-oauth)

Sinatra example of authenticating and uploading images to Twitter. 

## Getting Started

First open a Terminal

	# Install required Gems
    bundle
    
    # Setup Twitter Environment Variables
    cp env.example env.local
    # Open local and enter values for CONSUMER_KEY and CONSUMER_SECRET
    source env.local
    
    # Start websever
    ruby ./main.rb
    == Sinatra/1.4.5 has taken the stage on 4567 for development with backup from Thin
	Thin web server (v1.6.2 codename Doc Brown)
	Maximum connections set to 1024
	Listening on localhost:4567, CTRL+C to stop
	...

Now open the browser to [http://127.0.0.1:4567/login](http://127.0.0.1:4567/login) to start the 3-Legged Authorization process with Twitter.

### Commands

#### Login

[http://127.0.0.1:4567/login](http://127.0.0.1:4567/login)

#### Test Login

After the Twitter callback succeeds, navigate to the `/test` to view your OAuth credentials. 

[http://127.0.0.1:4567/test](http://127.0.0.1:4567/test)

#### Post Message

After authenticating, to post a tweet, navigate to the `/post/message/` route. Here are some examples.

- [127.0.0.1:4567/post/message/?text=this is a test](127.0.0.1:4567/post/message/?text=this is a test)
- [127.0.0.1:4567/post/message/?text=hello world](127.0.0.1:4567/post/message/?text=hello world)

#### Post Image

After authenticating, to post a tweet with an **image**, navigate to the `/post/image/`route. Here are some examples.

- [127.0.0.1:4567/post/image/?url=https://pbs.twimg.com/profile_banners/451564034/1398835007/1500x500](127.0.0.1:4567/post/image/?url=https://pbs.twimg.com/profile_banners/451564034/1398835007/1500x500)
- [127.0.0.1:4567/post/image/?url=http://goo.gl/G9Sozk](127.0.0.1:4567/post/image/?url=http://goo.gl/G9Sozk)

#### Logout

To test the authentication process, you can logout and attepmpt to post again.

[http://127.0.0.1:4567/logout](http://127.0.0.1:4567/logout)

## Resources
- [Twitter Ruby Gem](https://github.com/sferik/twitter)
- [Twitter OAuth Gem](https://github.com/arunagw/omniauth-twitter)
- [Sinatra Twitter OAuth](http://www.sitepoint.com/twitter-authentication-in-sinatra/)
- [Twitter Local Development](http://stackoverflow.com/questions/1726695/how-to-test-the-twitter-api-locally)
- [Downloading Images in Ruby](http://stackoverflow.com/questions/18474483/how-to-download-an-image-file-via-http-into-a-temp-file)