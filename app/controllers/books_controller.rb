class BooksController < ApplicationController
  before_action :set_book, only: [:create, :show, :edit, :update, :destroy]

  def index
  end

  def new
    @book = Book.new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
end
