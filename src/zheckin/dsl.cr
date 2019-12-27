module Zheckin
  macro get_app_env(name)
    ENV["ZHECKIN_{{name.upcase.id}}"]
  end
end
