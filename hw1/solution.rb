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

def run_tests_on_depth(depths, features)
  training_data = gather_data('Dataset/training.data')
  test_data = gather_data('Dataset/test.data')

  depths.each do |depth|
    tree = get_best_tree(depth, features)
    training_failure = test_against(training_data, tree)
    test_failure = test_against(test_data, tree)

    if depth == -1
      puts "#{tree.max_depth}\t#{training_failure}\t#{test_failure}" 
    else
      puts "#{depth}\t#{training_failure}\t#{test_failure}"
    end
  end
end

depths = [ 1, 2, 3, 4, 5, -1 ]

puts 'Given Features'
puts "Depth\tTrain Error\tTest Error"
run_tests_on_depth(depths, Name.given_features)

puts "\nProposed Features"
puts "Depth\tTrain Error\tTest Error"
run_tests_on_depth(depths, Name.proposed_features)

puts "\nAll Features"
puts "Depth\tTrain Error\tTest Error"
run_tests_on_depth(depths, Name.all_features)