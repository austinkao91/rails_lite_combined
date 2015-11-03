require 'json'
require 'webrick'

class Session
    # find the cookie for this app
    attr_reader :cookie, :data
    # deserialize the cookie into a hash
    def initialize(req)
      @cookie = req.cookies.find{ |key| key.name == '_rails_lite_app'} if req

      @data = @cookie ? JSON.parse(@cookie.value) : {}
    end

    def [](key)
      @data[key]
    end

    def []=(key, val)
      @data[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @data.to_json)
    end
end
