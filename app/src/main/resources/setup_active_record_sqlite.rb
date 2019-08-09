puts "Loading #{__FILE__}"

require 'fileutils'
require 'active_record'

files_dir = APPLICATION_CONTEXT.files_dir
raise 'Could not access internal storage!' unless files_dir

DATA_DIR = files_dir.path
puts "DATA_DIR: #{DATA_DIR.inspect}"
FileUtils.mkdir_p(DATA_DIR)

ENVIRONMENT = 'development'
DB_FILE = "#{DATA_DIR}/mybase-#{ENVIRONMENT}.sqlite"

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.logger.info "Using database at: #{DB_FILE}"

connection_options = {
  adapter: 'sqlite3',
  driver: 'org.sqldroid.SQLDroidDriver',
  url: "jdbc:sqldroid:#{DB_FILE}?timeout=60000&retry=1000",
  database: DB_FILE,
  pool: 50,
}

# org.sqldroid.Log.LEVEL = android.util.Log::VERBOSE
# org.sqldroid.SQLDroidResultSet.dump = true

db_exists = File.exist? DB_FILE

ActiveRecord::Base.establish_connection(connection_options)
ActiveRecord::Base.connection

unless db_exists
  ActiveRecord::Base.logger.info 'Create table'
  result = ActiveRecord::Base.connection.execute <<~DDL
    CREATE TABLE "counters" (
      "id" integer primary key autoincrement NOT NULL,
      "value" integer NOT NULL,
      "created_at" datetime NOT NULL,
      "updated_at" datetime NOT NULL
    )
  DDL
  puts "result: #{result.inspect}"
end

class Counter < ActiveRecord::Base
  include ActiveRecord::Validations
  validates :value, presence: true
end
