class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :books, through: :user_books
  has_many :user_books

  # scope :add_user_books, (book_id)-> { User.all.each { |user| user.user_books.create() } }

  def books_unread
  	unread_books = []#temporary array for all unread books
    self.user_books.where('times_read = ?', 0).order(:id).each do |user_book|
      unread_books << user_book.book
    end
    unread_books
  end

  def books_read
    read_books = []
    self.user_books.where('times_read > ?', 0).order(:id).each do |user_book|
      read_books << user_book.book
    end
    read_books
  end

  def priority_list
    priority_books = []
    self.user_books.where.not(priority: nil).order(priority: :asc).each do |user_book|
      priority_books << user_book.book
    end
    priority_books
  end
end
