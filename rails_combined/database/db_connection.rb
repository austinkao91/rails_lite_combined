require 'sqlite3'

# looks in database folder to find a specific file extension
def findFileType(type)
  Dir.chdir('../database')
  Dir.entries('.').find {|file_name| file_name.split(".").last == type}
end

# SQL file is required to run the database
CATS_SQL_FILE = findFileType('sql')
raise "SQL FILE REQUIRED" if(CATS_SQL_FILE.nil?)

# automatically creates db file from sql file
def set_up_DB(sqlFile)
  if(findFileType('db').nil?)
    sql_file_name = sqlFile.split(".")[0]
    command = "cat #{sqlFile} | sqlite3 #{sql_file_name}.db"
    system( "echo `#{command}`")
  end
  findFileType('db')
end

# CATS_SQL_FILE and CATS_DB_FILE are constants used by the DBConnection class
# to execute
CATS_DB_FILE = set_up_DB(CATS_SQL_FILE)

# handles connection between the SQLObject and the database
class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{CATS_DB_FILE}'",
      "cat '#{CATS_SQL_FILE}' | sqlite3 '#{CATS_DB_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(CATS_DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    puts args[0]

    instance.execute(*args)
  end

  def self.execute2(*args)
    puts args[0]

    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def initialize(db_file_name)
  end
end
