class ScraperProcessor

  def self.process(site:)
    return unless site

    scraper = "Sites::#{site.titleize.gsub(/\s/, "")}::Scraper".constantize
    scraper.scrape
    scraper.instance_variables.each { |x| scraper.scraper.instance_variables(x) }
    GC.start
  end

  def self.start_browser_and_got_to_page(url:)
    @browser = Watir::Browser.new(:chrome, headless: true)
    @browser.goto(url)
    sleep 1
  end

  def self.log
    puts "================================"
    puts "PREPARING TO SCRAPE #{self.name.upcase.split("::")[1]}"
    puts "================================"
  end
end