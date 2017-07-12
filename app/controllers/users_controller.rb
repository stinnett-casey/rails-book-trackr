class UsersController < ApplicationController
  def index
  end

  def show
  	@user = current_user
  	@all_books = Book.order(:id)
    @all_user_books = @user.user_books

    @all_books_by_category = group_by_category @all_books
  	unread_books = get_unread_books(@all_user_books, @all_books)
  	@unread_by_category = group_by_category unread_books

  	user_books = get_read_books(@all_user_books, @all_books)
  	@user_books_by_category = group_by_category user_books

    @user_priority_list = get_priority_books(@all_user_books, @all_books)

    @all_books_minus_prioritized = group_by_category(remove_duplicates(@all_books, @user_priority_list))
  end

  def user_exists
    respond_to do |format|
      if User.exists?(email: params[:email])
        format.json { render json: {unique: false} }
      else
        format.json { render json: {unique: true} }
      end
    end
  end

  private 

  # returns a hash with keys that are the categories and 
  # each category's value is an array of books with that same category
  def group_by_category(books)
  	in_categories = {}
  	books.each do |book|
      #make empty array in hash for that key if category as key not present
  		if !in_categories.key? book.category.to_sym
  			in_categories[book.category.to_sym] = []
  		end
      #add book to category's array
  		in_categories[book.category.to_sym] << book
  	end
  	in_categories
  end

  # returns an array that has everything not common to the two arrays
  # ex: a = [1,2,3,4,5], b = [3,4,5,6,7], c = a - b = [1,2,6,7]
  def remove_duplicates(all_books, priority_list)
    array_without_dups = all_books - priority_list
    array_without_dups
  end

  # Since I am getting so many books, it is expensive to call out to the database 
  # 3 times for all the user's user_books with different conditions.
  # So the following three methods are for optimization (get each array once and then just read from them).

  def get_unread_books(user_books, books)
    array_of_books = []
    user_books.each do |user_book|
      if user_book.times_read == 0
        array_of_books << books.find { |b| b.id == user_book.book_id }
      end
    end
    array_of_books
  end

  def get_read_books(user_books, books)
    array_of_books = []
    user_books.each do |user_book|
      if user_book.times_read > 0
        array_of_books << books.find { |b| b.id == user_book.book_id }
      end
    end
    array_of_books
  end

  def get_priority_books(user_books, books)
    array_of_books = []
    user_books.each do |user_book|
      if !user_book.priority.nil? && user_book.priority > 0
        array_of_books << books.find { |b| b.id == user_book.book_id }
      end
    end
    array_of_books
  end
end