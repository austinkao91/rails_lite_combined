require './../model_objects/sql_object'

Dir['./../model/*.rb'].select do |file|
  file.split(".").first != 'require_model_index'
end.each do |file|
  require "#{file}"
end
