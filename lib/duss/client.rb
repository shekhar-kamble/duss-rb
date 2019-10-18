module Duss
  class Client
    
    URL = Duss::HOST
    
    def connection_options
      @connection_options = lambda do |connection|
        connection.request :url_encoded
        connection.adapter Faraday.default_adapter
      end
    end

    def initialize(client_id, api_token)
      @client_id = client_id
      @api_token = api_token
      @conn = Faraday.new(URL, &connection_options)
      add_auth_headers
    end

    def get_connection_object
      @conn
    end

    def add_auth_headers
      add_header 'X-Client-Id', @client_id
      add_header 'Authorization', "Bearer #{@api_token}"
    end

    def self.define_http_verb(http_verb)
      define_method http_verb do |*args|
        request = args[0] || "/"
        params = args[1] || {}
        @request = request
        method = @conn.method(http_verb)
        puts @conn
        @response = method.call(@request, params)
      end
    end

    define_http_verb :get
    define_http_verb :post
    define_http_verb :patch
    define_http_verb :delete


    def shorten(url)
      @response = post('shorten', {'url' => url})
      raise RuntimeError.new(JSON.parse(@response.body)['message']) if @response.status != 201
      @response.body
    end

    private
    def add_header(key, value)
      previous_headers = get_connection_object.headers
      get_connection_object.headers = previous_headers.merge({key => value})
    end
  end
end