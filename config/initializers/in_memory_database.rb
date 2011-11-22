# http://calicowebdev.com/2011/01/25/rails-3-sqlite-3-in-memory-databases/
def in_memory_database?
  Rails.env == "test" &&
    (ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLiteAdapter ||
      ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLite3Adapter) &&
        Rails.configuration.database_configuration['test']['database'] == ':memory:'
end

if in_memory_database?
  puts "creating sqlite in memory database"
  load "#{Rails.root}/db/schema.rb"
end

