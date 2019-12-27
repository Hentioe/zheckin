require "dotenv"
require "./zheckin/dsl"

env_config = %(#{Zheckin.get_app_env?("env") || "dev"}.env)
Dotenv.load(env_config) if File.exists?(env_config)

require "./zheckin/cli"
require "./zheckin/store"
require "./zheckin/zhihu"

module Zheckin
  VERSION = "0.1.0"
end
