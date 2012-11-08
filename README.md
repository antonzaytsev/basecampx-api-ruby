# Basecampx

The new Basecamp API Ruby wrapper.
Currently support only rails, feel free to help me get rid of Rails dependency.

## Installation

Add this line to your application's Gemfile:

    gem 'basecampx'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install basecampx

## If you use Rails

Generate config file

    $ rails g basecampx:install

Edit config file (config/basecampx.yaml) with your new basecamp login details

## Usage

Get all people from account

    Basecamp.people

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Usefull links

The new Basecamp API https://github.com/37signals/bcx-api
The Basecamp Classic API https://github.com/37signals/basecamp-classic-api