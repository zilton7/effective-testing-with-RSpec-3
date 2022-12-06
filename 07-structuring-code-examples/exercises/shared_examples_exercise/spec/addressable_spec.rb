require 'addressable'
require 'support/parse_host_shared_examples'
require 'support/parse_port_shared_examples'
 	
RSpec.describe Addressable do
  it 'parses the scheme' do
    expect(Addressable::URI.parse('https://a.com/').scheme).to eq 'https'
  end

  it_behaves_like 'parse host', URI

  it_behaves_like 'parse port', URI

  it 'parses the path' do
    expect(Addressable::URI.parse('http://a.com/foo').path).to eq '/foo'
  end
end