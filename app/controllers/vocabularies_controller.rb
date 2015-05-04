class VocabulariesController < ApplicationController
  def index
    @vocabularies = Vocabulary.all
    @remaining_word_count = Word.where('remaining_dates < ?', Time.now).size
    render 'index'
  end

  def new
  end

  def create
    vocabulary = Vocabulary.new(vocabulary_params)
    vocabulary.save!
    
    redirect_to vocabulary_path(vocabulary)
  end

  def show
    @vocabulary = Vocabulary.find(params[:id])
    @words = @vocabulary.words.order(:created_at)

    @words.each do |word|
      if word.remaining_dates > Time.now
        word.state = '#50B551'
      else
        word.state = '#E76166'
      end
    end
    
  end

  private

  def vocabulary_params
    params.require(:vocabulary).permit(:title)
  end

  
end
