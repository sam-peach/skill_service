 module V1 
  module StaticPageCollector
    private

    def page_links
      Nokogiri::HTML(@browser.html).css(self.class::PAGINATION_CSS)
    end

    def job_title_links
      Nokogiri::HTML(@browser.html).css(self.class::JOB_TTILE_CSS)
    end

    def interate_though_links(links:)
      links.each do |link_tag|
        @word_list = ""

        title = link_tag.text.strip
        puts "> SCRAPING #{title}"
        begin
          @word_list << title.upcase + " "

          open_job(link_tag)
          sleep 1

          @browser.windows.last.use

          job_text_body = Nokogiri::HTML(@browser.html).css(self.class::BODY_TEXT_CSS) 
          job_text_body.xpath('.//text() | text()').each do |text_block|
            @word_list << text_block.text.upcase + " "
          end

          @browser.windows.last.close if @browser.windows.count > 1

          @word_processor.new(@word_list).process if @word_list.present?
        rescue => e
          puts ">>>> #{e}"
          next
        end
      end
    end
  end
end