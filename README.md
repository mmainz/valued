[![Build Status](https://travis-ci.org/mmainz/valued.svg?branch=master)](https://travis-ci.org/mmainz/valued)

# Valued

Valued is a Ruby gem that allows you to easily define value objects.

In the past, I mainly used `Struct` for objects of this kind. However, structs
in Ruby have some drawbacks, like the fact that they implement hash access with
`[]`, which is undesirable if you want to use duck typing. Also, they require
all their attributes to always be passed to their constructor, which makes it
cumbersome to construct them from a JSON payload that may miss some optional
attribute.

You can of course also just implement those objects yourself, but that requires
a lot of boilerplate, like implementing `==`, `inspect`, `to_h` and other
methods you almost always need.

With Valued, you can automatically define a `Struct`-like class that behaves
properly.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'valued'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install valued

## Usage

Just include `Valued` in your class and then define `attributes`.

```ruby
require 'valued'

class Quantity
  include Valued

  attributes :unit, :amount
end
```

After that, you can use your class similarly to a struct. You construct an
instance of it with a hash:

```ruby
quantity = Quantity.new(unit: 'm', amount: 2)
p quantity.amount
=> 2
p quantity.unit
=> 'm'
```

If you omit a parameter in the constructor, it is set to `nil`.

```ruby
quantity = Quantity.new(amount: 2)
p quantity.unit
=> nil
```

Classes defined with valued automatically implement `==`, `eql?`, `hash`,
`to_h`, `to_s` and `inspect`.

```ruby
quantity = Quantity.new(amount: 2, unit: 'm')
second_quantity = Quantity.new(amount: 2, unit: 'm')
quantity == second_quantity
=> true

quantity.to_h
=> {:amount=>2, :unit=>"m"}
p quantity
=> #<Quantity amount=2 unit="m">
```

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
