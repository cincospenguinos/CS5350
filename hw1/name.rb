# name.rb
# A name from the test data

class Name

  @@ACCEPTABLE_LABELS = [:+, :-]
  @@VOWELS = %w(a e i o u)
  @@LETTERS = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  @@BINARY = [ true, false ]

  attr_reader :label

  def initialize(full_name, label)
    raise RuntimeError, "#{label} is not an acceptable label!" unless label.is_a?(Symbol) && @@ACCEPTABLE_LABELS.include?(label)

    @full_name = full_name.downcase # We are storing these in lower case letters
    @@LETTERS << first_name[0] unless @@LETTERS.include?(first_name[0])
    @@LETTERS << first_name[1] unless @@LETTERS.include?(first_name[1])
    @label = label
  end

  ## true if the first name is longer than the last name
  def longer_first_name
    first_name.length > last_name.length
  end

  ## true if this name has a middle name
  def has_middle_name
    @full_name.split(' ').length >= 3
  end

  ## true if the first name starts and ends with the same letter
  def first_name_same_first_and_last_letter
    first_name[0] == first_name[-1]
  end

  ## true if the first name comes before the last name alphabetically
  def first_name_before_last
    first_name < last_name
  end

  ## true if the second letter of the first name is a vowel
  def first_name_second_letter_vowel
    @@VOWELS.include?(first_name[1])
  end

  ## true if the length of the last name is even
  def last_name_length_even
    last_name.length % 2 == 0
  end

  #### Here's some features I came up with ####

  def letter_first_name_first_letter
    raise RuntimeError, "#{first_name[0]} is not a valid letter! #{@full_name}" unless @@LETTERS.include?(first_name[0])
    first_name[0]
  end

  def first_name_starts_with_vowel
    @@VOWELS.include?(first_name[0])
  end

  def letter_first_name_second_letter
    raise RuntimeError, "#{first_name[1]} is not a valid letter! #{@full_name}" unless @@LETTERS.include?(first_name[1])
    first_name[1]
  end

  def cmp_first_and_second_letters_of_first_name
    first_name[0] <=> first_name[1]
  end

  ## class method checking to see if the provided label is acceptable
  def self.acceptable_label?(label)
    @@ACCEPTABLE_LABELS.include?(label)
  end

  def self.possible_values(feature)
    if letter_features.include?(feature)
      @@LETTERS.clone.freeze
    elsif feature.to_s.start_with?('cmp')
      [-1, 0, 1].freeze
    else
      @@BINARY.clone.freeze
    end
  end

  def self.all_features
    Name.instance_methods(false) - [ :label ]
  end

  def self.letter_features
    (Name.instance_methods(false) - [ :label ]).find_all { |f| f.to_s.start_with?('letter')}
  end

  def self.acceptable_labels
    @@ACCEPTABLE_LABELS.freeze
  end

  private

  def first_name
    @full_name.split(' ')[0]
  end

  def middle_name
    split = @full_name.split(' ')
    split.size >= 3 ? @full_name[1] : nil
  end

  def last_name
    @full_name.split(' ')[@full_name.split.length - 1]
  end
end