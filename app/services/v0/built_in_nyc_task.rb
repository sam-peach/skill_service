# class BuiltInNycTask
#   include Delayed::RecurringJob
#   run_at '9:00am'
#   run_at '2:00pm'
#   run_at '6:00pm'
#   timezone 'US/Eastern'
#   def perform
#     ScraperProcessor.delay.process(site: "BuiltInNyc")
#   end

#   def max_attempts
#     1
#   end
# end