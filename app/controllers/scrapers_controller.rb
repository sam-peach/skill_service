class ScrapersController < ApplicationController
  def create
    ScraperProcessor.process(site: "indeed")
  end
end
