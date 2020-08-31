# Inker

Inker is a Ruby gem for color parsing and manipulation, which allows to parse a HEX, RGB/RGBA and HSL/HSLA color string and provides functionalities for getting more info on color, like brigthness, lightness, saturation, hue. It also allows to change RGBA values in order to obtain new colors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'inker'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install inker
```

## Parsing colors

There're 2 different ways to parse colors with `Inker`. The first (most direct and simple) is to use
`String#to_color` method, which returns a `Inker::Color` object. The other is by calling `Inker#color`, which has the same effect as `String#to_color`.

```ruby
require "inker"

"magenta".to_color                   # parse a named color
"#880e4f".to_color                   # parse a hex6 color
"#000".to_color                      # parse a hex3 color
"#b71c1c99".to_color                 # parse a hex8 color (the last 2 chars chars represent alpha value)
"rgb(74, 20, 140)".to_color          # parse a RGB color
"rgba(26, 35, 126, 0.75)".to_color   # parse a RGBA color
"hsl(174, 100%, 29%)".to_color       # parse a HSL color with percentages
"hsl(174, 1.0, 0.29)".to_color       # parse a HSL color with decimals
"hsla(21, 100%, 45%, 0.5)".to_color  # parse a HSLA color with percentages
"hsla(21, 1.0, 0.45, 0.5)".to_color  # parse a HSLA color with decimals

Inker.color("magenta")               # parse a named color
Inker.color("#880e4f")               # parse a hex6 color
Inker.color("rgb(74, 20, 140)")      # parse a rgb color
```

## Output formats

`Inker::Color#to_s` by default outputs the color in HEX format when called, but there're different output formats you can choose from.

```ruby
require "inker"

# convert named color to HEX
"magenta".to_color.hex                             #=> "#ff00ff"
"magenta".to_color.to_s                            #=> "#ff00ff"

# convert HEX color to RGB
"#880e4f".to_color.rgb                              #=> "rgb(136, 14, 79)"
"#880e4f".to_color.to_s(:rgb)                       #=> "rgb(136, 14, 79)"

# convert HEX color to RGBA
"#b71c1c99".to_color.rgba                           #=> "rgba(183, 28, 28, 0.6)"
"#b71c1c99".to_color.to_s(:rgba)                    #=> "rgba(183, 28, 28, 0.6)"

# convert RGB color to HEX (the last forces alpha channel presence)
"rgb(74, 20, 140)".to_color.to_s                    #=> "#4a148c"
"rgb(74, 20, 140)".to_color.hex                     #=> "#4a148c"
"rgb(74, 20, 140)".to_color.hex(force_alpha: true)  #=> "#4a148cff"

# convert RGBA to HEX (the last ignores alpha channel)
"rgba(26, 35, 126, 0.75)".to_color.to_s             #=> "#1a237ebf"
"rgba(26, 35, 126, 0.75)".to_color.hex              #=> "#1a237ebf"
"rgba(26, 35, 126, 0.75)".to_color.hex6             #=> "#1a237e"

# convert HSL to HEX, RGB and RGBA
"hsl(174, 100%, 29%)".to_color.to_s                 #=> "#009485"
"hsl(174, 100%, 29%)".to_color.hex                  #=> "#009485"
"hsl(174, 100%, 29%)".to_color.rgb                  #=> "rgb(0, 148, 133)"
"hsl(174, 100%, 29%)".to_color.rgba                 #=> "rgb(0, 148, 133, 1.0)"

# convert HSLA to HEX, RGB and RGBA
"hsla(21, 100%, 45%, 0.5)".to_color.to_s            #=> "#e650007f"
"hsla(21, 100%, 45%, 0.5)".to_color.hex             #=> "#e650007f"
"hsla(21, 100%, 45%, 0.5)".to_color.hex6            #=> "#e65000"
"hsla(21, 100%, 45%, 0.5)".to_color.rgb             #=> "rgb(230, 80, 0)"
"hsla(21, 100%, 45%, 0.5)".to_color.rgba            #=> "rgba(230, 80, 0, 0.5)"
```

## Features

Inker implements some useful features for getting useful color info an color manipulation.

### Instance methods

| Method name   | Description                                                       |
|---------------|-------------------------------------------------------------------|
| `#red`        | Returns the value of red component in range `0-255`               |
| `#red=`       | Allows to set a new value for red component in range `0-255`      |
| `#green`      | Returns the value of green component in range `0-255`             |
| `#green=`     | Allows to set a new value for green component in range `0-255`    |
| `#blue`       | Returns the value of blue component in range `0-255`              |
| `#blue=`      | Allows to set a new value for blue component in range `0-255`     |
| `#alpha`      | Returns the value of alpha component in range `0.0-1.0`           |
| `#alpha=`     | Allows to set a new value for alpha component in range `0.0-1.0`  |
| `#brightness` | Returns the brightness of the color in range `0-255`              |
| `#dark?`      | Returns a boolean (`true` when color is dark)                     |
| `#light?`     | Returns a boolean (`true` when color is light)                    |
| `#lightness`  | Returns the lightness of the color in range `0.0-1.0`             |
| `#saturation` | Returns the saturation of the color in range `0.0-1.0`            |
| `#hue`        | Retursn the value of HUE component of the color in range `0-360`  |

### Class methods

| Method name                                                 | Description                                                                                             |
|-------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| `Inker::Color.from_rgb(Integer, Integer, Integer)`          | Create a new `Inker::Color` instance from RGB components values                                         |
| `Inker::Color.from_rgba(Integer, Integer, Integer, Float)`  | Same as `Inker::Color.from_rgb`, but has also the alpha component                                       |
| `Inker::Color.from_hsl(Integer, Float, Float)`              | Create a new `Inker::Color` instance from HSL components (Saturation and Lightness in range `0.0-1.0`)  |
| `Inker::Color.from_hsla(Integer, Float, Float, Float)`      | Same as `Inker::Color.from_hsl`, but has also the alpha component                                       |
| `Inker::Color.from_custom_string(String, options)`          | Generate a new `Inker::Color` from a custom string, by getting HEX characters from MD5 digest of input string. By setting `:position` option you can change the index of target HEX chars that are used for HEX color generation. (default `position: [0, 29, 14, 30, 28, 31]`)                                                         |
| `Inker::Color.random`                                       | Generate a random `Inker::Color` instance                                                               |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/serioja90/inker](https://github.com/serioja90/inker). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).

## Code of Conduct

Everyone interacting in the Inker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).
