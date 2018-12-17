require 'sinatra'
require 'twitter'

helpers do
  def client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV.fetch("TWITTER_CONSUMER_KEY")
      config.consumer_secret = ENV.fetch("TWITTER_CONSUMER_SECRET")
	  config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN") 
	  config.access_token_secret = ENV.fetch("TWITTER_TOKEN_SECRET") 
    end
  end
end

get "/tweets.css" do
  content_type "text/css"
  tweets = client.user_timeline
  <<-CSS
	  @media screen and (-webkit-min-device-pixel-ratio: 0) {

	  .tweet .copy:before {
	    white-space: pre-wrap;
	  }
  CSS
  tweets.take(15).map.with_index do |tweet, i|
	copy_text = tweet.text.delete("\t\r\n");
	timestamp = tweet.created_at.strftime("%b %-d, %Y");
    <<-CSS
	#tweet-#{i + 1} .avatar {
	  background: url("https://pbs.twimg.com/profile_images/897296139157987332/ikvdHhvb_normal.jpg");
	}
	
	#tweet-#{i + 1} .name::before {
	  content: "#{tweet.user.name}";
	}

	#tweet-#{i + 1} .handle::after {
	  content: "@#{tweet.user.screen_name}";
	}

	#tweet-#{i + 1} .copy::before {
	  content: "#{copy_text}";
	}

	#tweet-#{i + 1} .timestamp::after {
	  content: "#{timestamp}";
	}
		
		
    CSS
  end
end
