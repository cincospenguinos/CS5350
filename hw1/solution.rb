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
    tree = DecisionTree.learn(data, features, [:+, :-])
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