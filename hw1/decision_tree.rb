# decision_tree.rb
require 'byebug'

# Class representing a decision tree for this specific assignment.
class DecisionTree

  attr_accessor :guess # Either a guess (it's a leaf) or the feature to check
  attr_accessor :children


  def initialize(guess=nil)
    @guess = guess
    @children = {}
  end

  ## INSTANCE METHODS

  def is_guess?
    !@guess.nil? && @@acceptable_labels.include?(@guess)
  end

  def guess_for(name)
    return @guess if is_guess?
    @children[name.send(@guess)].guess_for(name)
  end

  ## CLASS METHODS --- Where the magic happens

  def self.learn(examples, features, acceptable_labels)
    @@acceptable_labels = acceptable_labels
    return id3(examples, features, @@acceptable_labels[1])
  end

  private

  ## Returns a decision tree from the examples and given features
  def self.id3(examples, features, target_label)
    return DecisionTree.new(examples[0].label) if examples_have_same_label?(examples)
    return DecisionTree.new(get_most_common_label(examples)) if features.length == 0

    best_feature = get_best_feature_info_gains(features, examples)
    subset = get_all_that_matches(best_feature, examples)
    node = DecisionTree.new(best_feature)

    Name.possible_values(best_feature).each do |val|
      if subset.size == 0
        node.children[val] = DecisionTree.new(get_most_common_label(examples))
      else
        node.children[val] = id3(subset, features - [ best_feature ], target_label)
      end
    end

    node
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
  def self.get_best_feature_info_gains(features, examples)
    total_entropy = entropy(examples)
    info_gains = {}

    features.each do |f|
      subset = get_all_that_matches(f, examples)
      the_gains = information_gain(examples, subset)
      info_gains[f] = the_gains
    end

    info_gains.key(info_gains.values.max)
  end

  def self.information_gain(complete_set, subset)
    total_entropy = entropy(complete_set)

    gain = 0.0


    total_entropy - entropy(subset)
  end

  ## Returns the entropy value of the set provided
  def self.entropy(set)
    raise RuntimeError, "set cannot be empty!" if set.size == 0
    pluses = 0.0
    set.each { |e| pluses += 1.0 if e.label == :+ }
    pluses /= set.size.to_f
    minuses = 1.0 - pluses

    -pluses * log(pluses) - minuses * log(minuses)
  end

  def self.get_all_that_matches(feature, examples)
    raise RuntimeError, "#{feature} is not a valid feature! " unless feature.is_a?(Symbol)
    examples.find_all { |e| e.send(feature) }
  end

  def self.get_most_common_label(examples)
    pluses = 0
    examples.each { |e| pluses += 1 if e.label == :+}
    
    if pluses >= examples.size / 2
      :+
    else
      :-
    end
  end

  def self.log(number)
    return 0.0 if number == 0.0
    Math::log(number, 2)
  end
end

















