# RoMQ

Stands for **Robust MQ** and makes your RabbitMQ clients handle the most
common exceptions gracefully. It's cluster-aware, so if you define a
list of rabbitmq hosts, it will keep re-trying to 
connect by picking hosts at random.

## Installation

Add this line to your application's Gemfile:

    gem 'romq'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install romq

## Usage

See the examples directory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
