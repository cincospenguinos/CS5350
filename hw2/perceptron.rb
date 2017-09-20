# perceptron.rb

# Class that manages running the perceptron algorithm to find the ideal hyperplane
# separating a set of values
class Perceptron

  attr_reader :learning_rate
  attr_reader :weights
  attr_reader :mistakes
  attr_reader :tests

  def initialize(learning_rate)
    @learning_rate = learning_rate.to_f
    @weights = [ 1.0 ] # The first element is the bias weight
    @mistakes = 0
    @tests = 0
  end

  ## Perceptron algorithms

  def simple_perceptron(examples)
    perceptron(examples) do |example|
      [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] }
    end
  end

  def dynamic_learning_perceptron(examples)
    perceptron do |example|
      # TODO: This
    end
  end

  def margin_perceptron(examples)
    # perceptron do
    #   raise RuntimeError, 'Implement this!'
    # end
  end

  def averaged_perceptron(examples)
    # perceptron do
    #   raise RuntimeError, 'Implement this!'
    # end
  end

  # TODO: The fifth perceptron, if there's time

  ## Tests the current weight set against the example provided. Adds one to mistakes
  def test_for(example)
    @mistakes += 1 if is_mistake(example)
    @tests += 1
  end

  def self.all_flavors
    Perceptron.instance_methods(false) - [ :learning_rate, :weights, :mistakes, :tests, :test_for ]
  end

  def self.single_hyper_param_flavors
    all_flavors - [ :margin_perceptron ]
  end

  ## Other methods

  private

  ## Resets the perceptron instance so we get a new setup for each run
  def reset
    @weights.each { |i| @weights[i] = 0.0 }
    @weights[0] = 1.0
    @mistakes = 0
    @tests = 0
  end

  # The perceptron algorithm that runs the show
  def perceptron(training_examples)
    reset # To ensure that this instance doesn't have weights that stomp on each other
    training_examples.each do |example|
      yield example if is_mistake(example)
    end

    @weights
  end

  def weight_product(example)
    raise RuntimeError, 'Size of weights should be greater than example' if example.size > @weights.size
    product = 0.0
    [ @weights.size, example.size ].min.times { |i| product += @weights[i] * example.features[i] }
    product
  end

  def is_mistake(example)
    while @weights.size < example.size do
      @weights << 0.0 
    end
    example.label * weight_product(example) <= 0.0
  end
end