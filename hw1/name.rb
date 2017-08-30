# name.rb
# A name from the test data

class Name

  attr_reader :full_name
  attr_reader :label

  @@ACCEPTABLE_LABELS = [:+, :-]

  def initialize(full_name, label)
    raise RuntimeError, "#{label} is not an acceptable label!" unless label.is_a?(Symbol) && @@ACCEPTABLE_LABELS.include?(label)

    @full_name = full_name
    @label = label
  end

  def first_name
  end
end