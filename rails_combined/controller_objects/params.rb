require 'uri'
class Params
  def initialize(req, route_params = {})
    @req = req
    @route_params = {}

    @route_params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
    @route_params.merge!(parse_www_encoded_form(req.body)) if req.body
    @route_params.merge!(route_params)
  end

  def [](key)
    @route_params[key.to_s] || @route_params[key.to_sym]
  end

  def to_s
    @route_params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  def parse_www_encoded_form(www_encoded_form)
    parse = URI::decode_www_form(www_encoded_form);
    # debugger
    # parse = www_encoded_form.split(/\=|\&|\|/)

    modified_parse = modify_parse(parse)

    parse_to_hash_improved(modified_parse)

  end

  def modify_parse(parse)
    h = Hash.new
    parse.each do |arr|
      h[parse_key(arr[0])] = arr[1]
    end
    h
  end

  def parse_to_hash_improved(hashes)
    h = Hash.new
    hashes.keys.each do |keys|
      current = h
      keys[0..-2].each do |key|
        current[key] ||= {}
        current = current[key]
      end
      current[keys.last] = hashes[keys]
    end
    h
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
