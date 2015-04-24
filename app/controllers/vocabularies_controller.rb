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
    redirect_to new_word_path(vocabulary_id: vocabulary.id)
  end

  def show
    vocabulary = Vocabulary.find(params[:id])
    @words = vocabulary.words
  end

  private

  def vocabulary_params
    params.require(:vocabulary).permit(:title)
  end

end
