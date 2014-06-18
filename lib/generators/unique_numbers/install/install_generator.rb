require 'rails/generators/active_record'

module UniqueNumbers
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Create a migration that creates a table for unique_numbers' generators."
      argument :name, type: :string, default: "Unimportant"

      def self.source_root
        @source_root ||= File.expand_path('../templates', __FILE__)
      end

      def create_migrations
        migration_template 'create_unique_numbers_generators.rb', 'db/migrate/create_unique_numbers_generators.rb'
      end
    end
  end
end