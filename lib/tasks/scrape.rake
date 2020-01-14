desc "scrape task"
task scrape_task: :environment do
  ["Indeed", "BuiltInNyc"].each do |site|
    scrape_class = "V1::#{site}Scraper".constantize
    scrape_class.new.scrape
  end
end