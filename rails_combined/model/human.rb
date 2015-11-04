class Human < SQLObject
  has_many :cats
  def name
    "#{fname} #{lname}"
  end
end

# specified as the pluralized humans in ruby is unfortunately humen
Human.table_name = "Humans"
