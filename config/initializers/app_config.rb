require 'yaml'

yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'application.yml'))).result)
ENV = HashWithIndifferentAccess.new(yaml_data)