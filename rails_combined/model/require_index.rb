require './../model_objects/sql_object'

Dir['./../model/*.rb'].select do |file|
  file.split(".").first != 'require_index'
end.each do |file|
  require "#{file}"
end
