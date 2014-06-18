module UniqueNumbers
  class Generator < ActiveRecord::Base
    store :settings
    
    validates :name, presence: true
    validates :format, presence: true
    
    after_initialize do |generator|
      generator.format ||= "%i"
    end
    
    def assign_next_number(model, attribute)
      raise "Implement in subclasses"
    end
    
    protected
    def formatted_number(value, now)
      now.strftime(sprintf(format, value).gsub('#', '%'))
    end
  end
end