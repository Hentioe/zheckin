module Zheckin::Web::Router
  macro registry(module_name, *args)
    {{ module_name = module_name.camelcase }}
    {% if args.size > 0 %}
      {{@type}}::{{module_name.id}}.init({{*args}})
    {% else %}
      {{@type}}::{{module_name.id}}.init
    {% end %}
  end

  macro resources(name, *args, options = {:prefix => nil})
    module {{name.camelcase.id}}
      {% if options[:prefix] != nil %}
        {% for method in HTTP_METHODS %}
          def self.{{method.id}}(path : String, &block : HTTP::Server::Context -> _)
            path = "{{options[:prefix].id}}#{path}"
            raise Kemal::Exceptions::InvalidPathStartException.new({{method}}, path) unless Kemal::Utils.path_starts_with_slash?(path)
            Kemal::RouteHandler::INSTANCE.add_route({{method}}.upcase, path, &block)
          end
        {% end %}

        {{default_filter_path = options[:prefix] + "/*"}}
        {% for type in ["before", "after"] %}
          {% for method in FILTER_METHODS %}
            def self.{{type.id}}_{{method.id}}(path : String = {{default_filter_path}}, &block : HTTP::Server::Context -> _)
              if path != {{default_filter_path}}
                path = "{{options[:prefix].id}}#{path}"
              end
              Kemal::FilterHandler::INSTANCE.{{type.id}}({{method}}.upcase, path, &block)
            end
          {% end %}
        {% end %}
      {% end %}

      def self.json(context, data, status_code = 200)
        context.response.content_type = "application/json"
        context.response.status_code = status_code

        case status_code
        when 404
          context.set "body", data.to_json
        else
          data.to_json
        end
      end

      def self.init({{*args}})
        {{yield}}
      end

      def self.json_error(context, msg : String, status_code = 201)
        json(context, {msg: msg}, status_code)
      end

      def self.json_success(context, **args)
        json(context, {msg: "OK"}.merge(args))
      end
    end
  end
end

require "./router/*"
