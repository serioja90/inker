# frozen_string_literal: true

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
        result += (alpha * 255).to_i.to_s(16).rjust(2, '0') if alpha < 1 || force_alpha

        result
      end

      # Convert color to a HEX color string without alpha channel.
      #
      # @return [String] a HEX color string without alpha channel
      def hex6
        result = "#"
        result += red.to_s(16).rjust(2, '0')
        result += green.to_s(16).rjust(2, '0')
        result += blue.to_s(16).rjust(2, '0')

        result
      end

      # Convert color to RGB color string.
      #
      # @return [String] a RGB color string
      def rgb
        "rgb(#{red}, #{green}, #{blue})"
      end

      # Convert color to RGBA color string.
      #
      # @param alpha_precision [Integer] indicates the precision of alpha value
      #
      # @return [String] a RGBA color string
      def rgba(alpha_precision: 2)
        "rgba(#{red}, #{green}, #{blue}, #{alpha.round(alpha_precision)})"
      end

      # Convert color to HSL color string.
      #
      # @return [String] a HSL color string
      def hsl
        "hsl(#{hue}, #{(saturation * 100).round}%, #{(lightness * 100).round}%)"
      end

      # Convert color to HSL color string.
      #
      # @param alpha_precision [Integer] indicates the precision of alpha value
      #
      # @return [String] a HSL color string
      def hsla(alpha_precision: 2)
        "hsl(#{hue}, #{(saturation * 100).round}%, #{(lightness * 100).round}%, #{alpha.round(alpha_precision)})"
      end
    end
  end
end
