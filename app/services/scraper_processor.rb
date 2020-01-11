class ScraperProcessor

  def self.process(site:)
    return unless site

    scraper = "Sites::#{site.titleize.gsub(/\s/, "")}::Scraper".constantize
    scraper.scrape
  end

  def self.start_browser_and_got_to_page(url:)
    @browser = Watir::Browser.new(:chrome, headless: true)
    @browser.goto(url)
    sleep 1
  end

  def self.close_browser
    @browser.close
  end 

  def self.log
    puts "================================"
    puts "PREPARING TO SCRAPE #{self.name.upcase.split("::")[1]}"
    puts "================================"
  end
end