module Inker
  class Color
    # This module implements the methods which can be used to serialize
    # a color as string in different formats.
    module Serializers

      # Convert color to a HEX color string.
      #
      # @param force_alpha [Boolean] indicates if alpha channel should be included in HEX color string
      #        when alpha component wasn't specified
      # @return [String] a HEX color string
      def hex(force_alpha: false)
        result = hex6
        result += (alpha * 255).to_i.to_s(16).rjust(2, "0") if alpha < 1 or force_alpha

        return result
      end


      # Convert color to a HEX color string without alpha channel.
      #
      # @return [String] a HEX color string without alpha channel
      def hex6
        result = "#"
        result += red.to_s(16).rjust(2, "0")
        result += green.to_s(16).rjust(2, "0")
        result += blue.to_s(16).rjust(2, "0")

        return result
      end


      # Convert color to RGB color string.
      #
      # @return [String] a RGB color string
      def rgb
        return "rgb(#{red}, #{green}, #{blue})"
      end


      # Convert color to RGBA color string.
      #
      # @return [String] a RGBA color string
      def rgba(precision: 2)
        return "rgba(#{red}, #{green}, #{blue}, #{alpha.round(precision)})"
      end


      # Convert color to HSL color string.
      #
      # @return [String] a HSL color string
      def hsl(precision: 2)
        return "hsl(#{hue}, #{saturation.round(precision)}, #{lightness.round(precision)})"
      end


      # Convert color to HSL color string.
      #
      # @return [String] a HSL color string
      def hsla(precision: 2)
        return "hsl(#{hue}, #{saturation.round(precision)}, #{lightness.round(precision)}, #{alpha.round(precision)})"
      end
    end
  end
end