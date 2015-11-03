
class Human < SQLObject
  has_many :cats
end

Human.table_name = "Humans"
