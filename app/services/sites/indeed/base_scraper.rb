module Sites
  module Indeed
    class BaseScraper < ScraperProcessor
      SITE_URL           = "https://www.indeed.com/jobs?q=software+engineer&l=New+York%2C+NY"
      JOB_TTILE_CSS_TAG  = ".title"
      BODY_TEXT_CSS_TAG  = "#jobDescriptionText"
      PAGINATION_CSS_TAG = ".pagination"

      def self.scrape
        puts "==========================="
        puts "PREPARING TO SCRAPE INDEED"
        puts "==========================="

        start_browser_and_got_to_page(url: SITE_URL)
     
        @payload = []
        get_pagination_links
        
        @page_links.each do |page|
          data = Nokogiri::HTML(@browser.html)
          job_title_links = data.css(JOB_TTILE_CSS_TAG)
          
          @payload.push(*interate_though_links(links: job_title_links))
          go_to_next_page
        end
        
        puts "==========================="
        puts "SCRAPE COMPLETE"
        puts "==========================="

        puts "==========================="
        puts "CLOSING BROWSER"
        puts "==========================="

        close_browser

        puts "==========================="
        puts "SENDING TO WORD PROCESSOR"
        puts "==========================="

        WordsProcessor.process(data: @payload)
      end
  
      private
  
      def self.interate_though_links(links:)
        word_list = []
  
        links.css('a').each do |link_tag|
          puts "> SCRAPING #{link_tag.text.strip}"
          begin
            split_and_push(text: link_tag.text)

            @browser.a(title: link_tag.text.strip).wait_until(timeout: 4, &:present?).click(:command)
            sleep 1

            @browser.windows.last.use
            new_page_data = Nokogiri::HTML(@browser.html)
            job_text_body = new_page_data.css(BODY_TEXT_CSS_TAG) 

            word_list.push(*job_text_body.inner_html.gsub(/\W/, " ").split(" ").uniq) if job_text_body.present?
            @browser.windows.last.close if @browser.windows.count > 1
          rescue => e
            puts ">>>> #{e}"
            next
          end
        end
        word_list
      end
  
      def self.go_to_next_page
        link = @page_links.css('a')[@page_number_idx]
        @browser.span(text: link.text, class: "pn").wait_until(&:present?).click!
        sleep 1
        @page_number_idx += 1
      end

      def self.get_pagination_links
        @data = Nokogiri::HTML(@browser.html) 
        @page_number_idx = 0
        @page_links = @data.css(PAGINATION_CSS_TAG).css('a')
      end

      def self.split_and_push(text:)
        @payload.push(*text.gsub(/\W/, " ").split(" "))
      end
    end
  end
end 