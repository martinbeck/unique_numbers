# UniqueNumbers

UniqueNumbers is a small gem for ActiveRecord capable of generating and assigning unique
numbers to your models. Example usages are generating invoice numbers or order numbers.

## Installation

Add this line to your application's Gemfile:

    gem 'unique_numbers'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unique_numbers
    
If you're using rails, you can run UniqueNumbers' generator to create the necessary migration:

    $ rails g unique_numbers:install
    
Otherwise, you have to generate the table on your own. TODO

## Usage

Within your ActiveRecord models, you can add a call to `has_unique_number` to mark an
attribute for automatic unique number generation. This attribute already has to exist in the
database and you should also add a database-constraint for uniqueness. A simple example:

```ruby
class Order < ActiveRecord::Base
  has_unique_number :number, generator: :orders, type: :random
end
```

This will connect a random number generator to an order's `:number` field. An `after_create`
hook is registered. It will generate a unique random number for each new order. The generator
itself is also created in the database and is referred to by the name `:orders`.

### Random Generator

To generate random numbers, you can specify `type: :random` as an option for `has_unique_number`.
It will use Ruby's `SecureRandom.random_number` to generate and assign numbers. If a number is 
already used, it will retry with another random number. You can use the `max_tries` option to
specify how often UniqueNumbers should try to regenerate a new number before raising an
exception.

Options:

* `format`: Format of the generated number - you can use printf-style string-formatting where %i
    is the generated number. Also strftime-like time/date placeholders are supported, but you have
    to use '#' instead of '%'. Thus, 'R#y#m#d-%03i' will result in an order number containing
    current date and the random number padded with zeros if necessary. Defaults to '%i'.
* `minimum`: Minimum value the random number should have at least. Defaults to 0.
* `maximum`: Maximum value the random number should have. Defaults to 10**8 - 1.
* `max_tries`: Number of tries, UniqueNumbers tries to regenerate a random number, if it's already
    been used. Defaults to 10.
* `scope`: Can be set to `:daily`. Generated numbers will only be unique per day but not globally
    anymore.
    
Example:

```ruby
  has_unique_number :number, generator: :orders, type: :random, format: "%04i", maximum: 9999, scope: :daily
```

### Sequential Generator

If you need sequential numbers, maybe due to law enforcements for invoice numbers, you can use
`:sequential` as a type. Every new number will be a successor of the previous one, except if
you configure an automatic reset.

Options:

* `format`: Format of the generated number - you can use printf-style string-formatting where %i
    is the generated number. Also strftime-like time/date placeholders are supported, but you have
    to use '#' instead of '%'. Thus, 'R#y#m#d-%03i' will result in an order number containing
    current date and the random number padded with zeros if necessary. Defaults to '%i'.
* `start_value`: The first number that will be generated. It is also the value to which
    UniqueNumbers' internal counters will be set upon automatic reset. Defaults to 0.
* `reset`: Can be set to `:hourly`, `:daily`, `:weekly`, `:monthly`, or `:yearly`. It specifies
    when the number sequence will be reset.
    
Example:

```ruby
class Invoice
  has_unique_number :number, generator: :invoices, type: :sequential, format: 'R#y#m#d-%i', start_value: 42, reset: :daily
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/unique_numbers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
