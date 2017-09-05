# solution.rb

# Solution to HW 1 for CS 5350
require 'thor'

require_relative 'decision_tree'
require_relative 'name'

# Class that sets up a command line argument
class SolutionCLI < Thor
  
  desc 'Grabs training data', 'Grabs training data for HW 1'
  def train
    data = gather_data('Dataset/CVSplits/training03.data')
    features = Name.instance_methods(false) - [:label]# The instance methods will define our features
    tree = get_best_tree
    run_on_test_data(tree)
  end

  desc 'Runs test', 'Runs the test with the test data'
  def test
    puts 'Running test...'
  end

  private

  def run_on_test_data(tree)
    successes = 0
    test_data = gather_data('Dataset/test.data')
    test_data.each { |name| successes += 1 if tree.guess_for(name) == name.label } 
    # puts "#{tree.guess_for(test_data[0])}"
    puts "There were #{successes} correct guesses for #{test_data.size} total names."
    puts tree.inspect
  end

  def get_best_tree
    validations = [0, 1, 2, 3]
    success_rate = 0.0
    best_tree = nil

    validations.each do |val|
      cross_validation = gather_data("Dataset/CVSplits/training0#{val}.data")

      data = []

      (validations - [val]).each do |others|
        data += gather_data("Dataset/CVSplits/training0#{others}.data")
      end

      tree = DecisionTree.learn(data, Name.instance_methods(false) - [:label], [:+, :-])
      success = test_against(cross_validation, tree)

      if success > success_rate
        best_tree = tree
        success_rate = success
      end
    end

    best_tree
  end

  def test_against(data, tree)
    successful_guesses = 0
    data.each { |name| successful_guesses += 1 if tree.guess_for(name) == name.label }
    successful_guesses.to_f / data.size.to_f
  end

  def gather_data(file_name)
    data = []
    text = File.open(file_name).read
    text.gsub(/\r\n?/, "\n")

    text.each_line do |line|
      label = line[0].to_sym
      full_name = line[2...line.length].gsub("\n", '')

      data << Name.new(full_name, label)
    end

    data
  end
end

SolutionCLI.start(ARGV)