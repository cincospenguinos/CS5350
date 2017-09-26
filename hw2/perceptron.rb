# perceptron.rb

# Class that manages running the perceptron algorithm to find the ideal hyperplane
# separating a set of values
class Perceptron

  attr_reader :learning_rate
  attr_reader :weights
  attr_reader :averaged_weights
  attr_reader :updates
  attr_reader :mistakes
  attr_reader :tests

  def initialize(learning_rate, options={})
    # For setting up the weights
    @@random = Random.new(18433)

    @learning_rate = learning_rate.to_f
    @weights = [ random_number ] # The first element is the bias weight TODO: Change this to be random

    if options[:averaged_perceptron]
      @averaged_weights = [ 1.0 ]
    else
      @averaged_weights = nil
    end

    # For dynamic learning rate
    @time_step = 0
    @initial_learning_rate = learning_rate.to_f
    @updates = 0

    # For margin
    @margin = options[:margin] unless options[:margin].nil?
    if options[:every_step].nil?
      @every_step = false
    else
      @every_step = options[:every_step]
    end

    # For testing
    @mistakes = 0
    @tests = 0
  end

  ##### Perceptron algorithms #####

  ## Simple version of perceptron
  def simple_perceptron(examples)
    perceptron(examples) do |example|
      [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] }
      @updates += 1
    end
  end

  ## Dynamic learning rate perceptron
  def dynamic_learning_perceptron(examples)
    perceptron(examples) do |example|
      @learning_rate = @initial_learning_rate.to_f / (1.0 + @time_step.to_f)
      [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] }
      @updates += 1
    end
  end

  ## Margin form of perceptron
  def margin_perceptron(examples)
    perceptron(examples) do |example|
      if weight_product(example) < @margin
        @learning_rate = @initial_learning_rate.to_f / (1.0 + @time_step.to_f)
        [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] }
        @updates += 1
      end
    end
  end

  def averaged_perceptron(examples)
    perceptron(examples) do |example|
      if is_mistake(example)
        [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] }
        @updates += 1
      end
      @averaged_weights.size.times { |i| @averaged_weights[i] += @weights[i] }
    end

    @averaged_weights
  end

  ## Tests the current weight set against the example provided. Adds one to mistakes
  def test_for(example)
    @mistakes += 1 if is_mistake(example)
    @tests += 1
  end

  ## Returns the accuracy of this perceptron
  def accuracy
    1 - (@mistakes.to_f / (@tests.to_f))
  end

  def self.all_flavors
    Perceptron.instance_methods(false) - [ :learning_rate, :weights, :averaged_weights, :mistakes, 
      :tests, :test_for, :reset_testing, :accuracy, :margin, :every_step, :updates ]
  end

  def self.single_hyper_param_flavors
    all_flavors - [ :margin_perceptron ]
  end

  ## Other methods

  ## Resets the perceptron instance so we get a new setup for each run
  def reset_testing
    @mistakes = 0
    @tests = 0
  end

  private

  # The perceptron algorithm that runs the show
  def perceptron(training_examples)
    training_examples.each do |example|
      yield example if @every_step || is_mistake(example)
      @time_step += 1
    end

    @weights
  end

  def weight_product(example)
    setup_weights(example)
    raise RuntimeError, 'Size of weights should be greater than example' if example.size > @weights.size
    product = 0.0
    if @averaged_weights.nil?
      [ @weights.size, example.size ].min.times { |i| product += @weights[i] * example.features[i] }
    else
      [ @averaged_weights.size, example.size ].min.times { |i| product += @averaged_weights[i] * example.features[i] }
    end
    product
  end

  def is_mistake(example)
    example.label * weight_product(example) <= 0.0
  end

  def setup_weights(examples)
    while @weights.size < examples.size do
      @weights << random_number
    end

    if !@averaged_weights.nil?
      while @averaged_weights.size < examples.size do
        @averaged_weights << random_number
      end
    end
  end
  
  def random_number
    @@random.rand(-1.0...1.0)
  end
end