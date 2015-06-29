class VocabulariesController < ApplicationController
  def new
    @folder_id = params[:folder_id]
  end

  def create
    folder = Folder.find(params[:vocabulary][:folder_id])
    vocabulary = folder.vocabularies.new(vocabulary_params)
    vocabulary.save!
    redirect_to folder_path(folder)
  end

  def show
    @vocabulary = Vocabulary.find(params[:id])
    folder = Folder.find(@vocabulary.folder_id)
    if folder.user_id == current_user.id 
      @words = @vocabulary.words.order(:created_at)

      @words.each do |word|
        if word.remaining_dates > Time.now
          word.state = '#50B551'
        else
          word.state = '#E76166'
        end
      end
    else
      redirect_to root_url
    end
  end

  private

  def vocabulary_params
    params.require(:vocabulary).permit(:name)
  end
end
