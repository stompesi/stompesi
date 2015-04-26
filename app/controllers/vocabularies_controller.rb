class VocabulariesController < ApplicationController
  def index
    @vocabularies = Vocabulary.all
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
  end

  private

  def vocabulary_params
    params.require(:vocabulary).permit(:title)
  end

  
end
