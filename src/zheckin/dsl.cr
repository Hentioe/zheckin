module Zheckin
  macro get_app_env(name)
    ENV["ZHECKIN_{{name.upcase.id}}"]
  end

  macro get_app_env?(name)
    ENV["ZHECKIN_{{name.upcase.id}}"]?
  end
end

macro defdelegate(name, *args, to method)
  def self.{{name.id}}(*args, **options)
    {{method.id}}(*args, **options)
  end
end
