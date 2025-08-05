require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, 'https://example.com/')
      .to_return(
        status: 200,
        body: <<~HTML,
          <html>
            <body>
              <h1>Hello from stub</h1>
              <a href="https://example.com/page1">page1</a>
              <a href="https://example.com/page2">page2</a>
            </body>
          </html>
        HTML
        headers: { 'Content-Type' => 'text/html' }
      )

    stub_request(:post, 'https://example.com/')
      .to_return(
        status: 200,
        body: <<~HTML,
          <html>
            <body>
              <h1>POST OK</h1>
              <a href="https://example.com/page1">page1</a>
              <a href="https://example.com/page2">page2</a>
            </body>
          </html>
        HTML
        headers: { 'Content-Type' => 'text/html' }
      )

    stub_request(:get, 'https://example.com/delay/1').to_return do
      sleep 1
      { status: 200, body: 'OK', headers: {} }
    end

    stub_request(:get, 'https://example.com/delay/5').to_return do
      sleep 5
      { status: 200, body: 'OK', headers: {} }
    end
  end
end
