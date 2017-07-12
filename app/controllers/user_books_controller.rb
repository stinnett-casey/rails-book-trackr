class UserBooksController < ApplicationController
  def index
  end

  def new

  end

  def create
    respond_to do |format|
      @user_book = current_user.user_books.where(book_id: params[:user_book][:book_id]).first
      @user_book.update_attributes(user_book_params)
      format.html { redirect_to user_path(current_user) }
      format.js
      format.json { render json: {user_book: @user_book} }
    end
  end

  def show
  end

  def edit
  end

  def update
    puts "HERE ARE THE PARAMS: #{params.inspect}"
    respond_to do |format|
      @user_book = UserBook.find(params[:id])
      if @user_book.update_attributes(user_book_params)
        format.js
        format.json { render json: {user_book: @user_book} }
      end
    end
  end

  def destroy
  end

  private

  def user_book_params
    params.require(:user_book).permit(:user_id, :book_id, :times_read, :has_read, :own_it, :favorite, :priority)
  end
end
