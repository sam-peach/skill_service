
desc "scrape task"
task scrape_task: :environment do
  ScraperProcessor.process(site: "indeed")
end