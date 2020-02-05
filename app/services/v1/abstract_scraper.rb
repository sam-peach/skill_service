module V1
  class AbstractScraper
    def initialize
      @browser = Watir::Browser.new(:chrome, headless: true)
      @payload = []
      @word_processor = V1::WordProcessor
    end

    def scrape
      puts "==========================="
      puts "PREPARING #{self.class}"
      puts "==========================="

      go_to_url

      pre_collect if self.respond_to?(:pre_collect, true)

      collect_data

      close_browser

      puts "**ENDING SCRAPE"
    end

    private

    def go_to_url
      @browser.goto(self.class::SITE_URL)
      sleep 1
    end

    def collect_data
      self.class::PAGE_DEPTH.times do
        pre_page_collect if self.respond_to?(:pre_page_collect, true)
        
        interate_though_links(links: job_title_links)

        go_to_next_page

        sleep 1
      end
    end

    def close_browser
      @browser.close
    end
  end
end