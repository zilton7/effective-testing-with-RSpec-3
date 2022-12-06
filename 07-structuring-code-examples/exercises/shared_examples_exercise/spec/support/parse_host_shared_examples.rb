RSpec.shared_examples 'parse host' do |parse_host_class|
  let(:parse_host) { parse_host_class }
  
  it 'parses the host' do
    expect(parse_host.parse('http://foo.com/').host).to eq 'foo.com'
  end
end