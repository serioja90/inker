module Inker
  class Color
    module Tools
      HEX_REGEX = /^#([0-9a-f]{3}|[0-9a-f]{6}|[0-9a-f]{8})$/
      RGB_REGEX = /^rgb\(\d+,\d+,\d+\)$/
      RGBA_REGEX = /^rgba\(\d+,\d+,\d+,\d+(.\d+)?\)$/

      # Calculate the brightness of a color.
      #
      # @param red [Integer] the red component of the color
      # @param green [Integer] the green component of the color
      # @param blue [Integer] the blue component of the color
      # @return [Float] a value between 0-255 which indicates the brightness of the color
      def brightness(red, green, blue)
        Math.sqrt(0.299 * red**2 + 0.587 * green**2 + 0.114 * blue**2)
      end


      # Returns a `Boolean` which indicates if color is in HEX format
      #
      # @param color_str [String] a color string
      # @return [Boolean] `true` when color is in HEX format
      def is_hex?(color_str)
        !!(color_str.to_s.downcase.strip =~ HEX_REGEX)
      end


      # Returns a `Boolean` which indicates if color is in RGB format
      #
      # @param color_str [String] a color string
      # @return [Boolean] `true` when color is in RGB format
      def is_rgb?(color_str)
        !!(color_str.to_s.downcase.strip =~ RGB_REGEX)
      end


      # Returns a `Boolean` which indicates if color is in RGBA format
      #
      # @param color_str [String] a color string
      # @return [Boolean] `true` when color is in RGBA format
      def is_rgba?(color_str)
        !!(color_str.to_s.downcase.strip =~ RGBA_REGEX)
      end


      # Parse a color string an return it's RGBA components as a hash.
      #
      # @example
      #   Inker::Color.parse_color("#FF005544") # returns {:red=>255, :green=>0, :blue=>85, :alpha=>0.4}
      #
      # @param color_str [String] color string to parse
      # @return [Hash] a hash which contains RGBA components of parsed color
      def parse_color(color_str)
        # Normalize input string by stripping white spaces and converting
        # string to downcase
        input = color_str.to_s.strip.downcase

        # By default result is nil
        result = nil

        # Try to guess the format of color string and parse it by
        # using the apropriate algorithm
        if is_hex?(input)
          # Parse the string as HEX color
          result = parse_hex(input)
        elsif is_rgb?(input)
          # Parse the string as RGB color
          result = parse_rgb(input)
        elsif is_rgba?(input)
          # Parse the string as RGBA color
          result = parse_rgb(input, is_rgba: true)
        else
          # Check if color is in "named color" format
          named_color = Inker.named_colors[input]
          if named_color
            # If a named color has been matched, use it's HEX value and
            # parse it as HEX color
            result = parse_hex(named_color)
          end
        end

        # If we didn't have any match, throw an ArgumentError error
        raise ArgumentError.new("Unknown color format: #{color_str.to_s.strip.inspect}") if result.nil?

        return result
      end

      private

      # Parse a color string as HEX color.
      #
      # @param color_str [String] input color string
      # @return [Hash] a `Hash` which contains RGBA components of parsed color
      def parse_hex(color_str)
        # Remove the leading '#' character from input color string
        input = color_str.gsub(/^#/, '')

        # Convert to HEX6 when color is in HEX3 format
        input = input.chars.map{|x| x * 2 }.join if input.length == 3

        # Get RGB components
        result = {
          red:   Integer(input[0..1], 16),
          green: Integer(input[2..3], 16),
          blue:  Integer(input[4..5], 16),
          alpha: 1.0
        }

        # When color is in HEX8 format, get also alpha channel value
        if input.length == 8
          result[:alpha] = Integer(input[6..7], 16) / 255.0
        end

        return result
      end


      # Parse color string as RGB(A) color.
      #
      # @param color_str [String] input RGB(A) color string
      # @param is_rgba [Boolean] indicates if color string is in RGBA format
      # @return [Hash] a `Hash` which contains RGBA components of parsed color
      def parse_rgb(color_str, is_rgba: false)
        components = color_str.gsub(/(^rgb(a)?\(|\)$)/, "").split(",")

        return {
          red: components.shift.to_i,
          green: components.shift.to_i,
          blue: components.shift.to_i,
          alpha: components.shift.to_f
        }
      end
    end
  end
end