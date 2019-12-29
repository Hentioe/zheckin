require "spec"
require "spec-kemal"
require "../src/zheckin"

def with_auth(token)
  HTTP::Headers{"Cookie" => "token=#{token}"}
end

def with_json
  HTTP::Headers{"Content-Type" => "application/json"}
end
