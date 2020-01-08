class ScraperProcessor

  SKILLS = ["JAVA", "PYHTON", "C", "JAVASCRIPT"]

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

  def self.process_payload
    @payload.each do |word|
      if SKILLS.inclde? word.upcase
        Skill.find_by(name: word.upcase).occurrences.create
      end
    end
  end

  def self.log
    puts "================================"
    puts "PREPARING TO SCRAPE #{self.name.upcase.split("::")[1]}"
    puts "================================"
  end
end