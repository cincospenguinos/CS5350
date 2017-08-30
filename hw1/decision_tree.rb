# decision_tree.rb

# Class representing a decision tree for this specific assignment.
class DecisionTree

  attr_accessor :guess

  def initialize(guess=nil)
    @guess = guess
  end

  def self.learn(examples, features, acceptable_labels)
    @@acceptable_labels = acceptable_labels
    return id3(examples, features, @@acceptable_labels[0])
  end

  private

  ## Returns a decision tree from the examples and given features
  def self.id3(examples, features, target_label)
    return DecisionTree.new(examples[0].label) if examples_have_same_label?(examples)

  end

  ## Helper method. Returns true if all the examples have the same label
  def self.examples_have_same_label?(examples)
    label = examples[0].label
    examples.each do |example|
      return false if example.label != label
    end

    true
  end

  ## Returns true if this decision tree is a leaf node
  def is_leaf?
  end

end