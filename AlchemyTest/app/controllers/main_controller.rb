require_relative '../models/./twitterapi'

class MainController < ApplicationController

  helper_method :search

  def index
    alchemyapi = :keyword
    twitter_size = params[:twitter_Size]
  end

  def search
    twitterSearch(:keyword, :twitter_Size)
  end

end
