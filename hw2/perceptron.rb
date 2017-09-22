# perceptron.rb

# Class that manages running the perceptron algorithm to find the ideal hyperplane
# separating a set of values
class Perceptron

  attr_reader :learning_rate
  attr_reader :weights
  attr_reader :averaged_weights
  attr_reader :mistakes
  attr_reader :tests

  def initialize(learning_rate, options={})
    @learning_rate = learning_rate.to_f
    @weights = [ 1.0 ] # The first element is the bias weight
    @averaged_weights = [ 1.0 ] if options[:averaged_perceptron]

    # For dynamic learning rate
    @time_step = 0
    @initial_learning_rate = learning_rate.to_f

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

    # For setting up the weights
    @@random = Random.new(18433)
  end

  ##### Perceptron algorithms #####

  ## Simple version of perceptron
  def simple_perceptron(examples)
    perceptron(examples) do |example|
      [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] }
    end
  end

  ## Dynamic learning rate perceptron
  def dynamic_learning_perceptron(examples)
    perceptron(examples) do |example|
      @learning_rate = @initial_learning_rate / (1 + @time_step)
      [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] }
    end
  end

  ## Margin form of perceptron
  def margin_perceptron(examples)
    perceptron(examples) do |example|
      if weight_product(example) < @margin
        @learning_rate = @initial_learning_rate / (1 + @time_step)
        [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] }
      end
    end
  end

  def averaged_perceptron(examples)
    perceptron(examples) do |example|
      [ @weights.size, example.size ].min.times { |i| @weights[i] += @learning_rate * example.label * example.features[i] } if is_mistake(example)
      @averaged_weights.size.times { |i| @averaged_weights[i] += @weights[i] }
    end

    @averaged_weights
  end

  ## Tests the current weight set against the example provided. Adds one to mistakes
  def test_for(example)
    if @averaged_weights.nil?
      @mistakes += 1 if is_mistake(example)
    else
      @mistakes += 1 if weight_product_averaged(example) * example.label <= 0.0
    end

    @tests += 1
  end

  ## Returns the accuracy of this perceptron
  def accuracy
    @mistakes / (@tests)
  end

  def self.all_flavors
    Perceptron.instance_methods(false) - [ :learning_rate, :weights, :averaged_weights, :mistakes, :tests, :test_for, :reset, :accuracy ]
  end

  def self.single_hyper_param_flavors
    all_flavors - [ :margin_perceptron ]
  end

  ## Other methods

  ## Resets the perceptron instance so we get a new setup for each run
  def reset
    @weights.each { |i| @weights[i] = 0.0 }
    @weights[0] = 1.0

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
    [ @weights.size, example.size ].min.times { |i| product += @weights[i] * example.features[i] }
    product
  end

  def weight_product_averaged(example)
    setup_weights(example)
    raise RuntimeError, 'Size of weights should be greater than example' if example.size > @averaged_weights.size
    product = 0.0
    [ @averaged_weights.size, example.size ].min.times { |i| product += @averaged_weights[i] * example.features[i] }
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