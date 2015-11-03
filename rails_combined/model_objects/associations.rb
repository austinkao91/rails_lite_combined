class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
    @class_name.constantize
  end

  def table_name
    # ...
    model_class.table_name
  end
end


class BelongsToOptions < AssocOptions
  def initialize(name, options = {} )
    # ...
    default = {foreign_key: "#{name}_id".to_sym, class_name: "#{name.to_s.capitalize}", primary_key: :id}
    # default.each do |k,v|
    #   options[k] ||= v
    # end
    options = default.merge(options)
    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # ...
    default = {foreign_key: "#{self_class_name.downcase}_id".to_sym, class_name: "#{name.to_s.capitalize.singularize}", primary_key: :id}
    options = default.merge(options)
    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
    opts = BelongsToOptions.new(name,options)
    self.assoc_options[name] = opts
    define_method("#{name}") do
      data = DBConnection.execute(<<-SQL, self.send(opts.foreign_key))
        SELECT
          #{opts.table_name}.*
        FROM
          #{opts.table_name}
        WHERE
          #{opts.table_name}.#{opts.primary_key} = ?
      SQL
      opts.model_class.parse_all(data).first
    end
  end

  def has_many(name, options = {})
    opts = HasManyOptions.new(name,self.table_name.singularize, options)
    define_method("#{name}") do
      data = DBConnection.execute(<<-SQL, self.send(opts.primary_key) )
        SELECT
          #{opts.class_name.constantize.table_name}.*
        FROM
          #{opts.class_name.constantize.table_name}
        WHERE
        #{opts.class_name.constantize.table_name}.#{opts.foreign_key} = ?
      SQL
      opts.model_class.parse_all(data)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method("#{name}") do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      data = DBConnection.execute(<<-SQL, self.send(through_options.primary_key) )
        SELECT
          #{source_options.table_name}.*
        FROM
          #{source_options.table_name}
        JOIN
          #{through_options.table_name}
        ON
          #{through_options.table_name}.#{source_options.foreign_key} = #{source_options.table_name}.#{source_options.primary_key}
        WHERE
          #{through_options.table_name}.#{through_options.primary_key} = ?
      SQL
      source_options.model_class.parse_all(data).first
    end
  end
end
