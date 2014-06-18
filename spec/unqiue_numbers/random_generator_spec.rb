require 'spec_helper'

describe UniqueNumbers::RandomGenerator do
  let(:generator) { UniqueNumbers::RandomGenerator.create!(name: "test") }
  let(:dummy) { UniqueNumbers::Dummy.create! }
  
  it "creates 'random' numbers" do
    SecureRandom.expects(:random_number).with(anything).times(3).returns(8, 4, 9)
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("8")
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("4")
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("9")
  end
  
  it "updates the last_generated_at field" do
    generator.assign_next_number(dummy, :number)
    expect(generator.last_generated_at).to be_present
  end
  
  it "allows printf-style formats" do
    SecureRandom.expects(:random_number).with(anything).returns(8)
    generator.format = "%04i"
    generator.save!
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("0008")
  end
  
  it "allows strftime-style formats using '#'" do
    SecureRandom.expects(:random_number).with(anything).returns(8)
    generator.format = "#y#m#d-%i"
    generator.save!
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq(Time.now.strftime("%y%m%d-8"))
  end
  
  it "prohibits assigning the same number twice" do
    SecureRandom.expects(:random_number).with(anything).at_least(2).returns(8)
    generator.assign_next_number(dummy, :number)
    expect {
      generator.assign_next_number(dummy, :number)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "allows assigning the same number twice if scoping is enabled" do
    SecureRandom.expects(:random_number).with(anything).at_least(2).returns(8)
    generator.scope = :daily
    generator.save!
    generator.assign_next_number(dummy, :number)
    expect(dummy.number).to eq("8")
    Timecop.freeze(1.day.from_now) do
      generator.assign_next_number(dummy, :number)
      expect(dummy.number).to eq("8")
    end
  end
end