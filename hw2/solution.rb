# solution.rb

require_relative 'example'
require_relative 'perceptron'

# NOTE: This is a proof of concept showing how to grab all of the examples in a dataset
examples = []

File.foreach('Dataset/phishing.dev') do |line|
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

perceptron = Perceptron.new(1.0)
perceptron.simple_perceptron(examples)
puts perceptron.weights.inspect

# TODO:  Run cross validation for ten epochs for each hyper-parameter combination to get the 
# best hyper-parameter setting.

# TODO: Train the classifier for 20 epochs. At the end of each training epoch, you should measure
# the accuracy of the classifier on the development set. For the averaged Perceptron,
# use the average classifier to compute accuracy.

# TODO: Use the classifier from the epoch where the development set accuracy is highest to
# evaluate on the test set.