require ('dotenv')
require './alchemyapi'
require 'twitter'

Dotenv.load(
  File.expand_path("../variables.env", __FILE__)
)

$alchemyapi = AlchemyAPI.new()

$twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

def self.twitterSearch(keyword) 
  $twitter_positive = 0
  $twitter_negative = 0
  $twitter_neutral = 0

  begin
  $twitter_client.search(keyword, :result_type => "recent").take(20).each do |tweet|
    response = $alchemyapi.keywords("text", tweet.text, {'sentiment'=>1})
    print tweet.text
    if response['status'] == 'OK'
      for keyword in response['keywords']
	if (keyword['sentiment']['type'].eql? "positive") 
          $twitter_positive += 1
        elsif (keyword['sentiment']['type'].eql? "negative")
          $twitter_negative += 1
        else 
          $twitter_neutral += 1  
        end
      end
    else
      puts 'Error in keyword extraction call: ' + response['statusInfo']
    end
  end
  rescue Twitter::Error
    puts "Cannot connect to Twitter."
    exit
  end
end
