# name.rb
# A name from the test data

class Name

  @@ACCEPTABLE_LABELS = [:+, :-]
  @@VOWELS = %w(a e i o u)

  attr_reader :label

  def initialize(full_name, label)
    raise RuntimeError, "#{label} is not an acceptable label!" unless label.is_a?(Symbol) && @@ACCEPTABLE_LABELS.include?(label)

    @full_name = full_name.downcase # We are storing these in lower case letters
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

  ## class method checking to see if the provided label is acceptable
  def self.acceptable_label?(label)
    @@ACCEPTABLE_LABELS.include?(label)
  end

  private

  def first_name
    @full_name.split(' ')[0]
  end

  def last_name
    @full_name.split(' ')[@full_name.split.length - 1]
  end
end