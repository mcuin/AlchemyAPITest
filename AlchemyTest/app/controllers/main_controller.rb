class MainController < ApplicationController

  helper_method :search

  def index
    alchemyapi = :keyword
  end

  def search 
    require_relative '../models/./twitterapi'
  end

end
