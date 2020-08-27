require 'inker/color/tools'

module Inker
  class Color
    extend Tools

    attr_reader :red, :green, :blue, :alpha, :brightness

    # Create a new {Inker::Color} object from a color string.
    #
    # @param color_str [String] a color string
    def initialize(color_str)
      @input = color_str.to_s.downcase.strip

      Color.parse_color(@input).tap do |color|
        @red   = color[:red]
        @green = color[:green]
        @blue  = color[:blue]
        @alpha = color[:alpha]
      end

      validate_color!

      @brightness = Color.brightness(@red, @green, @blue)
    end

    # Returns a boolean which indicates if the color is dark.
    #
    # @return [Boolean] `true` when color is dark
    def dark?
      brightness < 127
    end

    # Returns a boolean which indicates if the color is light.
    # @return [Boolean] `true` when color is light
    def light?
      !dark?
    end

    private

    def validate_color!
      invalid = (@red < 0 or @red > 255)
      invalid ||= (@green < 0 or @green > 255)
      invalid ||= (@blue < 0 or @blue > 255)
      invalid ||= (@alpha < 0 or @alpha > 1)

      if invalid
        raise ArgumentError.new "Invalid color: #{@input.inspect} " \
          "(R: #{@red.inspect}, G: #{@green.inspect}, B: #{@blue.inspect}, A: #{@alpha.inspect})"
      end
    end
  end
end