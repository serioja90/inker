module Inker
  class Color
    # Tools module implements a set of methods useful for color parsing and
    # for getting useful info about color.
    module Tools
      # Regular expression for HEX colors matching
      HEX_REGEX = /^#([0-9a-f]{3}|[0-9a-f]{6}|[0-9a-f]{8})$/

      # Regular expression for RGB colors matching
      RGB_REGEX = /^rgb\((\d+,){2}\d+\)$/

      # Regular expression for RGBA colors matching
      RGBA_REGEX = /^rgba\((\d+,){3}\d+(.\d+)?\)$/

      # Regular expression for HSL colors matching
      HSL_REGEX = /^hsl\((\d+)(,\d+%|,\d+(.\d+)){2}\)$/

      # Regular expression for HSLA colors matching
      HSLA_REGEX = /^hsla\((\d+)(,\d+%|,\d+(.\d+)){2},\d+(.\d+)?\)$/

      # Calculate the brightness of a color.
      #
      # @param red [Integer] the value of red component [0-255]
      # @param green [Integer] the value of green component [0-255]
      # @param blue [Integer] the value of blue component [0-255]
      #
      # @return [Integer] a value between 0-255 which indicates the brightness of the color
      def brightness(red, green, blue)
        Math.sqrt(0.299 * red**2 + 0.587 * green**2 + 0.114 * blue**2).round
      end


      # Calculate the lightness of a color from RGB components.
      #
      # @param red [Integer] the value of red component [0-255]
      # @param green [Integer] the value of green component [0-255]
      # @param blue [Integer] the value of blue component [0-255]
      #
      # @return [Float] a value in range 0.0-1.0 which indicates the ligthness of the color
      def lightness(red, green, blue)
        min, max = [red, green, blue].minmax

        return (min + max) / (2.0 * 255)
      end


      # Calculate the saturation of a color from RGB components.
      #
      # @param red [Integer] the value of red component [0-255]
      # @param green [Integer] the value of green component [0-255]
      # @param blue [Integer] the value of blue component [0-255]
      #
      # @return [Float] a value in range 0.0-1.0 which indicates the saturation of the color
      def saturation(red, green, blue)
        lightness = lightness(red, green, blue)
        min, max = [red / 255.0, green / 255.0, blue / 255.0].minmax

        return lightness < 0.5 ? (max - min) / (max + min) : (max - min) / (2.0 - max - min)
      end


      # Calculate the HUE value of a color from RGB components.
      #
      # @param red [Integer] the value of red component [0-255]
      # @param green [Integer] the value of green component [0-255]
      # @param blue [Integer] the value of blue component [0-255]
      #
      # @return [Integer] a value in range 0-360 which indicates the HUE value of the color
      def hue(red, green, blue)
        min, max = [red, green, blue].minmax
        numerator = (max - min).to_f
        hue = (red == max)   ? (green - blue) / numerator :
              (green == max) ? 2 + (blue - red) / numerator :
                               4 + (red - green) / numerator
        hue = hue * 60
        return (hue < 0 ? hue + 360 : hue).round
      end


      # Get RGB values from a color in HSL format.
      #
      # @param hue [Integer] the value of HUE component [0-360]
      # @param saturation [Float] the saturation of the color [0.0-1.0]
      # @param lightness [Float] the lightness of the color [0.0-1.0]
      #
      # @return [Hash] a `Hash` which contains the values of RGB components
      def hsl_to_rgb(hue, saturation, lightness)
        result = nil
        if saturation == 0
          # There's no saturation, so it's a gray scale color, which
          # depends only on brightness
          brightness = lightness * 255

          # All RGB components are equal to brightness
          result = {
            red:   brightness,
            green: brightness,
            blue:  brightness
          }
        else
          q = lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation
          p = 2 * lightness - q
          norm_hue = hue / 360.0

          result = {
            red:   (hue_to_rgb(p, q, norm_hue + 1.0/3.0) * 255).round,
            green: (hue_to_rgb(p, q, norm_hue) * 255).round,
            blue:  (hue_to_rgb(p, q, norm_hue - 1.0/3.0) * 255).round
          }
        end

        return result
      end


      # Returns a `Boolean` which indicates if color is in HEX format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in HEX format
      def is_hex?(color_str)
        !!(color_str.to_s.downcase.strip =~ HEX_REGEX)
      end


      # Returns a `Boolean` which indicates if color is in RGB format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in RGB format
      def is_rgb?(color_str)
        !!(color_str.to_s.downcase.strip =~ RGB_REGEX)
      end


      # Returns a `Boolean` which indicates if color is in RGBA format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in RGBA format
      def is_rgba?(color_str)
        !!(color_str.to_s.downcase.strip =~ RGBA_REGEX)
      end


      # Returns a `Boolean` which indicates if color is in HSL format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in HSL format
      def is_hsl?(color_str)
        !!(color_str.to_s.downcase.strip =~ HSL_REGEX)
      end


      # Returns a `Boolean` which indicates if color is in HSLA format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in HSLA format
      def is_hsla?(color_str)
        !!(color_str.to_s.downcase.strip =~ HSLA_REGEX)
      end


      # Generate a random `Inker::Color`.
      #
      # @param with_alpha [Boolean] when `true` include alpha channel
      #
      # @return [Inker::Color] a random color
      def random(with_alpha: false)
        prefix = with_alpha ? "rgba" : "rgb"
        values = (1..3).map{ (rand * 255).round }
        values << rand.round(2) if with_alpha

        Inker.color("#{prefix}(#{values.join(",")})")
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
        elsif is_hsl?(input)
          # Parse the string as HSL color
          result = parse_hsl(input)
        elsif is_hsla?(input)
          # Parse the string as HSLA color
          result = parse_hsl(input, is_hsla: true)
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
      #
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
      #
      # @return [Hash] a `Hash` which contains RGBA components of parsed color
      def parse_rgb(color_str, is_rgba: false)
        components = color_str.gsub(/(^rgb(a)?\(|\)$)/, "").split(",")

        return {
          red:   components.shift.to_i,
          green: components.shift.to_i,
          blue:  components.shift.to_i,
          alpha: (is_rgba ? components.shift.to_f : 1.0)
        }
      end


      # Parse color string as HSL(A) color.
      #
      # @param color_str [String] input HSL(A) color string
      # @param is_hsla [Boolean] indicates if color string is in HSL(A) format
      #
      # @return [Hash] a `Hash` which contains RGBA components of parsed color
      def parse_hsl(color_str, is_hsla: false)
        components = color_str.gsub(/(^hsl(a)?\(|\)$)/, "").split(",")

        hue = components.shift.to_i

        saturation = components.shift
        saturation = saturation.include?("%") ? saturation.to_f / 100 : saturation.to_f

        lightness = components.shift
        lightness = lightness.include?("%") ? lightness.to_f / 100 : lightness.to_f

        result = hsl_to_rgb(hue, saturation, lightness)
        result[:alpha] = is_hsla ? components.shift.to_f : 1.0

        return result
      end


      # A helper function which allows to calculate the RGB component value from HSL color.
      #
      # @param p [Float] `2 * lightness -q`
      # @param q [Float] `lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation`
      # @param t [Float] `hue + 1/3`, `hue` or `hue - 1/3` according to which component is going to be calculated [r,g,b]
      #
      # @return [Float] a value which represents a RGB component in range 0.0-1.0
      def hue_to_rgb(p, q, t)
        t += 1 if t < 0
        t -= 1 if t > 1

        return p + (q - p) * 6 * t         if t < 1.0 / 6.0
        return q                           if t < 1.0 / 2.0
        return p + (q - p) * (2/3 - t) * 6 if t < 2.0 / 3.0
        return p;
      end
    end
  end
end