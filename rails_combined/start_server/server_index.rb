require "./../routes/routePaths"
require 'byebug'

router = Router.new

router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^$"), CatsController, :index
  get Regexp.new("^/cats/new$"), CatsController, :new
  get Regexp.new("^/cats/(?<cat_id>\\d+)"), CatsController, :show
  post Regexp.new("^/cats"), CatsController, :create
end

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
