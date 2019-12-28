require "clicr"

module Zheckin::CLI
  macro def_action(action, exclude = false)
    def cli_run
      Clicr.create(
        name: "zheckin",
        info: "Zhihu Club Check-In Hosting",
        action: {{action}},
        variables: {
          port: {
            info:    "Web server port",
            default: 8080,
          },
          log_level: {
            info:    "Log level",
            default: "info",
          },
        }
      )
    end

    begin
      cli_run unless {{exclude}}
    rescue ex : Clicr::Help
      puts ex; exit 0
    rescue ex : Clicr::ArgumentRequired | Clicr::UnknownCommand | Clicr::UnknownOption | Clicr::UnknownVariable
      abort ex
    rescue ex
      raise ex
    end
  end
end
