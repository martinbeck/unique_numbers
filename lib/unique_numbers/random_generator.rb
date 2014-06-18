module UniqueNumbers
  class RandomGenerator < Generator
    store_accessor :settings, :minimum, :maximum, :max_tries, :scope
    
    after_initialize do |generator|
      generator.minimum ||= 0
      generator.maximum ||= 10**8 - 1
      generator.max_tries ||= 10
    end
    
    def assign_next_number(model = nil, attribute = nil, debug = false)
      self.with_lock do
        max_tries.times do 
          value = SecureRandom.random_number(maximum - minimum + 1) + minimum
          now = Time.now
          model_scope = model.class
          case scope
          when :daily
            model_scope = model_scope.where('DATE(created_at) = ?', Date.today)
          end
          if !model_scope.exists?(attribute => formatted_number(value, now))
            self.last_generated_at = now
            self.save!
            model.update_columns(attribute => formatted_number(value, now))
            return
          end
        end
        model.errors.add(attribute, "maximum number of generation tries reached")
        raise ActiveRecord::RecordInvalid, model
      end
    end
  end
end