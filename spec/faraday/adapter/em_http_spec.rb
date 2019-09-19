# frozen_string_literal: true

RSpec.describe Faraday::Adapter::EMHttp do
  features :request_body_on_query_methods, :reason_phrase_parse, :trace_method, :connect_method,
           :skip_response_body_on_head, :parallel, :local_socket_binding

  it_behaves_like 'an adapter'

  it 'allows to provide adapter specific configs' do
    url = URI('https://example.com:1234')
    adapter = described_class.new nil, inactivity_timeout: 20
    req = adapter.create_request(url: url, request: {})

    expect(req.connopts.inactivity_timeout).to eq(20)
  end

  context 'Options' do
    let(:request) { Faraday::RequestOptions.new }
    let(:env) { { request: request } }
    let(:adapter) {
      Object.new.tap do |o|
        class << o
          include Faraday::Adapter::EMHttp::Options
        end
      end
    }
    let(:options) { {} }

    it 'configures timeout' do
      request.timeout = 5
      adapter.configure_timeout(options, env)
      expect(options[:inactivity_timeout]).to eq(5)
      expect(options[:connect_timeout]).to eq(5)
    end

    it 'configures timeout and open_timeout' do
      request.timeout = 5
      request.open_timeout = 1
      adapter.configure_timeout(options, env)
      expect(options[:inactivity_timeout]).to eq(5)
      expect(options[:connect_timeout]).to eq(1)
    end
  end
end
