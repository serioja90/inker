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
      input = color_str.to_s.downcase.gsub(/\s+/, '')

      Color.parse_color(input).tap do |color|
        @red   = color[:red]
        @green = color[:green]
        @blue  = color[:blue]
        @alpha = color[:alpha]
      end

      validate_color!(input)
    end

    def ==(other)
      red == other.red && green == other.green && blue == other.blue && alpha == other.alpha
    end

    # Get RGBA color components.
    # @return [Array<Integer>] an array of RGBA color components [red, green, blue, alpha].
    def components
      [red, green, blue, alpha]
    end

    alias to_a components

    # Get a RGBA component by index (0 => red, 1 => green, 2 => blue, 3 => alpha).
    def [](key)
      components[key]
    end

    # Set a RGBA component by index (0 => red, 1 => green, 2 => blue, 3 => alpha).
    def []=(key, value)
      component_name = %i[red green blue alpha][key]
      send("#{component_name}=", value)
    end

    # Iterate over RGBA color components.
    def each(&block)
      components.each(&block)
    end

    # Iterate over RGBA color components with index.
    def each_with_index(&block)
      components.each_with_index(&block)
    end

    # Set the value of red component.
    #
    # @param value [Integer] the value of red component [0-255]
    def red=(value)
      raise ArgumentError, "Invalid value: #{value.inspect}" if value.to_i.negative? || value.to_i > 255

      @red = value
    end

    # Set the value of green component.
    #
    # @param value [Integer] the value of green component [0-255]
    def green=(value)
      raise ArgumentError, "Invalid value: #{value.inspect}" if value.to_i.negative? || value.to_i > 255

      @green = value
    end

    # Set the value of blue component.
    #
    # @param value [Integer] the value of blue component [0-255]
    def blue=(value)
      raise ArgumentError, "Invalid value: #{value.inspect}" if value.to_i.negative? || value.to_i > 255

      @blue = value
    end

    # Set the value of alpha component.
    #
    # @param value [Float] the value of alpha component [0.0-1.0]
    def alpha=(value)
      raise ArgumentError, "Invalid value: #{value.inspect}" if value.to_f.negative? || value.to_f > 1

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

    # Returns the luminance of the color.
    # @return [Float] a value between 0.0-1.0 which indicates the luminance of the color
    def luminance
      Color.luminance(@red, @green, @blue)
    end

    # Calculates the result of 2 colors overlay.
    # @return [Inker::Color] a new instance of {Inker::Color} which represents the result of the overlay operation.
    def overlay(color)
      result = dup
      other = color.to_color

      return result if alpha >= 1

      alpha_weight = other.alpha * (1 - alpha)

      # Calculate the result of the overlay operation.
      3.times do |i|
        result[i] = (self[i] * alpha + other[i] * alpha_weight).round
      end

      result.alpha = alpha + alpha_weight

      result
    end

    # Returns the contrast ratio between two colors.
    # @param [Float] a value between 0.0-21.0 which indicates the contrast ratio between two colors (higher is better).
    def contrast_ratio(color)
      l2, l1 = [luminance, color.to_color.luminance].minmax

      (l1 + 0.05) / (l2 + 0.05)
    end

    # Convert color to string in the specified format.
    #
    # @param format [String] indicates the format to which to output the color (default: `hex`)
    #
    # @return [String] a string representation of the color
    def to_s(format = 'hex')
      case format.to_s.strip.downcase
      when 'hex6' then hex6
      when 'rgb'  then rgb
      when 'rgba' then rgba
      when 'hsl'  then hsl
      when 'hsla' then hsla
      else
        hex
      end
    end

    def to_color
      self
    end

    private

    # Validates the values of the color.
    def validate_color!(input)
      invalid = (@red.negative? || @red > 255)
      invalid ||= (@green.negative? || @green > 255)
      invalid ||= (@blue.negative? || @blue > 255)
      invalid ||= (@alpha.negative? || @alpha > 1)

      return unless invalid

      raise ArgumentError, "Invalid color: #{input.inspect} " \
        "(R: #{@red.inspect}, G: #{@green.inspect}, B: #{@blue.inspect}, A: #{@alpha.inspect})"
    end
  end
end
