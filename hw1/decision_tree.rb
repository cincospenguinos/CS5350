# decision_tree.rb
require 'byebug'

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
    best_feature = get_best_feature(features, examples)

    subset = get_all_that_matches(best_feature, examples)
    node = DecisionTree.new

    Name.possible_values.each do |val|
      # byebug
      node.children[best_feature] = {}
      if subset.size == 0
        node.children[best_feature][val] = DecisionTree.new(target_label)
      else
        features -= [ best_feature ]
        node.children[best_feature][val] = id3(subset, features, target_label)
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
  def self.get_best_feature(features, examples)
    total_entropy = entropy(examples)
    info_gains = {}
    # puts "Total entropy is #{total_entropy}"

    features.each do |f|
      subset = get_all_that_matches(f, examples)
      the_gains = information_gain(total_entropy, examples.size, subset)
      # puts "Info gain of #{f} is #{the_gains}"
      info_gains[f] = the_gains
    end

    # TODO: We are doing max info gain here - I'm not sure if that is correct
    info_gains.key(info_gains.values.max)
  end

  def self.information_gain(total_entropy, total_size, subset)
    total_entropy - subset.size.to_f / total_size.to_f * entropy(subset)
  end

  ## Returns the entropy value of the set provided
  def self.entropy(set)
    pluses = 0.0
    set.each { |e| pluses += 1 if e.label == :+ }
    minuses = set.size.to_f - pluses

    pluses /= set.size
    minuses /= set.size

    pluses != 0.0 ? p_log = Math::log(pluses, 2) : p_log = 0.0
    minuses != 0.0 ? m_log = Math::log(minuses, 2) : m_log = 0.0

    -pluses * p_log - minuses * m_log
  end

  def self.get_all_that_matches(feature, examples)
    raise RuntimeError, "#{feature} is not a valid feature! " unless feature.is_a?(Symbol)
    examples.find_all { |e| e.send(feature) }
  end
end

















