require "dotenv"
require "./zheckin/dsl"

Dotenv.load %(#{Zheckin.get_app_env?("env") || "dev"}.env)

require "./zheckin/cli"
require "./zheckin/store"
require "./zheckin/zhihu"

module Zheckin
  VERSION = "0.1.0"
end
