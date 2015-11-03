require 'sqlite3'
require 'byebug'
# https://tomafro.net/2010/01/tip-relative-paths-with-file-expand-path
ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')

def findFileType(type)
  Dir.chdir('../database')
  Dir.entries('.').find {|file_name| file_name.split(".").last == type}
end
CATS_SQL_FILE = findFileType('sql')



def set_up_DB(sqlFile)
  if(findFileType('db').nil?)
    sql_file_name = sqlFile.split(".")[0]
    command = "cat '#{sqlFile}' | sqlite3 '#{sql_file_name}.db'"
    system("#{command}")
  end
  findFileType('db')
end

CATS_DB_FILE = set_up_DB(CATS_SQL_FILE)


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
