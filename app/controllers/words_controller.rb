class WordsController < ApplicationController
  def new
  end

  def create
    vocabulary = Vocabulary.find[params[:vocabulary_id]]
    word = vocabulary.words.new(word_params)
    word.save!
    redirect_to new_word_path
  end

  private

  def word_params
    params.require(:word).permit(:word, :meaning, :sentence, :sentence_meaning)
  end

end
