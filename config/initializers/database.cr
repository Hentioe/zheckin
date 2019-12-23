require "jennifer"
require "jennifer_sqlite3_adapter"

Jennifer::Config.configure do |conf|
  conf.host = "."
  conf.adapter = "sqlite3"
  conf.local_time_zone_name = "UTC"

  env = ENV["ZHECKIN_ENV"]? || "dev"
  conf.host = ENV["ZHECKIN_DATABASE_HOST"]? || "./data"

  Dir.mkdir(conf.host) unless File.exists?(conf.host)

  conf.db = "#{env}.db"

  level = env == "prod" ? Logger::INFO : Logger::DEBUG
  conf.logger.level = level
end

if uri = ENV["ZHECKIN_DATABASE_URI"]?
  Jennifer::Config.from_uri uri
end
