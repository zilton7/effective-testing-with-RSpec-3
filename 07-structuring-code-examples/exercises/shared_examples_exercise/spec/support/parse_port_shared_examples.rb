RSpec.shared_examples 'parse port' do |parse_port_class|
  let(:parse_port) { parse_port_class }
  
  it 'parses the port' do
    expect(parse_port.parse('http://example.com:9876').port).to eq 9876
  end
end