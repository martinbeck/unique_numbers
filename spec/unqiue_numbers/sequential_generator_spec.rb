require 'spec_helper'

describe UniqueNumbers::SequentialGenerator do
  let(:generator) { UniqueNumbers::SequentialGenerator.create!(name: "test") }
  let(:dummy) { UniqueNumbers::Dummy.create! }
  
  it "creates sequential numbers" do
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("0")
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("1")
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("2")
  end
  
  it "uses the start value" do
    generator.start_value = 42
    generator.save!
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("42")
  end
  
  it "allows printf-style formats" do
    generator.format = "%04i"
    generator.start_value = 42
    generator.save!
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("0042")
  end
  
  it "allows strftime-style formats using '#'" do
    generator.format = "#y#m#d-%i"
    generator.save!
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq(Time.now.strftime("%y%m%d-0"))
  end
  
  it "automatically resets the last value to the start value if reset is enabled and border crossed" do
    generator.reset = :daily
    generator.start_value = 2
    generator.save!
    generator.assign_next_number(dummy, :number)
    expect(generator.value).to eq(2)
    Timecop.freeze(1.day.from_now) do
      generator.assign_next_number(dummy, :number)
      expect(generator.value).to eq(2)
    end
  end
end