# solution.rb

require 'thread'
require 'thwait'

require_relative 'example'
require_relative 'perceptron'

raise RuntimeError, 'Only 4 potential flavors should be available!' if Perceptron.all_flavors.size != 4 # Quick sanity check

# TODO: Look at assignment info about setting the bias, and do what it tells you in the Perceptron class

## Gets examples from file matching filename passed
def get_examples_from(filename)
  examples = []

  File.foreach(filename) do |line|
    label = line.split(/\s+/)[0]
    feature_set = line.split(/\s+/) - [ label ]
    
    e = Example.new(label)

    i = 1
    feature_set.each do |value_pair|
      j = value_pair.split(':')[0].to_f
      
      while i < j do 
        e << 0 
        i += 1
      end

      e << value_pair.split(':')[1].to_f
      i += 1
    end

    examples << e
  end

  examples
end

## Tests against the file passed using the perceptron provided
def test_against(perceptron, file_name)
  # TODO: This
end

## Returns the ideal hyper parameter given the perceptron flavor and the set of hyper_parameters
def ideal_hyper_parameter(hyper_parameters, flavor, epochs=10)
  # puts "Ideal Hyper Param for #{flavor}\n"
  shuffle_param = Random.new(14)
  mistakes = {}

  # Five-fold cross validation
  5.times do |test_index|
    training_examples = []
    i = (test_index + 1) % 5

    while i < 5 do
      training_examples += get_examples_from("Dataset/CVSplits/training0#{i}.data") if i != test_index
      i += 1
    end

    test_examples = get_examples_from("Dataset/CVSplits/training0#{test_index}.data")

    if flavor == :margin_perceptron
      learning_rates = hyper_parameters[0]
      margins = hyper_parameters[1]

      learning_rates.each do |rate|
        margins.each do |m|
          perceptron = Perceptron.new(rate, m)

          epochs.times do
            perceptron.send(flavor, training_examples.shuffle(random:shuffle_param))
            test_examples.each { |e| perceptron.test_for(e) }
          end

          mistakes[perceptron.mistakes] = [rate, m]
        end
      end
    else
      hyper_parameters.each do |hyper_param|
        perceptron = Perceptron.new(hyper_param)

        epochs.times do
          perceptron.send(flavor, training_examples.shuffle(random:shuffle_param))
          test_examples.each { |e| perceptron.test_for(e) }
        end

        mistakes[perceptron.mistakes] = hyper_param
      end
    end
  end

  mistakes[mistakes.keys.min]
end

# Five-Fold cross validation to find the ideal hyper parameter for each flavor
puts '### FIVE FOLD CROSS VALIDATION ###'
puts 'This might take a while...'
hyper_params = {}

Perceptron.all_flavors.each do |flavor|
  param = nil

  if Perceptron.single_hyper_param_flavors.include?(flavor)
    param = ideal_hyper_parameter([1, 0.1, 0.01], flavor)
  else
    param = ideal_hyper_parameter([ [1, 0.1, 0.01], [1, 0.1, 0.01] ] , flavor)
  end

  hyper_params[flavor] = param
end

puts hyper_params.inspect

# TODO: Train the classifier for 20 epochs. At the end of each training epoch, you should measure
# the accuracy of the classifier on the development set. For the averaged Perceptron,
# use the average classifier to compute accuracy.

# TODO: Use the classifier from the epoch where the development set accuracy is highest to
# evaluate on the test set.