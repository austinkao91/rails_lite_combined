require './../database/db_connection'
require 'active_support/inflector'
require '../model_objects/searchable.rb'
require '../model_objects/associations.rb'

class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    # ...
    data = DBConnection.execute2(<<-SQL).first.map {|col| col.to_sym}
      SELECT
        *
      FROM
        "#{self.table_name}"
      LIMIT
        0
    SQL
    data
  end

  def self.finalize!
    column_names = self.columns

    column_names.each do |col|

      define_method("#{col}") do
        attributes[col]
      end

      define_method("#{col}=") do |val|
        attributes[col] = val
      end

    end


  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name ||=("#{self}".downcase.pluralize)
  end

  def self.all
    # ...
    data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
       "#{self.table_name}"
    SQL
    self.parse_all(data)
  end

  def self.parse_all(results)
    # ...
    results.map{|attr| self.new(attr) }
  end

  def self.find(id)
    id = id.to_i
    # ...
    data = DBConnection.execute(<<-SQL, id: "#{id}")
      SELECT
        *
      FROM
       "#{self.table_name}"
      WHERE
        id = :id
    SQL
    self.parse_all(data).first
  end

  def initialize(params = {})
    col = self.class.finalize!
    params.each do |k,v|
      k = k.to_sym
      raise "unknown attribute \'#{k}\'" unless col.include?(k)
      self.send("#{k}=", v)
    end

    # ...
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
    col_arr = self.class.columns.map do |col|
      self.send("#{col}")
    end
  end

  def insert
    # ...
    col_names = self.class.columns
    col = col_names.join(",")
    col_str = "#{self.class.table_name} (#{col})"

    question_marks = "?,"*col_names.length
    question = "(#{question_marks}"
    question.chop!.concat(")")
    DBConnection.execute(<<-SQL, self.attribute_values)
      INSERT INTO
        #{col_str}
      VALUES
        #{question}
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    # ...
    col_names = self.class.columns
    col = col_names.join(" = ?,")
    col.concat("= ?")
    DBConnection.execute(<<-SQL, self.attribute_values.push(self.id))
      UPDATE
        #{self.class.table_name}
      SET
        #{col}
      WHERE
        id = ?
    SQL
  end

  def save
    # ...
    self.id.nil? ? self.insert : self.update

  end
end
