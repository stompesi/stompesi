class WordsController < ApplicationController
  #Word.update_all('remaining_dates = remaining_dates -1')
  def self.day
    [0, 1, 2, 4, 8, 30, 60, 120]
  end

  def index
    if !params[:vocabulary_id].nil?
      vocabulary = Vocabulary.find(params[:vocabulary_id])
      @words = vocabulary.words.where('remaining_dates < ?', Time.now).order("RANDOM()")
    elsif !params[:folder_id].nil?
      folder = Folder.find(params[:folder_id])
      @words = folder.words.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(50)
    else 
      @words = current_user.words.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(50)
    end
    
  end

  def new
    @vocabulary_id = params[:vocabulary_id]
  end

  def show
    @word = current_user.words.find(params[:id])
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
      word.remaining_dates = Time.now + WordsController.day[word.stage].days
      word.save!
    end

    render json: {success: true}
  end

  def create
    vocabulary = Vocabulary.find(params[:word][:vocabulary_id])
    word = vocabulary.words.new(word_params)
    word.remaining_dates = Time.now
    word.save!
    redirect_to new_word_path(vocabulary_id: vocabulary.id)
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
