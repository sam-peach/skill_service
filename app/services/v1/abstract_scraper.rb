module V1
  class AbstractScraper
    def initialize
      @browser = Watir::Browser.new(:chrome, headless: true)
      @payload = []
    end

    def scrape
      puts "==========================="
      puts "PREPARING #{self.class}"
      puts "==========================="

      go_to_url

      pre_collect if self.respond_to?(:pre_collect, true)

      data = collect_data

      close_browser

      data
    end

    private

    def go_to_url
      @browser.goto(self.class::SITE_URL)
      sleep 1
    end

    def collect_data
      self.class::PAGE_DEPTH.times do
        go_to_next_page
        @payload.push(*interate_though_links(links: job_title_links))
      end
      @payload
    end

    def close_browser
      @browser.close
    end
  end
end