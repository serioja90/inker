# The string class, which is wrapped in order to add the possibility
# to convert a string to {Inker::Color}.
class String
  # Creates a new instance of {Inker::Color} directly from the string
  #
  # @example
  #   "#000000".to_color
  #
  # @return [Inker::Color]
  def to_color
    Inker.color(self)
  end
end