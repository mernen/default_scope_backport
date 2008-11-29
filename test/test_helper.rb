ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "/../../../.."

require "test/unit"
require File.expand_path(File.join(ENV["RAILS_ROOT"], "config/environment.rb"))
require "active_record/fixtures"
require File.dirname(__FILE__) + "/../init.rb"

# Make with_scope public for tests
class << ActiveRecord::Base
  public :with_scope, :with_exclusive_scope
end

def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + "/database.yml"))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

  db_adapter = ENV["DB"]

  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||=
    begin
      require "rubygems"
      require "sqlite3"
      "sqlite3"
    rescue MissingSourceFile
      begin
        require "sqlite"
        "sqlite"
      rescue MissingSourceFile
      end
    end

  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3."
  end

  ActiveRecord::Base.establish_connection(config[db_adapter])
  load File.dirname(__FILE__) + "/schema.rb"
end

def load_fixtures
  Fixtures.new(nil, "developers", nil,
    File.dirname(__FILE__) + "/fixtures/developers.yml").insert_fixtures
end
