class ScrapersController < ApplicationController
  def create
    render :ok
    ScraperProcessor.process(site: "indeed")
  end
end
