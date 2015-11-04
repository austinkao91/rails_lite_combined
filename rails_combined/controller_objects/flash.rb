require 'webrick'

class Flash
  attr_reader :flash, :flash_now
  def initialize(req)
    @flash_now = retrieve_flash_cookie(req)
    @flash = {}
  end

  def retrieve_flash_cookie(req)
    cookies = req.cookies.select{ |key| key.name == '_rails_lite_app'} if req
    flash_cookie = cookies.find {|cookie| cookie.value["flash"] } if cookies
    flash_data = JSON.parse(flash_cookie.value)["flash"] if flash_cookie
    flash_data ||= {}
  end

  def [](key)
    @flash[key] || @flash_now[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def now
    @flash_now
  end

  def store_session(res)
    cookie = WEBrick::Cookie.new('_rails_lite_app', {"flash" => @flash}.to_json)
    res.cookies << cookie
  end

end
