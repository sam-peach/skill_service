desc "scrape task"
task scrape_task: :environment do
  ["Indeed", "BuiltInNyc"].each do |site|
    ScraperProcessor.process(site: site)
  end
end