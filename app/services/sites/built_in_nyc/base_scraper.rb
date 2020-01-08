module Sites
  module BuiltInNyc
    class BaseScraper < ScraperProcessor
      SITE_URL          = "https://www.builtinnyc.com/jobs"
      JOB_TTILE_CSS_TAG  = ".title"
      BODY_TEXT_CSS_TAG  = ".job-description"
      PAGINATION_CSS_TAG = ".pager__item"

      def self.scrape
        log

        start_browser_and_got_to_page(url: SITE_URL)
        @payload = []
        click_job_category
        
        5.times do |page|
          data = Nokogiri::HTML(@browser.html)
          job_title_links = data.css(".left-col .title")
          @payload.push(*interate_though_links(links: job_title_links))
          go_to_next_page
        end
        
        puts "==========================="
        puts "SCRAPE COMPLETE"
        puts "SENDING TO WORDS PROCESSOR"
        puts "==========================="

        WordsProcessor.process(data: @payload)
      end
  
      private
  
      def self.interate_though_links(links:)
        word_list = []
  
        links.each do |link_tag|
          puts "> Scraping: #{link_tag.text.strip}"
          begin
            split_and_push(text: link_tag.text)

            @browser.h2(text: link_tag.text.strip).wait_until(timeout: 4, &:present?).click(:command)
            sleep 1

            @browser.windows.last.use
            new_page_data = Nokogiri::HTML(@browser.html)

            job_text_body = new_page_data.css(BODY_TEXT_CSS_TAG) 
            
            word_list.push(*job_text_body.text.gsub(/\W/, " ").split(" ").uniq) if job_text_body.present?
            @browser.windows.last.close if @browser.windows.count > 1
          rescue => e
            puts ">>>> #{e}"
            next
          end
        end
        word_list
      end
  
      def self.go_to_next_page
        @browser.link(title: "Go to next page", rel: "next").wait_until(&:present?).click
        sleep 5
      end

      def self.get_pagination_links
        @data = Nokogiri::HTML(@browser.html) 
        @page_number_idx = 0

        @page_links = @data.css(PAGINATION_CSS_TAG).css('a')[1..-2]
      end

      def self.split_and_push(text:)
        @payload.push(*text.gsub(/\W/, " ").split(" "))
      end

      def self.click_job_category
        @browser.link("data-facet-alias".to_sym => "job-category_developer-engineer").wait_until(&:present?).click
        sleep 3
      end
    end
  end
end 