require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = (0...8).map { (65 + rand(26)).chr }
  end

  def score
    session[:score] ||= 0
    @word = params[:word]
    @letters = params[:letters]
    if is_ok(@word)
        if english_word?(@word)
        @result = "Congratulation ! #{@word} is a valid English word!"
        @score = @word.length
        session[:score]+= @score
      else
        @result = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{@word} can't be built out of #{@letters}"
    end
  end

  def is_ok(word)
    letters = @letters.gsub(/\W/,'').downcase.split("")
    word.split("").all? do |letter|
      letters.include?(letter)
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json["found"]
  end
end
