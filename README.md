# Superbot::Cloud

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/superbot/cloud`. To experiment with that code, run `bin/console` for an interactive prompt.

Superbot cloud is a gem that adds cloud functionality for the superbot

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'superbot-cloud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install superbot-cloud

## Usage

Login to the cloud

```ruby
superbot cloud login
```

List your organizations from the cloud

```ruby
superbot cloud org list
```

Upload test to the cloud

```ruby
superbot cloud test upload testfolder
```

For more commands see `superbot cloud --help`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/superbot-cloud. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Superbot::Cloud project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/superbot-cloud/blob/master/CODE_OF_CONDUCT.md).
