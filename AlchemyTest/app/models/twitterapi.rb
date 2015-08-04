require ('dotenv')
require './alchemyapi'

Dotenv.load(
  File.expand_path("variables.env", __FILE__)
)

alchemyapi = AlchemyAPI.new()
$twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

def twitterSearch() {
  $client.search(:keyword, :result_type => "recent").take(sample).each do |tweet|
    response = alchemyapi.sentiment("text", tweet.text)
    
}
