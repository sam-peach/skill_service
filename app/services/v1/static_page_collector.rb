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
      @word_list = []

      links.each do |link_tag|
        puts "> SCRAPING #{link_tag.text.strip}"
        begin
          split_and_push(text: link_tag.text)

          open_job(link_tag)
          sleep 1

          @browser.windows.last.use

          job_text_body = Nokogiri::HTML(@browser.html).css(self.class::BODY_TEXT_CSS) 

          recurse_and_push(job_text_body)

          @browser.windows.last.close if @browser.windows.count > 1
        rescue => e
          puts ">>>> #{e}"
          next
        end
      end
      @word_list.uniq
    end

    def split_and_push(text:)
      @payload.push(*text.gsub(/[^\+#\w ]/, " ").split(" "))
    end

    def recurse_and_push(node)
      if node.children.present?
        node.children.each do |child|
          recurse_and_push(child)
        end
      end

      @word_list.push(*node.text.gsub(/[^\+#\w ]/, " ").split(" ").uniq)
    end
  end
end