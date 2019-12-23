require "./config/*"
require "./db/migrations/*"
require "sam"

load_dependencies "jennifer"

# Here you can define your tasks
# desc "with description to be used by help command"
# task "test" do
#   puts "ping"
# end

Sam.help
