require "yaml"
require "digest"
require "inker/version"
require "inker/color"
require "inker/wrappers/string"


# The main module of the gem, which loads all necessary classes and
# provides a helper for {Inker::Color} object generation from a string and
# for named colors map.
module Inker
  class << self
    # Creates a new instance of {Inker::Color}, which could be used for color
    # manipulation or for collecting color info.
    #
    # @param str [String] the string to transform into {Inker::Color}
    # @return [Inker::Color]
    def color(str)
      Color.new(str)
    end


    # Returns the map of named colors and their respective HEX representation.
    #
    # @return [Hash] a map of named colors and their HEX color
    def named_colors
      @named_colors ||= YAML.load_file(File.expand_path('../data/colors.yml', __FILE__))
    end
  end
end
