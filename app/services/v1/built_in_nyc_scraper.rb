module V1 
  class BuiltInNycScraper < V1::AbstractScraper
    include V1::StaticPageCollector

    SITE_URL         = "https://www.builtinnyc.com/jobs"
    JOB_TTILE_CSS    = "h2[class*='title']"
    BODY_TEXT_CSS    = "div[class*='job-description']"
    PAGINATION_TITLE = "Go to next page"
    PAGINATION_CSS   = "a[title='#{PAGINATION_TITLE}']"
    PAGE_DEPTH       = 1

    private

    def pre_collect
      click_job_category
    end

    def click_job_category
      @browser
        .link("data-facet-alias".to_sym => "job-category_developer-engineer")
        .wait_until(timeout: 3, &:present?)
        .click!

      sleep 2
    end

    private 
  
    def open_job(link_tag)
      @browser
        .h2(text: link_tag.text.strip)
        .wait_until(timeout: 3, &:present?)
        .click(:command)
    end

    def pre_page_collect
      hidden_links = @browser.divs(class: "hide")

      hidden_links.each do |div|
        @browser.execute_script('arguments[0].classList.remove("hide");', div)
      end
    end

    def go_to_next_page
      @browser.a(title: PAGINATION_TITLE)
        .wait_until(timeout: 3, &:present?)
        .click!
    end
  end
end