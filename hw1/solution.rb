# solution.rb

# Solution to HW 1 for CS 5350
require 'thor'

require_relative 'decision_tree'
require_relative 'name'

# Class that sets up a command line argument
class SolutionCLI < Thor
  desc 'Runs test', 'Runs the test with the test data'
  def test
    depths = [ 1, 2, 3, 4, 5, -1 ]
    training_data = gather_data('Dataset/training.data')
    test_data = gather_data('Dataset/test.data')

    puts "Depth\tTrain\tTest"

    depths.each do |depth|
      tree = get_best_tree(depth)
      training_success = test_against(training_data, tree)
      test_success = test_against(test_data, tree)

      puts "#{depth}\t#{training_success}\t#{test_success}"

      # puts "#{depth} \t #{tree.inspect}"
    end
  end

  private

  def get_best_tree(depth)
    path = 'Dataset/CVSplits/training0'
    best_tree = nil
    high_score = 0.0

    4.times do |validator_idx|
      data = []
      validator = gather_data(path + validator_idx.to_s + '.data')

      4.times do |data_collection|
        next if data_collection == validator_idx
        data += gather_data(path + data_collection.to_s + '.data')
      end

      tree = DecisionTree.learn(data, Name.all_features, Name.acceptable_labels, depth)
      score = test_against(validator, tree)

      # puts "Finished #{validator_idx}"

      if score > high_score
        high_score = score
        best_tree = tree

        # puts "High score! #{high_score} \t #{validator_idx}"
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