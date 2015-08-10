require ('dotenv')
require 'twitter'
require 'csv'

Dotenv.load(
  File.expand_path("../variables.env", __FILE__)
)

load(File.expand_path(".././alchemyapi.rb", __FILE__))
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
  	elsif (((@negative) > (@positive)) && ((@negative) > (@neutral)))
 	  $twitter_negative += 1
        elsif (((@neutral) > (@positive)) && ((@neutral) > (@negative))) 
  	  $twitter_neutral += 1
        end

	@positive = 0
        @negative = 0
        @neutral = 0
    else
      puts 'Error in keyword extraction call: ' + response['statusInfo']
    end
  end
  
  CSV.open("public/results.csv", "wb") do |csv|
    csv << ["positive", "negative", "neutral"]
    csv << [$twitter_positive, $twitter_negative, $twitter_neutral]
  end

  rescue Twitter::Error
    puts "Cannot connect to Twitter."
    exit
  end
end

twitterSearch('alchemyapi')
