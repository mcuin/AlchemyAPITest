class MainController < ApplicationController

  def index
    alchemyapi = :keyword
  end

  def search
    Main.twitterSearch()
  end

end
