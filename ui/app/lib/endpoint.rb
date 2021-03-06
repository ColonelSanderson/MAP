class Endpoint

  attr_reader :uri, :method

  def initialize(method, uri, opts)
    @method = method
    @uri = uri
    @valid_params = {'splat' => ParamDef.new(String, 'Rest of URL', {:optional => true}),
                     'authenticity_token' => ParamDef.new(String, 'CSRF token', {:optional => true})}
    @opts = opts
  end

  def self.post(uri, opts = {}, &block)
    e = new(:post, uri, opts)
    block ? e.finish(&block) : e
  end

  def self.get(uri, opts = {}, &block)
    e = new(:get, uri, opts)
    block ? e.finish(&block) : e
  end

  ParamDef ||= Struct.new(:type, :description, :options)

  def param(name, type, description, opts = {}, &block)
    name = name.to_s
    raise "Can't name a parameter 'captures', sorry" if name == 'captures'

    @valid_params[name] = ParamDef.new(type, description, opts)
    block ? self.finish(&block) : self
  end

  def check_params(params)
    params.delete('captures')
    # Any parameters not in our list are not allowed
    params.each do |p, v|
      unless @valid_params[p]
        raise "Unrecognised parameter: #{p} for endpoint #{@method} #{@uri}"
      end
    end

    # Missing parameters are bad too
    @valid_params.select {|k, v| !v.options[:optional]}.each do |param, _|
      unless params[param]
        raise "Missing value for required parameter: #{param}"
      end
    end

    # Finally, apply our type checks
    params.keys.each do |param|
      type = @valid_params[param].type

      params[param] = if type.is_a?(Class) && Kernel.respond_to?(type.name.intern)
                        # Integer, String and friends
                        Kernel.send(type.name.intern, params[param])
                      elsif type.is_a?(Array)
                        if params[param] && !params[param].is_a?(Array)
                          raise "Parameter #{param} must be an array.  Please send as #{param}[]"
                        else
                          if type[0].is_a?(Class) && Kernel.respond_to?(type[0].name.intern)
                            Array(params[param]).map {|val| Kernel.send(type[0].name.intern, val)}
                          else
                            Array(params[param]).map {|val| type[0].parse(val)}
                          end
                        end
                      elsif type.included_modules.include?(DTO)
                        type.from_hash(params[param])
                      elsif type.respond_to?(:parse)
                        type.parse(params[param])
                      else
                        raise "Don't know how to deal with type #{type}"
                      end
    end
  end

  def finish(&block)
    opts = @opts
    endpoint = self

    # Delete any matching route from a previous reload
    if MAPTheApp.development?
      MAPTheApp.instance_eval do
        new_uri = compile(endpoint.uri)

        method_routes = @routes.fetch(endpoint.method.to_s.upcase, [])

        # Don't care about these in dev anyway, and they leak...
        @routes["HEAD"] = []

        route_to_replace = method_routes.find do |route_def|
          uri = route_def[0]

          uri.safe_string == new_uri.safe_string
        end

        if route_to_replace
          method_routes.delete(route_to_replace)
        end
      end
    end

    MAPTheApp.send(@method, @uri) do
      in_time = Time.now
      endpoint.check_params(params)

      # Within Sinatra's handle block, self is bound to the application instance
      # (which is what we want).
      #
      # However, the block passed in was created in the context of the
      # application class (not in the instance), which won't give us access to
      # things like ERB helper methods.
      #
      # So, use instance_eval to evaluate the block in the right context.
      app_instance = self

      Ctx.open do
        Ctx.get.session = session || {}
        begin
          return app_instance.instance_eval(&block)
        rescue MAPAPIClient::NotFoundError
          return [404, {}, "Not Found"]
        rescue MAPAPIClient::SessionGoneError
          # The backend session gone dropped.  You're logged out now.
          session[:api_session_id] = nil
          session[:username] = nil

          redirect '/'
        end
      end
    end
  end

end
