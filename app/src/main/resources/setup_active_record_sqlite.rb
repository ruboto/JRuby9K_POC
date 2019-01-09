puts 'Setup sqlite database'

require 'active_record/deprecated_finders'
require 'active_record'
require 'paranoia'
require 'rails/observers/activerecord/active_record'

LOG_DIR = "#{DATA_DIR}/log"
Dir.mkdir LOG_DIR unless File.exists? LOG_DIR
ActiveRecord::Base.logger = AndroidLogging::Logger

ActiveRecord::Base.default_timezone = :utc
logger.info "Using database at: #{DB_DIR}"

connection_options = {
  adapter: 'sqlite3',
  driver: 'org.sqldroid.SQLDroidDriver',
  url: "jdbc:sqldroid:#{DB_DIR}?timeout=60000&retry=1000",
  database: DB_DIR,
  pool: 50,
}

audit_log_connection_options = {
  adapter: 'sqlite3',
  driver: 'org.sqldroid.SQLDroidDriver',
  url: "jdbc:sqldroid:#{DB_DIR_AUDIT_LOG}?timeout=5000&retry=1000",
  database: DB_DIR_AUDIT_LOG,
  pool: 50,
}

ActiveRecord::Base.configurations = {
  ENVIRONMENT => connection_options,
  "#{ENVIRONMENT}_audit_log" => audit_log_connection_options,
}

# org.sqldroid.Log.LEVEL = android.util.Log::VERBOSE
# org.sqldroid.SQLDroidResultSet.dump = true

DATABASE_EXISTS = File.exists?(DB_DIR)
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[ENVIRONMENT])
AuditLog.establish_connection(ActiveRecord::Base.configurations["#{ENVIRONMENT}_audit_log"])

unless File.exists?(DB_DIR_AUDIT_LOG)
  logger.info 'Generating new audit log database'
  AuditLog.connection.execute <<-EOT
    CREATE TABLE "audit_logs" (
      "id" integer primary key autoincrement NOT NULL,
      "operation" varchar(6) NOT NULL,
      "model_name" varchar(32) NOT NULL,
      "record_id" varchar(22) NOT NULL,
      "new_values" text,
      "source" varchar(255) NOT NULL,
      "user_id" varchar(255),
      "expired" boolean DEFAULT 'f' NOT NULL,
      "flush" boolean,
      "created_at" datetime NOT NULL,
      "updated_at" datetime NOT NULL
    )
  EOT
end

require 'time_of_day'

ArJdbc::SQLite3::NATIVE_DATABASE_TYPES[:uid] = 'VARCHAR(22) NOT NULL PRIMARY KEY'

# FIXME(uwe):  Remove when fixed in ARJDBC 1.3.0
class ActiveRecord::ConnectionAdapters::JdbcAdapter
  def table_exists?(name)
    tables.include?(name.to_s)
  end
end
# EMXIF

module ::ArJdbc
  module SQLite3
    # FIXME(uwe): Needed for our uid column type
    # FIXME(uwe): Rewrite to use alias_method_chain.
    # FIXME(uwe): Simplify when we stop using ARJDBC 1.3.x
    puts "ArJdbc::VERSION: #{ArJdbc::VERSION.inspect}"
    if Gem::Version.new(ArJdbc::VERSION) < Gem::Version.new('1.4.0.dev')
      module Column
        def simplified_type(field_type)
          case field_type
          when /boolean/i then
            :boolean
          when /text/i then
            :text
          when /varchar/i then
            if name == 'id'
              @limit = nil
              @null = nil
              :uid
            else
              :string
            end
          when /int/i then
            :integer
          when /float/i then
            :float
          when /real|decimal/i then
            @scale == 0 ? :integer : :decimal
          when /datetime/i then
            :datetime
          when /date/i then
            :date
          when /time/i then
            :time
          when /blob/i then
            :binary
          else
            super
          end
        end
      end
    else
      class Column
        def simplified_type(field_type)
          case field_type
          when /boolean/i then
            :boolean
          when /text/i then
            :text
          when /varchar/i then
            if name == 'id'
              @limit = nil
              @null = nil
              :uid
            else
              :string
            end
          when /int/i then
            :integer
          when /float/i then
            :float
          when /real|decimal/i then
            @scale == 0 ? :integer : :decimal
          when /datetime/i then
            :datetime
          when /date/i then
            :date
          when /time/i then
            :time
          when /blob/i then
            :binary
          else
            super
          end
        end
      end
    end
    # EMXIF

    def insert_sql(sql, name = nil, pk = nil, id_value = nil, sequence_name = nil)
      log(sql, name) { @connection.execute_update(sql) }
      id_value || last_insert_id
    end

    def indexes(table_name, name = nil)
      result = select_rows("SELECT name, sql FROM sqlite_master WHERE tbl_name = #{quote_table_name(table_name)} AND type = 'index'", name)
      result.collect do |row|
        name = row[0]
        index_sql = row[1]
        unique = (index_sql =~ /unique/i)
        if index_sql
          cols = index_sql.match(/\((.*)\)/)[1].gsub(/,/, ' ').split.map do |c|
            match = /^"(.+)"$/.match(c); match ? match[1] : c
          end
          ::ActiveRecord::ConnectionAdapters::IndexDefinition.new(table_name, name, unique, cols)
        end
      end.compact
    end

    # FIXME(uwe): Only needed for DB created with Nettbuss 1.2.x
    def primary_key(*)
      'id'
    end
    # EMXIF

  end
end

# FIXME(uwe): To silence AR 4.2 warnings.  Remove after update to AR 5.0.
ActiveRecord::Base.raise_in_transactional_callbacks = true
# EMXIF

# FIXME(uwe):  Rename AuditLog#model_name to record_type
# FIXME(uwe):  https://github.com/rails/rails/issues/18338
# FIXME(uwe):  Remove this monkey patch
module ActiveRecord
  module AttributeMethods
    module ClassMethods
      def dangerous_attribute_method?(name) # :nodoc:
        name != 'model_name' && method_defined_within?(name, Base)
      end
    end
  end
end
# EMXIF
