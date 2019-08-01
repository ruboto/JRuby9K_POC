puts 'Setup simple sqlite database'

puts "require 'active_record'"
require 'active_record'

puts "require 'active_record/base'"
require 'active_record/base'

files_dir = APPLICATION_CONTEXT.files_dir
raise 'Could not access internal storage!' unless files_dir

DATA_DIR = files_dir.path
puts "DATA_DIR: #{DATA_DIR.inspect}"
FileUtils.mkdir_p(DATA_DIR)

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.default_timezone = :utc
logger.info "Using database at: #{DB_DIR}"

connection_options = {
  adapter: 'sqlite3',
  driver: 'org.sqldroid.SQLDroidDriver',
  url: "jdbc:sqldroid:#{DB_DIR}?timeout=60000&retry=1000",
  database: DB_DIR,
  pool: 50,
}

ActiveRecord::Base.configurations = {
  ENVIRONMENT => connection_options,
}

# org.sqldroid.Log.LEVEL = android.util.Log::VERBOSE
# org.sqldroid.SQLDroidResultSet.dump = true

ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[ENVIRONMENT])
