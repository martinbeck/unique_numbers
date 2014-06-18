require 'rubygems'
require 'rspec'
require 'active_record'
require 'active_record/version'
require 'active_support'
require 'active_support/core_ext'
require 'mocha/api'
require 'bourne'
require 'timecop'

ROOT = Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..')))

puts "Testing against version #{ActiveRecord::VERSION::STRING}"

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'unique_numbers')
require File.join(ROOT, 'lib', 'unique_numbers.rb')

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])

Dir[File.join(ROOT, 'spec', 'support', '**', '*.rb')].each{|f| require f }

ActiveSupport::Deprecation.silenced = true

RSpec.configure do |config|
  config.mock_framework = :mocha
  
  config.before(:all) do
    ActiveRecord::Base.connection.create_table :unique_numbers_generators, force: true do |t|
      t.string :type
      t.string :name, index: true
      t.string :format
      t.text :settings
      t.datetime :last_generated_at
      t.timestamps
    end
    ActiveRecord::Base.connection.create_table :unique_numbers_dummies, force: true do |t|
      t.string :number, unique: true
      t.timestamps
    end
  end
  
  config.after(:each) do
    UniqueNumbers::Generator.delete_all
    UniqueNumbers::Dummy.delete_all
  end
end