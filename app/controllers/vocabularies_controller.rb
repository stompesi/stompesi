class VocabulariesController < ApplicationController
  def index
    @vocabularies = current_user.vocabularies.all

    # 이것보다 더 좋은 방법이 있을듯 한데 아직은 잘모르겠다. 확인요망
      @remaining_word_count = 0
      @vocabularies.each do |vocabulary|
        @remaining_word_count += vocabulary.words.where('remaining_dates < ?', Time.now).size
      end
    ###
  
    render 'index'
  end

  def new
  end

  def create
    vocabulary = current_user.vocabularies.new(vocabulary_params)
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
