class MainController < ApplicationController

  def index
    alchemyapi = :keyword
    twitter_size = :twitter_Size
  end

  def search
    Main.twitterSearch(:keyword, :twitter_Size)
  end

end
