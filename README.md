# Reaxar

Reaxar is a lightweight asynchronous HTTP client and HTML scraper for Ruby, designed for efficient and concurrent web requests with built-in HTML parsing.

## Features

- Asynchronous HTTP requests using `async`
- Simple HTML page parsing and traversal
- Middleware support for logging, redirects, and more
- Cookie management
- Configurable and extensible architecture

## Installation

Add this to your Gemfile:

```ruby
gem 'reaxar'
```

Then run:

```bash
bundle install
```

Or install the gem manually:

```bash
gem install reaxar
```

## Dependencies

- **[async-http](https://github.com/socketry/async-http)** — Asynchronous HTTP client library
- **[async](https://github.com/socketry/async)** — Asynchronous I/O library for Ruby

## Usage

```ruby
require 'reaxar'

Reaxar::Page.open('https://github.com') do |page|
  puts page.title
end
```

## Development

To run tests:

```bash
bundle exec rspec
```

To run lint checks with RuboCop:

```bash
bundle exec rubocop
```

To generate documentation with YARD:

```bash
bundle exec rake yard
```

## Contributing

Bug reports and pull requests are welcome. Please fork the repo and submit a pull request.

## License

MIT License
