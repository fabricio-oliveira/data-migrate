module DataMigrate
  module Tasks
    module DataMigrateTasks
      extend self
      def migrations_paths
        @migrations_paths ||= begin
          if defined? DataMigrate.config.data_migrations_path
            DataMigrate.config.data_migrations_path
          elsif Rails.application && Rails.application.paths["data/migrate"]
            Rails.application.paths["data/migrate"].to_a
          else
            "db/data/"
          end
        end
      end

      def migrate
        DataMigrate::DataMigrator.assure_data_schema_table
        target_version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 2
          DataMigrate::MigrationContext.new(migrations_paths).migrate(target_version)
        else
          paths = migrations_paths
          DataMigrate::DataMigrator.migrate(paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
        end
      end
    end
  end
end
