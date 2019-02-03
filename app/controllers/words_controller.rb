class WordsController < ApplicationController
  #Word.update_all('remaining_dates = remaining_dates -1')
  skip_before_filter :verify_authenticity_token
  
  def self.day
    [0, 1, 2, 4, 8, 16, 32, 64]
  end

  def index
    count = 50
    if !params[:count].nil?
      count = params[:count]
    end
    if !params[:vocabulary_id].nil?
      vocabulary = Vocabulary.find(params[:vocabulary_id])
      @words = vocabulary.words.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(count)
    elsif !params[:folder_id].nil?
      folder = Folder.find(params[:folder_id])
      @words = folder.words.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(count)
    else 
      @words = current_user.words.where('remaining_dates < ?', Time.now).order("RANDOM()").limit(count)
    end
  end

  def get_word_to_other_server(word)
    require 'net/http'
    url = 'http://stompesi-word-sentence.herokuapp.com/words/get_word_from_other_information?word=' + word
    str = URI.escape(url) 
    uri = URI.parse(str)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def set_word_to_other_server(input_word)
    require 'uri'
    require 'net/http'
    require 'net/https'

    uri = URI.parse('http://stompesi-word-sentence.herokuapp.com/words/set_word_to_other_server')
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})

    word = {}
    word[:word] = input_word.word
    word[:meaning] = input_word.meaning
    word[:sentence] = input_word.sentence
    word[:sentence_meaning] = input_word.sentence_meaning

    req.body = {word: word}.to_json
    res = https.request(req)
  end

  def set_word_from_other_server
    word_informations = Word.where(word: params[:word][:word])
    
    word_informations.each do |word|
      word.meaning = params[:word][:meaning]
      word.sentence = params[:word][:sentence]
      word.sentence_meaning = params[:word][:sentence_meaning]
      word.save!
    end
    render json: {status: 200}
  end

  def get_word_from_other_information
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

    update_word = Word.find(params[:id])
    set_word_to_other_server(update_word)

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

    word = Word.find_by_word(params[:word][:word])
    set_word_to_other_server(word)

    redirect_to new_word_path(vocabulary_id: vocabulary.id)
  end

  def input_word 
    word = Word.find_by_word(params[:word])
    if word.nil? 
      result = get_word_to_other_server(params[:word])

      unless result.length == 0
        render json: {isHaveWord: true, meaning: result[0]['meaning']}
      else
        render json: {isHaveWord: false}
      end
    else
      render json: {isHaveWord: true, meaning: word.meaning}
    end
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
