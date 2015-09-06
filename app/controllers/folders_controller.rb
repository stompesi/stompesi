class FoldersController < ApplicationController
  def index
    @folder = current_user.folders.find_by name: 'root'

    @folders = @folder.folders.all
    @vocabularies = @folder.vocabularies.all.order(:created_at)
    @remaining_word_count = 0
    @remaining_total_word_count = 0
    @folders.each do |folder|
      folder.remaining_number = get_remaining_word_number_from_folder(folder)
      @remaining_total_word_count += folder.remaining_number  
    end

    @vocabularies.each do |vocabulary|
      vocabulary.remaining_number = vocabulary.words.where('remaining_dates < ?', Time.now).size
      @remaining_word_count += vocabulary.remaining_number  
    end
    @remaining_total_word_count += @remaining_word_count
    @remaining_total_word_count = get_remaining_word_number_from_folder(@folder)

    render 'index'
  end

  def new
    @folder_id = params[:folder_id]
  end

  def create
    parent_folder = Folder.find(params[:folder][:folder_id])
    child_folder = parent_folder.folders.new(folder_params)
    child_folder.user_id = current_user.id 
    child_folder.save!
    redirect_to folder_path(parent_folder)
  end

  def show
    @folder = Folder.find(params[:id])

    @folders = @folder.folders.all
    @vocabularies = @folder.vocabularies.all.order(:created_at)
    @remaining_word_count = 0
    @remaining_total_word_count = 0

    @folders.each do |folder|
      folder.remaining_number = get_remaining_word_number_from_folder(folder)
      @remaining_total_word_count += folder.remaining_number  
    end

    @vocabularies.each do |vocabulary|
      vocabulary.remaining_number = vocabulary.words.where('remaining_dates < ?', Time.now).size
      @remaining_word_count += vocabulary.remaining_number  
    end
    @remaining_total_word_count += @remaining_word_count

    render 'index'
  end



  private

  def folder_params
    params.require(:folder).permit(:name)
  end

  def get_remaining_word_number_from_folder(root_folder)
    remaing_word_count = 0
    folders = root_folder.folders.all
    if folders.length == 0
      root_folder.vocabularies.each do |vocabulary|
        vocabulary.remaining_number = vocabulary.words.where('remaining_dates < ?', Time.now).size
        remaing_word_count += vocabulary.remaining_number  
      end
    else
      root_folder.vocabularies.each do |vocabulary|
        vocabulary.remaining_number = vocabulary.words.where('remaining_dates < ?', Time.now).size
        remaing_word_count += vocabulary.remaining_number  
      end

      folders.each do |folder|
        remaing_word_count += get_remaining_word_number_from_folder(folder)
      end
    end

    remaing_word_count
  end

end
