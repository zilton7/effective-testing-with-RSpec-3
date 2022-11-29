require_relative '../coffee'

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
end

RSpec.describe 'A cup of coffee' do
  let(:coffee) { Coffee.new }
  
  it 'costs $1' do
    expect(coffee.price).to eq(1.00)
  end

  context 'with milk' do
    before { coffee.add :milk }

    it 'costs $1.25' do
      expect(coffee.price).to eq(1.25)
    end

    it 'is light in color' do
      expect(coffee.color).to be(:light)
    end

    it 'is cooler thatn 200 degrees Fahrenheit' do
      expect(coffee.temperature).to be < 200.0
    end
  end
end