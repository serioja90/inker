# frozen_string_literal: true

module Inker
  class Color
    # Tools module implements a set of methods useful for color parsing and
    # for getting useful info about color.
    module Tools
      # Regular expression for HEX colors matching
      HEX_REGEX = /^#([0-9a-f]{3}|[0-9a-f]{6}|[0-9a-f]{8})$/.freeze

      # Regular expression for RGB colors matching
      RGB_REGEX = /^rgb\((\d+,){2}\d+\)$/.freeze

      # Regular expression for RGBA colors matching
      RGBA_REGEX = /^rgba\((\d+,){3}\d+(.\d+)?\)$/.freeze

      # Regular expression for HSL colors matching
      HSL_REGEX = /^hsl\((\d+)(,\d+%|,\d+(.\d+)){2}\)$/.freeze

      # Regular expression for HSLA colors matching
      HSLA_REGEX = /^hsla\((\d+)(,\d+%|,\d+(.\d+)){2},\d+(.\d+)?\)$/.freeze

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

        (min + max) / (2.0 * 255)
      end

      # Calculate the saturation of a color from RGB components.
      #
      # @param red [Integer] the value of red component [0-255]
      # @param green [Integer] the value of green component [0-255]
      # @param blue [Integer] the value of blue component [0-255]
      #
      # @return [Float] a value in range 0.0-1.0 which indicates the saturation of the color
      def saturation(red, green, blue)
        # return 0 for black and white colors
        return 0 if red == green && red == blue && (red.zero? || red == 255)

        lightness = lightness(red, green, blue)
        min, max = [red / 255.0, green / 255.0, blue / 255.0].minmax

        lightness < 0.5 ? (max - min) / (max + min) : (max - min) / (2.0 - max - min)
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
        return 0 if numerator.zero?

        hue = case max
              when red then (green - blue) / numerator
              when green then 2 + (blue - red) / numerator
              when blue then 4 + (red - green) / numerator
              end

        hue *= 60

        (hue.negative? ? hue + 360 : hue).round
      end

      # Calculate the luminance of a color from RGB components.
      #
      # @param red [Integer] the value of red component [0-255]
      # @param green [Integer] the value of green component [0-255]
      # @param blue [Integer] the value of blue component [0-255]
      #
      # @return [Float] a value in range 0.0-1.0 which indicates the luminance of the color
      def luminance(red, green, blue)
        components = [red, green, blue].map do |c|
          value = c / 255.0
          value <= 0.03928 ? value / 12.92 : ((value + 0.055) / 1.055)**2.4
        end

        0.2126 * components[0] + 0.7152 * components[1] + 0.0722 * components[2]
      end

      # Get RGB values from a color in HSL format.
      #
      # @param hue [Integer] the value of HUE component [0-360]
      # @param saturation [Float] the saturation of the color [0.0-1.0]
      # @param lightness [Float] the lightness of the color [0.0-1.0]
      #
      # @return [Hash] a `Hash` which contains the values of RGB components
      def hsl_to_rgb(hue, saturation, lightness)
        c, x, m = hue_convert_params(hue, saturation, lightness)
        weights = hsl_hue_weights(hue, c, x)

        {
          red: ((weights[0] + m) * 255).round,
          green: ((weights[1] + m) * 255).round,
          blue: ((weights[2] + m) * 255).round
        }
      end

      # Returns a `Boolean` which indicates if color is in HEX format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in HEX format
      def hex?(color_str)
        !!(color_str.to_s.downcase.strip =~ HEX_REGEX)
      end

      alias is_hex? hex?

      # Returns a `Boolean` which indicates if color is in RGB format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in RGB format
      def rgb?(color_str)
        !!(color_str.to_s.downcase.gsub(/\s+/, '') =~ RGB_REGEX)
      end

      alias is_rgb? rgb?

      # Returns a `Boolean` which indicates if color is in RGBA format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in RGBA format
      def rgba?(color_str)
        !!(color_str.to_s.downcase.gsub(/\s+/, '') =~ RGBA_REGEX)
      end

      alias is_rgba? rgba?

      # Returns a `Boolean` which indicates if color is in HSL format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in HSL format
      def hsl?(color_str)
        !!(color_str.to_s.downcase.gsub(/\s+/, '') =~ HSL_REGEX)
      end

      alias is_hsl? hsl?

      # Returns a `Boolean` which indicates if color is in HSLA format
      #
      # @param color_str [String] a color string
      #
      # @return [Boolean] `true` when color is in HSLA format
      def hsla?(color_str)
        !!(color_str.to_s.downcase.gsub(/\s+/, '') =~ HSLA_REGEX)
      end

      alias is_hsla? hsla?

      # Generate a random `Inker::Color`.
      #
      # @param with_alpha [Boolean] when `true` include alpha channel
      #
      # @return [Inker::Color] a random color
      def random(with_alpha: false)
        prefix = with_alpha ? 'rgba' : 'rgb'
        values = (1..3).map{ (rand * 255).round }
        values << rand.round(2) if with_alpha

        Inker.color("#{prefix}(#{values.join(',')})")
      end

      # A helper for `Inker::Color` generation from RGB components.
      #
      # @param red [Integer] the value of red component [0-255]
      # @param green [Integer] the value of green component [0-255]
      # @param blue [Integer] the value of blue component [0-255]
      #
      # @return [Inker::Color] a `Inker::Color` generated from passed RGB values
      def from_rgb(red, green, blue)
        Inker.color("rgb(#{red}, #{green}, #{blue})")
      end

      # A helper for `Inker::Color` generation from RGBA components.
      #
      # @param red [Integer] the value of red component [0-255]
      # @param green [Integer] the value of green component [0-255]
      # @param blue [Integer] the value of blue component [0-255]
      # @param alpha [Float] the value of alpha component [0.0-1.1]
      #
      # @return [Inker::Color] a `Inker::Color` generated from passed RGBA values
      def from_rgba(red, green, blue, alpha)
        Inker.color("rgba(#{red}, #{green}, #{blue}, #{alpha})")
      end

      # A helper for `Inker::Color` generation from HSL components.
      #
      # @param hue [Integer] the value of HUE component [0-360]
      # @param saturation [Float] the value of saturation component [0.0-1.0]
      # @param lightness [Float] the value of lightness component [0.0-1.0]
      #
      # @return [Inker::Color] a `Inker::Color` generated from passed HSL values
      def from_hsl(hue, saturation, lightness)
        Inker.color("hsl(#{hue}, #{saturation}, #{lightness})")
      end

      # A helper for `Inker::Color` generation from HSLA components.
      #
      # @param hue [Integer] the value of HUE component [0-360]
      # @param saturation [Float] the value of saturation component [0.0-1.0]
      # @param lightness [Float] the value of lightness component [0.0-1.0]
      # @param alpha [Float] the value of alpha component [0.0-1.1]
      #
      # @return [Inker::Color] a `Inker::Color` generated from passed HSLA values
      def from_hsla(hue, saturation, lightness, alpha)
        Inker.color("hsla(#{hue}, #{saturation}, #{lightness}, #{alpha})")
      end

      # Use MD5 digest of the string to get hex values from specified positions (by default `[0, 29, 14, 30, 28, 31]`)
      # in order to obtain a color in HEX format which represents the specified string.
      #
      # @params custom_string [String] a string from which to generate a color
      # @params positions [Array] an array of 6 numbers in range 0-31 which indicates the position
      #         of hex value to get in order to obtain a 6 chars hex string, which will be the result color
      #
      # @return [Inker::Color] a `Inker::Color` object which represents the color associated to input string
      def from_custom_string(custom_string, positions: [0, 29, 14, 30, 28, 31])
        digest = Digest::MD5.hexdigest(custom_string.to_s)
        Inker.color("##{positions.map { |p| digest[p] }.join}")
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
        if hex?(input)
          # Parse the string as HEX color
          result = parse_hex(input)
        elsif rgb?(input)
          # Parse the string as RGB color
          result = parse_rgb(input)
        elsif rgba?(input)
          # Parse the string as RGBA color
          result = parse_rgb(input, is_rgba: true)
        elsif hsl?(input)
          # Parse the string as HSL color
          result = parse_hsl(input)
        elsif hsla?(input)
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
        raise ArgumentError, "Unknown color format: #{color_str.to_s.strip.inspect}" if result.nil?

        result
      end

      # Calculates the contrast ratio between two colors.
      #
      # @param color1 [Inker::Color|String] the first color.
      # @param color2 [Inker::Color|String] the second color.
      #
      # @return [Float] the contrast ratio between the two colors [1.0-21.0].
      def contrast_ratio(color1, color2)
        color1.to_color.contrast_ratio(color2)
      end

      # Calculates the result of overlaying two colors.
      #
      # @param color1 [Inker::Color|String] the first color.
      # @param color2 [Inker::Color|String] the second color.
      #
      # @return [Inker::Color] the result of overlaying the two colors.
      def overlay(color1, color2)
        color1.to_color.overlay(color2)
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
        input = input.chars.map { |x| x * 2 }.join if input.length == 3

        # Get RGB components
        {
          red: Integer(input[0..1], 16),
          green: Integer(input[2..3], 16),
          blue: Integer(input[4..5], 16),
          # When color is in HEX8 format, get also alpha channel value
          alpha: input.length == 8 ? Integer(input[6..7], 16) / 255.0 : 1.0
        }
      end

      # Parse color string as RGB(A) color.
      #
      # @param color_str [String] input RGB(A) color string
      # @param is_rgba [Boolean] indicates if color string is in RGBA format
      #
      # @return [Hash] a `Hash` which contains RGBA components of parsed color
      def parse_rgb(color_str, is_rgba: false)
        components = color_str.gsub(/(^rgb(a)?\(|\)$)/, '').split(',')

        {
          red: components.shift.to_i,
          green: components.shift.to_i,
          blue: components.shift.to_i,
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
        components = color_str.gsub(/(^hsl(a)?\(|\)$)/, '').split(',')

        hue = components.shift.to_i % 360

        saturation = components.shift
        saturation = saturation.include?('%') ? saturation.to_f / 100 : saturation.to_f

        lightness = components.shift
        lightness = lightness.include?('%') ? lightness.to_f / 100 : lightness.to_f

        result = hsl_to_rgb(hue, saturation, lightness)
        result[:alpha] = is_hsla ? components.shift.to_f : 1.0

        result
      end

      # A helper function which allows to calculate the RGB component value from HSL color.
      #
      # @param p [Float] `2 * lightness -q`
      # @param q [Float] `lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation`
      # @param t [Float] `hue + 1/3`, `hue` or `hue - 1/3` according to which component is going to be calculated [r,g,b]
      #
      # @return [Float] a value which represents a RGB component in range 0.0-1.0
      def hue_to_rgb(p, q, t)
        t += 1 if t.negative?
        t -= 1 if t > 1

        return p + (q - p) * 6 * t           if t < 1.0 / 6.0
        return q                             if t < 1.0 / 2.0
        return p + (q - p) * (2 / 3 - t) * 6 if t < 2.0 / 3.0

        p
      end

      # Calculate HUE to RGB conversion params, with will be used to calculate RGB components in
      # combination with the `hsl_hue_weights` function.
      #
      # @param hue [Integer] hue component of HSL color [0-359]
      # @param saturation [Float] saturation component of HSL color [0.0-1.0]
      # @param lightness [Float] lightness component of HSL color [0.0-1.0]
      #
      # @return [Array<Float>] an array which contains the `c`, `x` and `m` values.
      def hue_convert_params(hue, saturation, lightness)
        c = (1 - (2 * lightness - 1).abs) * saturation
        x = c * (1 - ((hue / 60.0) % 2 - 1).abs)
        m = lightness - c / 2.0

        [c, x, m]
      end

      # A helper function
      def hsl_hue_weights(hue, c, x)
        case hue
        when 0..59 then [c, x, 0]
        when 60..119 then [x, c, 0]
        when 120..179 then [0, c, x]
        when 180..239 then [0, x, c]
        when 240..299 then [x, 0, c]
        when 300..359 then [c, 0, x]
        end
      end
    end
  end
end
