require 'uri'
require 'support/parse_host_shared_examples'
require 'support/parse_port_shared_examples'
 	
RSpec.describe URI do
  it_behaves_like 'parse host', URI

  it_behaves_like 'parse port', URI

  it 'defaults the port for an http URI to 80' do
    expect(URI.parse('http://example.com/').port).to eq 80
  end

  it 'defaults the port for an https URI to 443' do
    expect(URI.parse('https://example.com/').port).to eq 443
  end
end