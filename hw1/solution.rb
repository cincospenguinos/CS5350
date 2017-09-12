# solution.rb
# Solution to HW 1 for CS 5350

require_relative 'decision_tree'
require_relative 'name'

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

def get_best_tree(depth, features)
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

    tree = DecisionTree.learn(data, features, Name.acceptable_labels, depth)
    score = test_against(validator, tree)

    if score > high_score
      high_score = score
      best_tree = tree
    end
  end

  best_tree
end

def test_against(data, tree)
  errors = 0
  data.each { |name| errors += 1 if tree.guess_for(name) != name.label }
  errors.to_f / data.size.to_f
end

def test_on_depth(depth, features)

end

def run_tests_on_depth(depths, features)
  training_data = gather_data('Dataset/training.data')
  test_data = gather_data('Dataset/test.data')

  depths.each do |depth|
    tree = get_best_tree(depth, features)
    training_failure = test_against(training_data, tree)
    test_failure = test_against(test_data, tree)

    if tree.max_depth != depth
      puts "#{tree.max_depth}\t#{training_failure}\t#{test_failure}" 
    else
      puts "#{depth}\t#{training_failure}\t#{test_failure}"
    end
  end
end

def accuracy(error)
  1.0 - error
end

def standard_deviation(data)
  mean = 0.0
  data.each { |d| mean += d.to_f }
  mean /= data.size.to_f

  data = data.clone
  data.each { |d| d = (d - mean)**2 }

  std_dev = 0
  data.each { |d| std_dev += d }
  std_dev / (data.size - 1).to_f
  Math.sqrt(std_dev)
end

puts '### Training on full set ###'

training_data = gather_data('Dataset/training.data')
test_data = gather_data('Dataset/test.data')

tree = DecisionTree.learn(training_data, Name.all_features, Name.acceptable_labels, -1)
failure = test_against(training_data, tree)
puts "Training Failure:\t#{failure}"
failure = test_against(test_data, tree)
puts "Test Failure:\t#{failure}"
max_depth = tree.max_depth
puts "Depth:\t#{max_depth}\n\n"

# Limit depth with 4-fold cross-validation. Report accuracy and standard deviation for each depth. Report what depth is best, and why.
puts '### 4-Fold Cross Validation ###'
depths = [ 1, 2, 3, 4, 5, 10, 15, 20, max_depth ]

path = 'Dataset/CVSplits/training0'
scores = {} # depth => [ score on 0, score on 1, score on 2, score on 3 ]

depths.each do |depth|
  puts "Testing out depth #{depth}..."
  4.times do |validator_idx|
    data = []
    validator = gather_data(path + validator_idx.to_s + '.data')

    4.times do |data_collection|
      next if data_collection == validator_idx
      data += gather_data(path + data_collection.to_s + '.data')
    end

    tree = DecisionTree.learn(data, Name.all_features, Name.acceptable_labels, depth)
    true_depth = [ depth, tree.max_depth ].min

    score = test_against(validator, tree)

    scores[true_depth] = [] if scores[true_depth].nil?
    scores[true_depth] << score
  end
end

puts "Depth\tValidator 0\tValidator 1\tValidator 2\tValidator 3\tStandard Deviation"

scores.each { |depth, values| puts "#{depth}\t#{accuracy(values[0])}\t#{accuracy(values[1])}\t#{accuracy(values[2])}\t#{accuracy(values[3])}\t#{standard_deviation(values)}" }

puts "\n"

ideal_depth = -1
highest_accuracy = 0.0

scores.each do |depth, errors|
  if highest_accuracy < accuracy(errors.min)
      ideal_depth = depth
      highest_accuracy = accuracy(errors.min)
    end
end

puts "Ideal depth is #{ideal_depth}\n\n"
puts '### Training at ideal depth ###'

tree = DecisionTree.learn(training_data, Name.all_features, Name.acceptable_labels, ideal_depth)
failure = test_against(training_data, tree)
puts "Training Failure:\t#{failure}"
failure = test_against(test_data, tree)
puts "Test Failure:\t#{failure}"
puts "Accuracy:\t#{accuracy(failure)}"






