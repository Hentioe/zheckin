require "kemal"
require "./web/*"
require "./web/middlewares/*"

module Zheckin::Web
  KEMAL_ENV =
    case Zheckin.get_app_env?("env")
    when "dev", nil
      "development"
    when "prod"
      "production"
    else
      Zheckin.get_app_env("env")
    end

  add_context_storage_type(Zheckin::Model::Account)

  def self.start(port : Int)
    serve_static({"gzip" => false})
    public_folder "static"
    Kemal.config.logger = LoggerHandler.new(Logging.get_logger)
    Kemal.config.env = KEMAL_ENV

    add_handler AuthHandler.new
    add_handler ConsoleAccessControl.new

    Router.registry :page
    Router.registry :sign_in
    Router.registry :console_api

    Kemal.run(args: nil, port: port)
  end
end
