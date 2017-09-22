# solution.rb
require 'byebug'

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
def test_against(perceptron, examples)
  examples.each do |e|
    # byebug
    perceptron.test_for(e)
  end

  perceptron.accuracy
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

    options = {}

    if flavor == :margin_perceptron
      learning_rates = hyper_parameters[0]
      margins = hyper_parameters[1]

      learning_rates.each do |rate|
        margins.each do |m|
          perceptron = Perceptron.new(rate, { margin: m, every_step: true})

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
        perceptron = Perceptron.new(hyper_param, {every_step: true, averaged_perceptron: true}) if flavor == :averaged_perceptron

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
hyper_params = {}

Perceptron.all_flavors.each do |flavor|
  puts "Trying out #{flavor}..."
  param = nil

  if Perceptron.single_hyper_param_flavors.include?(flavor)
    param = ideal_hyper_parameter([1, 0.1, 0.01], flavor)
  else
    param = ideal_hyper_parameter([ [1, 0.1, 0.01], [1, 0.1, 0.01] ] , flavor)
  end

  hyper_params[flavor] = param
end

puts "Ideal hyper_params: #{hyper_params.inspect}"

# TODO: Train the classifier for 20 epochs. At the end of each training epoch, you should measure
# the accuracy of the classifier on the development set. For the averaged Perceptron,
# use the average classifier to compute accuracy.

puts '### TRAINING CLASSIFIERS FOR 20 EPOCHS ###'
accuracies = {}
perceptrons = {}
random = Random.new(180716) # The date of my son's birthday
training_data = get_examples_from('Dataset/phishing.train')
development_data = get_examples_from('Dataset/phishing.dev')

Perceptron.all_flavors.each do |flavor|
  puts "Training #{flavor}"
  accuracies[flavor] = {}
  perceptron = nil

  if flavor == :margin_perceptron
    perceptron = Perceptron.new(hyper_params[flavor][0], { margin: hyper_params[flavor][1], every_step: true } )
  elsif flavor == :averaged_perceptron
    perceptron = Perceptron.new(hyper_params[flavor], { every_step: true, averaged_perceptron: true } )
  else
    perceptron = Perceptron.new(hyper_params[flavor])
  end

  20.times do |epoch|
    print "#{epoch + 1}..."
    perceptron.send(flavor, training_data.shuffle(random:random))
    accuracies[flavor][epoch + 1] = test_against(perceptron, development_data)
  end

  print "\n"
  perceptrons[flavor] = perceptron
end

puts "Flavor\tEpoch\tAccuracy"
accuracies.each { |flavor, data| data.each { |epoch, accuracy| puts "#{flavor}\t#{epoch}\t#{accuracy}" } }

# TODO: Use the classifier from the epoch where the development set accuracy is highest to
# evaluate on the test set.