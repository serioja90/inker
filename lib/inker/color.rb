require_relative 'color/tools'
require_relative 'color/serializers'

module Inker
  # This class is used to represent a color in Ruby as an object. It allows
  # to create a new instance of {Inker::Color} from a string which represents a color.
  # It also allows to obtain more info about the color and convert color to a different
  # format.
  class Color
    extend Tools
    include Serializers

    attr_reader :red, :green, :blue, :alpha

    # Create a new {Inker::Color} object from a color string.
    #
    # @param color_str [String] a color string
    def initialize(color_str)
      @input = color_str.to_s.downcase.gsub(/\s+/, "")

      Color.parse_color(@input).tap do |color|
        @red   = color[:red]
        @green = color[:green]
        @blue  = color[:blue]
        @alpha = color[:alpha]
      end

      validate_color!
    end

    def ==(color)
      self.red   == color.red   and
      self.green == color.green and
      self.blue  == color.blue  and
      self.alpha == color.alpha
    end


    # Set the value of red component.
    #
    # @param value [Integer] the value of red component [0-255]
    def red=(value)
      raise ArgumentError.new("Invalid value: #{value.inspect}") if value.to_i < 0 or value.to_i > 255
      @red = value
    end


    # Set the value of green component.
    #
    # @param value [Integer] the value of green component [0-255]
    def green=(value)
      raise ArgumentError.new("Invalid value: #{value.inspect}") if value.to_i < 0 or value.to_i > 255
      @green = value
    end


    # Set the value of blue component.
    #
    # @param value [Integer] the value of blue component [0-255]
    def blue=(value)
      raise ArgumentError.new("Invalid value: #{value.inspect}") if value.to_i < 0 or value.to_i > 255
      @blue = value
    end


    # Set the value of alpha component.
    #
    # @param value [Float] the value of alpha component [0.0-1.0]
    def alpha=(value)
      raise ArgumentError.new("Invalid value: #{value.inspect}") if value.to_f < 0 or value.to_f > 1
      @alpha = value
    end


    # Calculate the brightness of a color.
    #
    # @return [Integer] a value between 0-255 which indicates the brightness of the color
    def brightness
      Color.brightness(@red, @green, @blue)
    end


    # Calculate the lightness of a color.
    #
    # @return [Float] a value between 0.0-1.0 which indicates the lightness of the color
    def lightness
      Color.lightness(@red, @green, @blue)
    end


    # Calculate the saturation of a color.
    #
    # @return [Float] a value between 0.0-1.0 which indicates the saturation of the color
    def saturation
      Color.saturation(@red, @green, @blue)
    end


    # Calculate the HUE of a color.
    #
    # @return [Integer] a value between 0-360 which indicates the HUE of the color
    def hue
      Color.hue(@red, @green, @blue)
    end

    # Returns a boolean which indicates if the color is dark.
    #
    # @return [Boolean] `true` when color is dark
    def dark?
      brightness < 128
    end

    # Returns a boolean which indicates if the color is light.
    # @return [Boolean] `true` when color is light
    def light?
      !dark?
    end


    # Convert color to string in the specified format.
    #
    # @param format [String] indicates the format to which to output the color (default: `hex`)
    #
    # @return [String] a string representation of the color
    def to_s(format = 'hex')
      case format.to_s.strip.downcase
      when 'hex6' then self.hex6
      when 'rgb'  then self.rgb
      when 'rgba' then self.rgba
      else
        self.hex
      end
    end

    private

    # Validates the values of the color.
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