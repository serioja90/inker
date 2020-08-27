require "yaml"
require "inker/version"
require "inker/color"
require "inker/string"

module Inker
  class Error < StandardError; end

  class << self
    # Creates a new instance of {Inker::Color}, which could be used for color
    # manipulation or for collecting color info.
    #
    # @param str [String] the string to transform into {Inker::Color}
    # @return [Inker::Color]
    def color(str)
      Color.new(str)
    end

    def named_colors
      @named_colors ||= YAML.load_file(File.expand_path('../data/colors.yml', __FILE__))
    end
  end
end
