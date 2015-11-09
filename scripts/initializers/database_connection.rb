require 'pg'
require 'yaml'
require 'pry'

class DatabaseConnection

  def initialize(config_hash)
    @connection = PG::Connection.new(
      user: config_hash["user"],
      password: config_hash["password"],
      dbname: config_hash["dbname"],
      host: config_hash["host"],
      port: config_hash["port"]
    )
  end

  def method_missing(name, *args, &block)
    @connection.send(name, *args, &block)
  end

end

config_file = File.expand_path("../../configurations/db_config.yml", __FILE__)
settings = YAML.load(File.read(config_file))["acumen"]
ACUMEN = DatabaseConnection.new(settings)
