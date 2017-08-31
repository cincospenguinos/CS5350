# decision_tree.rb

# Class representing a decision tree for this specific assignment.
class DecisionTree

  attr_accessor :guess
  attr_accessor :children


  def initialize(guess=nil)
    @guess = guess
    @children = {}
  end

  ## INSTANCE METHODS

  def is_guess?
    !@guess.nil? && @@acceptable_labels.include?(@guess)
  end

  ## CLASS METHODS --- Where the magic happens

  def self.learn(examples, features, acceptable_labels)
    @@acceptable_labels = acceptable_labels
    return id3(examples, features, @@acceptable_labels[0])
  end

  private

  ## Returns a decision tree from the examples and given features
  def self.id3(examples, features, target_label)
    return DecisionTree.new(examples[0].label) if examples_have_same_label?(examples)
    best_feature = get_best_feature(features, examples, target_label)


  end

  ## Helper method. Returns true if all the examples have the same label
  def self.examples_have_same_label?(examples)
    label = examples[0].label
    examples.each do |example|
      return false if example.label != label
    end

    true
  end

  ## Returns the best feature in the collection that matches the most examples
  def self.get_best_feature(features, examples, target_label)
    # TODO: This
    entropy(examples)
  end

  ## Returns the entropy value of the set provided
  def self.entropy(examples)
    pluses = 0
    examples.each { |e| pluses += 1 if e.label == :+ }
    minuses = examples.length - pluses
    pluses /= examples.length
    minuses /= examples.length

    return -pluses * Math::log(pluses, 2) - minuses * Math::log(minuses, 2)
  end
end

















