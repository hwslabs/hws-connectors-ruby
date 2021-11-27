module Hws::Connectors::Yesbank
  class Base < Hws::Connectors
    NAME = 'yesbank'
    option :configs, -> { YAML.load_file(File.join(Hws::Connectors.root_dir, 'config', "#{NAME}.yml")) }
  end
end
