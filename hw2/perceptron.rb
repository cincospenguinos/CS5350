# perceptron.rb

# Class that manages running the perceptron algorithm to find the ideal hyperplane
# separating a set of values
class Perceptron

  attr_reader :learning_rate
  attr_reader :weights

  def initialize(learning_rate)
    @learning_rate = learning_rate.to_f
    @weights = [1.0]
  end

  ## Perceptron algorithms

  def simple_perceptron(examples)
    perceptron(examples) do |example|
      [ @weights.size, example.size ].min.times do |i|
        @weights[i] += @learning_rate * example.label * example.features[i]
      end
    end
  end

  def dynamic_learning_perceptron
    perceptron do
      raise RuntimeError, 'Implement this!'
    end
  end

  def margin_perceptron
    perceptron do
      raise RuntimeError, 'Implement this!'
    end
  end

  def averaged_perceptron
    perceptron do
      raise RuntimeError, 'Implement this!'
    end
  end

  ## Other methods

  private

  # The perceptron algorithm that runs the show
  def perceptron(training_examples)
    training_examples.each do |example|
      # Initialization step
      while @weights.size < example.size do
        @weights << 0.0 
      end

      if is_mistake(example)
        yield example
      end
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
    example.label * weight_product(example) <= 0.0
  end
end