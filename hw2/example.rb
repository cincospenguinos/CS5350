# example.rb

# Class representing an example from our dataset.
class Example

  attr_reader :label # The label on this example
  attr_reader :features # The set of features

  def initialize(label)
    @label = label.to_f
    @features = [1.0] # First feature is always the bias value
  end

  def << (val)
    @features << val
  end

  def size
    @features.size
  end
end