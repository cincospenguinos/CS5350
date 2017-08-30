# solution.rb
# Solution to HW 1 for CS 5350
require 'thor'

require_relative 'decision_tree'
require_relative 'name'

class SolutionCLI < Thor
  
  desc 'Grabs training data', 'Grabs training data for HW 1'
  def train
    puts 'Grabbing the training data...'
    data = gather_data('Dataset/training.data')
  end

  desc 'Runs test', 'Runs the test with the test data'
  def run_test
    puts 'Running test...'
  end

  private

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