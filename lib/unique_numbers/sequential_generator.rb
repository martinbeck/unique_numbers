module UniqueNumbers
  class SequentialGenerator < Generator
    store_accessor :settings, :start_value, :value, :reset
    
    validates :start_value, presence: true
    
    after_initialize do |generator|
      generator.start_value ||= 0
    end
    
    def assign_next_number(model = nil, attribute = nil)
      self.with_lock do
        self.value = start_value - 1 if needs_reset?
        self.value += 1
        self.last_generated_at = Time.now
        self.save!
        model.update_columns(attribute => formatted_number(value, last_generated_at))
      end
    end
    
    private
    def needs_reset?
      self.value.blank? or self.last_generated_at.blank? or case reset
      when :hourly
        self.last_generated_at < Time.now.beginning_of_hour
      when :daily
        self.last_generated_at < Time.now.beginning_of_day
      when :weekly
        self.last_generated_at < Time.now.beginning_of_week
      when :monthly
        self.last_generated_at < Time.now.beginning_of_month
      when :yearly
        self.last_generated_at < Time.now.beginning_of_year
      else
        false
      end
    end    
  end
end