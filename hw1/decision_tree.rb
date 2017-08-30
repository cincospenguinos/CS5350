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
    best_feature = get_best_feature(features, examples)

    root = DecisionTree.new

    @@acceptable_labels.each do |label|
      # TODO: Add a new child to root where feature => true
    end

    # TODO: This. This so hard in the face.
    root
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
    best_feature = nil
    highest_score = 0

    features.each do |feature|
      score = 0
      examples.each { |e| score += 1 if Name.to_label(e.send(feature)) == e.label }

      if score > highest_score
        highest_score = score
        best_feature = feature
      end

      # puts "\t#{feature} => #{score}"
    end

    # puts "Best feature is \"#{best_feature}\" at score #{highest_score}"
    best_feature
  end
end

















