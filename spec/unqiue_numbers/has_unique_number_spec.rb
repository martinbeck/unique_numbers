require 'spec_helper'

describe UniqueNumbers::HasUniqueNumber do
  context '#define_on' do
    let(:a_class) { stub('class',
                      validates: nil,
                      define_method: nil,
                      after_create: nil,
                      define_paperclip_callbacks: nil,
                      extend: nil,
                      name: 'Billy',
                      validates_media_type_spoof_detection: nil
                    )
                  }
    
    it 'defines a getter for the generator on the class object' do
      UniqueNumbers::HasUniqueNumber.define_on(a_class, :number, {})

      expect(a_class).to have_received(:define_method).with('number_generator')
    end

    it 'defines a validation for uniqueness on the number field' do
      UniqueNumbers::HasUniqueNumber.define_on(a_class, :number, {})

      expect(a_class).to have_received(:validates).with(:number, uniqueness: { allow_nil: true })
    end

    it 'defines an after_create callback' do
      UniqueNumbers::HasUniqueNumber.define_on(a_class, :number, {})

      expect(a_class).to have_received(:after_create)
    end
  end
end