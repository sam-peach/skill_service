 module V1 
  class IndeedScraper < V1::AbstractScraper
    include V1::StaticPageCollector

    SITE_URL         = "https://www.indeed.com/jobs?q=software+engineer&l=New+York%2C+NY"
    JOB_TTILE_CSS    = "a[class*=jobtitle]"
    BODY_TEXT_CSS    = "div[id*='jobDescriptionText']"
    PAGINATION_CLASS = "np"
    PAGINATION_CSS   = "span[class='#{PAGINATION_CLASS}']"
    PAGE_DEPTH       = 10

    private 
  
    def open_job(link_tag)
      @browser
        .a(title: link_tag.text.strip)
        .wait_until(timeout: 3, &:present?)
        .click(:command)
    end

    def go_to_next_page
      @browser
        .span(class: PAGINATION_CLASS)
        .wait_until(timeout: 3, &:present?)
        .click!
    end
  end
end