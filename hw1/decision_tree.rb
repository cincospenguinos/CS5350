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

  # To help with debugging
  def to_s(levels=0)
    str = ""
    levels.times { str += "\t" }

    if is_guess?
      str += @guess.to_s
    else
      @children.each do |feature, values|
        str += feature.to_s + "\n"

        values.each do |value, tree|
          levels.times { str += "\t" }
          str += value.to_s
          str += tree.to_s
        end
      end
    end

    str
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
    best_feature = get_best_feature_info_gains(features, examples)
    subset = get_all_that_matches(best_feature, examples)
    node = DecisionTree.new(best_feature)

    Name.possible_values.each do |val|
      # byebug
      if subset.size == 0
        node.children[val] = DecisionTree.new(get_most_common_label(examples))
      else
        node.children[val] = id3(subset, features - [ best_feature ], get_most_common_label(subset))
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
    # puts "Total entropy is #{total_entropy}"

    features.each do |f|
      subset = get_all_that_matches(f, examples)
      the_gains = information_gain(total_entropy, examples.size, subset)
      # puts "Info gain of #{f} is #{the_gains}"
      info_gains[f] = the_gains
    end

    info_gains.key(info_gains.values.max)
  end

  def self.get_best_feature_majority_error(features, examples)
    # TODO: This
    features.each do |f|
      subset = get_all_that_matches(f, examples)

    end
  end

  def self.information_gain(total_entropy, total_size, subset)
    # TODO: This is off, I think. We need to calculate this differently, maybe? Just look at it.
    return 0 if subset.size == 0
    raise RuntimeError, "subset has entropy that is NaN!" if entropy(subset).nan?
    total_entropy - subset.size.to_f / total_size.to_f * entropy(subset)
  end

  ## Returns the entropy value of the set provided
  def self.entropy(set)
    raise RuntimeError, "set cannot be empty!" if set.size == 0
    pluses = 0.0
    set.each { |e| pluses += 1 if e.label == :+ }
    minuses = set.size.to_f - pluses.to_f

    pluses /= set.size.to_f
    minuses /= set.size.to_f

    pluses != 0.0 ? p_log = Math::log(pluses, 2) : p_log = 0.0
    minuses != 0.0 ? m_log = Math::log(minuses, 2) : m_log = 0.0

    -pluses * p_log - minuses * m_log
  end

  def self.get_all_that_matches(feature, examples)
    raise RuntimeError, "#{feature} is not a valid feature! " unless feature.is_a?(Symbol)
    examples.find_all { |e| e.send(feature) }
  end

  def self.get_most_common_label(examples)
    pluses = 0
    examples.each { |e| pluses += 1 if e.label == :+}
    minuses = examples.size - pluses
    
    if pluses > minuses
      :+
    else
      :-
    end
  end
end

















