class WordsController < ApplicationController
  #Word.update_all('remaining_dates = remaining_dates -1')
  def self.day
    [0, 1, 2, 4, 8, 30, 60, 120]
  end

  def index
    @words = Word.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(50)
  end

  def new
    @vocabulary_id = params[:vocabulary_id]
  end

  def show
    @word = Word.find(params[:id])
    @vocabulary_id = Vocabulary.find(params[:format]).id
  end

  def update
    vocabulary = Vocabulary.find(params[:word][:vocabulary_id])
    word = Word.find(params[:id])
    word.update(word_params)

    redirect_to vocabulary_path(vocabulary)
  end

  def mutipule_update
    params[:word_lst].each do |object|
      word = Word.find(object[1]['id'])
      word.stage = object[1]['stage']
      word.remaining_dates = word.remaining_dates + WordsController.day[word.stage].days
      word.save!
    end

    render json: {success: true}
  end

  def create
    vocabulary = Vocabulary.find(params[:word][:vocabulary_id])
    word = vocabulary.words.new(word_params)
    word.remaining_dates = Time.now
    word.save!
    redirect_to vocabulary_path(vocabulary)
  end

  def destroy
    word = Word.find(params[:id])
    word.destroy

    redirect_to :back
  end

  private

  def word_params
    params.require(:word).permit(:word, :meaning, :sentence, :sentence_meaning)
  end
end
