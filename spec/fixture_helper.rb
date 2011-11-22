require 'yaml'

class FixtureHelper
  FIXTURE_FILES = Dir[File.expand_path("#{Dir.pwd}/spec/fixtures/*.yml")]

  class << self
    def method_missing(sym, *args, &block)
      if fixture_exists? sym
        load_fixture(sym)
      else
        super(sym, args, block)
      end
    end

    def load_fixture name
      instance_variable_get("@#{name}") || instance_variable_set("@#{name}", YAML.load_file(FIXTURE_FILES[line_of_fixture(name)]))
    end

    def fixture_exists? name
      !line_of_fixture(name).nil?
    end

    def line_of_fixture name
      FIXTURE_FILES.map { |f| f.split('/').last }.index("#{name}.yml")
    end
  end
end

