# decision_tree.rb
require 'byebug'

# Class representing a decision tree for this specific assignment.
class DecisionTree

  attr_accessor :guess # Either a guess (it's a leaf) or the feature to check
  attr_accessor :children
  attr_accessor :level


  def initialize(level, guess)
    @guess = guess
    @level = level
    @children = {}
  end

  ## INSTANCE METHODS

  def is_guess?
    !@guess.nil? && @@acceptable_labels.include?(@guess)
  end

  def guess_for(name)
    return @guess if is_guess?
    raise RuntimeError, "#{name.send(@guess)} is not a key in children!" if @children[name.send(@guess)].nil?
    @children[name.send(@guess)].guess_for(name)
  end

  def max_depth
    return 1 if is_guess?

    max = 0
    @children.each { |val, tree| max = tree.max_depth if tree.max_depth > max }
    max + 1
  end

  ## CLASS METHODS --- Where the magic happens

  def self.learn(examples, features, acceptable_labels, max_level)
    @@acceptable_labels = acceptable_labels
    return id3(examples, features, @@acceptable_labels[1], 1, max_level)
  end

  def self.information_gain(complete_set, feature)
    sum = 0.0 # This is our sum of the weighted entropies

    Name.possible_values(feature).each do |value|
      sv = get_all_that_fits_feature_and_value(feature, value, complete_set) # This is Sv
      next if sv.size == 0
      sum += (sv.size.to_f / complete_set.size.to_f) * entropy(sv)
    end

    gain = entropy(complete_set) - sum
    raise RuntimeError, "Gain was #{gain} which is not positive!" if gain < 0.0
    gain
  end

  private

  ## Returns a decision tree from the examples and given features
  def self.id3(examples, features, target_label, current_level, max_level)
    return DecisionTree.new(current_level, examples[0].label) if examples_have_same_label?(examples)
    return DecisionTree.new(current_level, get_most_common_label(examples)) if features.length == 0
    return DecisionTree.new(current_level, get_most_common_label(examples)) if max_level > 0 && current_level == max_level
    
    best_feature = get_best_feature_info_gains(features, examples)
    node = DecisionTree.new(current_level, best_feature)

    Name.possible_values(best_feature).each do |val|
      subset = get_all_that_fits_feature_and_value(best_feature, val, examples)

      if subset.size == 0
        node.children[val] = DecisionTree.new(current_level, get_most_common_label(examples))
      else
        node.children[val] = id3(subset, features - [ best_feature ], target_label, current_level + 1, max_level)
      end
    end

    node
  end

  ## Helper method. Returns true if all the examples have the same label
  def self.examples_have_same_label?(examples)
    label = examples[0].label
    flag = true

    examples.each do |e|
      flag = false if e.label != label
    end
    flag
  end

  ## Returns the best feature in the collection that matches the most examples
  def self.get_best_feature_info_gains(features, examples)
    total_entropy = entropy(examples)
    best_feature = nil
    high_score = -1.0

    features.each do |f|
      gain = information_gain(examples, f)
      if gain > high_score
        best_feature = f
        high_score = gain
      end
    end

    best_feature
  end

  ## Returns the entropy value of the set provided
  def self.entropy(set)
    raise RuntimeError, 'Set cannot be empty!' if set.size == 0
    pluses = 0.0
    set.each { |e| pluses += 1.0 if e.label == :+ }
    pluses /= set.size.to_f
    minuses = 1.0 - pluses

    -pluses * log(pluses) - minuses * log(minuses)
  end

  def self.get_all_that_fits_feature(feature, examples)
    raise RuntimeError, "#{feature} is not a valid feature! " unless feature.is_a?(Symbol)
    examples.find_all { |e| e.send(feature) }
  end

  def self.get_all_that_fits_feature_and_value(feature, value, examples)
    examples.find_all { |e| e.send(feature) == value }
  end

  def self.get_most_common_label(examples)
    pluses = 0
    examples.each { |e| pluses += 1 if e.label == :+}

    if pluses > examples.size / 2
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

















