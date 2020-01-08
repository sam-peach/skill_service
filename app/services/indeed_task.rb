class IndeedTask
  include Delayed::RecurringJob
  run_at '8:00am' 
  run_at '1:00pm'
  run_at '5:00pm'
  timezone 'US/Eastern'
  def perform
    ScraperProcessor.delay.process(site: "indeed")
  end

  def max_attempts
    1
  end
end