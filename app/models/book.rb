class Book < ApplicationRecord
	has_many :users, through: :user_books
	has_many :user_books



	scope :owned, -> { where(own_it: true) }
	scope :not_owned, -> { where(own_it: false) }

	def user_book(current_user)
		self.user_books.where(user_id: current_user.id).first
	end
end
