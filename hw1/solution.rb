# solution.rb
# Solution to HW 1 for CS 5350
require 'thor'
require_relative 'decision_tree'

class SolutionCLI < Thor
  
  desc 'Grabs training data', 'Grabs training data for HW 1'
  def train
    puts 'Grabbing the training data...'
  end

  desc 'Runs test', 'Runs the test with the test data'
  def run_test
    puts 'Running test...'
  end
end

SolutionCLI.start(ARGV)