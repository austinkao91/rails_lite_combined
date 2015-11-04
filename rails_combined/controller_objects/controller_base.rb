require './../controller_objects/params'
require './../controller_objects/session'
require './../controller_objects/flash'


class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req,route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Response already built!" if already_built_response?
    res.status = 302
    res.header["location"] = url
    session.store_session(res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Response already built!" if already_built_response?
    @res.content_type = content_type
    @res.body = content
    session.store_session(res)
    @already_built_response = true
    flash.store_session(res)
  end

  def render(template_name)
    class_name = self.class.to_s.split('Controller').first.downcase
    controller_name = "#{class_name}_controller"
    file = File.read("./../views/#{controller_name}/#{template_name}.html.erb")
    new_file = ERB.new(file).result(binding)
    render_content(new_file, 'text/html')
    flash.store_session(res)
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name)
    self.send(name)
    unless already_built_response?
      render(name)
    end
  end

end
