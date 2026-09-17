class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  MAX_WRONG_GUESSES = 7

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # Get a word from remote "random word" service
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord.txt')
    Net::HTTP.get(uri)
  end

  def guess(letter)
    raise ArgumentError, 'guess must be a single letter' unless letter.is_a?(String) && letter.match?(/\A[a-zA-Z]\z/)

    letter = letter.downcase
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    true
  end

  def word_with_guesses
    @word.chars.map { |c| @guesses.include?(c) ? c : '-' }.join
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length >= MAX_WRONG_GUESSES
    return :win if @word.chars.all? { |c| @guesses.include?(c) }

    :play
  end
end
