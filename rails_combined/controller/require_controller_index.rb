require "./../controller_objects/controller_base"
require "./../model/require_model_index"


Dir['./../controller/*.rb'].select do |file|
  file.split(".").first != 'require_model_index'
end.each do |file|
  require "#{file}"
end
