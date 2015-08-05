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
  @positive = 0
  @negative = 0
  @neutral = 0
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
          @positive += 1
        elsif (keyword['sentiment']['type'].eql? "negative")
          @negative += 1
        elsif (keyword['sentiment']['type'].eql? "neutral") 
          @neutral += 1 
        end
      end
   	
	if (((@positive) > (@negative)) && ((@positive) > (@neutral))) 
  	  $twitter_positive += 1
	  puts "positive"
  	elsif (((@negative) > (@positive)) && ((@negative) > (@neutral)))
 	  $twitter_negative += 1
	  puts "negative"
        elsif (((@neutral) > (@positive)) && ((@neutral) > (@negative))) 
  	  $twitter_neutral += 1
	  puts "neutral"
        end

	@positive = 0
        @negative = 0
        @neutral = 0
    else
      puts 'Error in keyword extraction call: ' + response['statusInfo']
    end
  end
  rescue Twitter::Error
    puts "Cannot connect to Twitter."
    exit
  end
end

twitterSearch('alchemyapi')
