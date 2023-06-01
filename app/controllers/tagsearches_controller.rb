class TagsearchesController < ApplicationController
  
  def tagsearch
    @word = params[:word]
    @books = Book.where("category LIKE?", "%#{@word}%")
  end
  
end
