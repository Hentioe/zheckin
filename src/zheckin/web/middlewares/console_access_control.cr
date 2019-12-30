module Zheckin::Web
  class ConsoleAccessControlHandler < Kemal::Handler
    only ["/console/*"], "GET"
    only ["/console/*"], "POST"
    only ["/console/*"], "PUT"
    only ["/console/*"], "DELETE"

    def call(context)
      return call_next(context) unless only_match?(context)
      if account = Store::Account.get(context.account_id?)
        context.set "account", account
        call_next context
      else
        json = Router.json_unauthorized(context)
        context.response.print json
        context.response.close
      end
    end
  end
end
