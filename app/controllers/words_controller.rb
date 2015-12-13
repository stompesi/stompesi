class WordsController < ApplicationController
  #Word.update_all('remaining_dates = remaining_dates -1')
  skip_before_filter :verify_authenticity_token
  
  def self.day
    [0, 1, 2, 4, 8, 16, 32, 64]
  end

  def index
    if !params[:vocabulary_id].nil?
      vocabulary = Vocabulary.find(params[:vocabulary_id])
      @words = vocabulary.words.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(50)
    elsif !params[:folder_id].nil?
      folder = Folder.find(params[:folder_id])
      @words = folder.words.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(50)
    else 
      @words = current_user.words.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(50)
    end
  end

  def get_word_information
    word_information = Word.where(word: params[:word])
    render json: word_information
  end

  def memorize_all
    vocabulary = Vocabulary.find(params[:vocabulary_id])
    @words = vocabulary.words.order(:created_at)
    render 'memorize'
  end

  def memorize
    vocabulary = Vocabulary.find(params[:vocabulary_id])
    @words = vocabulary.words.where('remaining_dates < ?', Time.now).order(:created_at)
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
    update_word = Word.find(params[:id])

    word_informations = Word.where(word: update_word.word)

    word_informations.each do |word|
      word.update(word_params)
    end

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

  def update_overlap
    word_informations = Word.where(word: params[:word][:word])
    
    word_informations.each do |word|
      word.meaning = params[:word][:meaning]
      word.sentence = params[:word][:sentence]
      word.sentence_meaning = params[:word][:sentence_meaning]
      word.save!
    end

    if params[:word][:is_outside].nil?
      word = Word.find_by_word(params[:word][:word])
      set_stompesi_word(word)
      redirect_to overlap_words_path
    else 
      render json: {status: 200}
    end
  end

  def input_word 
    word = Word.find_by_word(params[:word])

    if word.nil? 
      render json: {isHaveWord: false}
    else
      render json: {isHaveWord: true, meaning: word.meaning}
    end
  end
  
  def create
    word = Word.find_by_word(params[:word][:word])
    vocabulary = Vocabulary.find(params[:word][:vocabulary_id])
    unless word.nil? 
      word_informations = Word.where(word: params[:word][:word])

      word_informations.each do |word|
        word.update(word_params)
      end
    end

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
