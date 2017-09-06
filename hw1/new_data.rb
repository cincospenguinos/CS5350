# new_data.rb
require 'faker'
require_relative 'name'
require_relative 'decision_tree'

def function(name)
  if (name[0] <=> name[1]) == 1
    :+
  else
    :-
  end
end

def get_data(amt)
  data = []

  amt.times do 
    full_name = Faker::Name.name.to_s
    data << Name.new(full_name, function(full_name.downcase))
  end

  data
end

train_amt = 200
test_amt = 100

train_data = get_data(train_amt)
test_data = get_data(test_amt)

tree = DecisionTree.learn(train_data, Name.all_features, [:+, :-], -1)
success = 0.0
test_data.each { |e| success += 1.0 if e.label == tree.guess_for(e) }
# puts train_data.inspect
puts tree.inspect
puts "Success:\t#{success / test_data.size.to_f}"