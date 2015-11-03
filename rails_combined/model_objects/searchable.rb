
module Searchable
  def where(params)
    # ...
    keys = []
    val = []
    params.each do |k,v|
      keys << k
      val << v
    end
    keys = keys.join("= ? AND ").concat("= ?")
    data = DBConnection.execute(<<-SQL, val)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{keys}
    SQL
    self.parse_all(data)
  end
end
