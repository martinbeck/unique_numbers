require "unique_numbers/version"
require "unique_numbers/generator"
require "unique_numbers/random_generator"
require "unique_numbers/sequential_generator"
require "unique_numbers/has_unique_number"

module UniqueNumbers
  # Your code goes here...
  
  def self.table_name_prefix
    'unique_numbers_'
  end
  
  module ClassMethods
    def has_unique_number(name, options = {})
      HasUniqueNumber.define_on(self, name, options)
    end
  end
end

ActiveRecord::Base.extend UniqueNumbers::ClassMethods