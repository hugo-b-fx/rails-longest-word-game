require "open-uri"
require "json"

class GamesController < ApplicationController
  def score
    @word = params[:word].upcase
    @letters = params[:letters].chars

    if !word_in_grid?(@word, @letters)
      @result = "The word can't be built from the given letters."
    elsif !english_word?(@word)
      @result = "The word is valid according to the grid, but not an English word."
    else
      @result = "Congratulations! #{@word} is a valid English word!"
    end
  end

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  private

  def word_in_grid?(word, grid)
    word.chars.all? do |letter|
      word.count(letter) <= grid.count(letter)
    end
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"]
  end
end
