# helper.rb

# To help me calculate the bullshit
def log(number)
  return 0 if number == 0.0
  Math::log(number, 2)
end

def entropy(positives, total)
  positives = positives.to_f / total.to_f
  negatives = 1.0 - positives.to_f
  -positives * log(positives) - negatives * log(negatives)
end

def info_gain(values, total_entropy)
  gain = 0.0

  values.each do |number, positives|
    gain += entropy(positives, number) * number.to_f / 9.0
  end

  gain = total_entropy - gain
  gain
end

total_entropy = entropy(5, 9)
technology = { 3 => 1, 6 => 4 }
environment = { 5 => 4, 4 => 1 }
human = { 4 => 1, 4 => 4, 1 => 1 }
distance = { 2 => 1, 1 => 1, 3 => 2, 3 => 1 }

puts "Technology: #{info_gain(technology, total_entropy)}"
puts "Environment: #{info_gain(environment, total_entropy)}"
puts "Human: #{info_gain(human, total_entropy)}"
puts "Distance: #{info_gain(distance, total_entropy)}"
