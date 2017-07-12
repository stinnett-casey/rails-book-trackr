                  Prefix Verb   URI Pattern                    Controller#Action
        new_user_session GET    /users/sign_in(.:format)       users/sessions#new
            user_session POST   /users/sign_in(.:format)       users/sessions#create
    destroy_user_session DELETE /users/sign_out(.:format)      users/sessions#destroy
       new_user_password GET    /users/password/new(.:format)  devise/passwords#new
      edit_user_password GET    /users/password/edit(.:format) devise/passwords#edit
           user_password PATCH  /users/password(.:format)      devise/passwords#update
                         PUT    /users/password(.:format)      devise/passwords#update
                         POST   /users/password(.:format)      devise/passwords#create
cancel_user_registration GET    /users/cancel(.:format)        users/registrations#cancel
   new_user_registration GET    /users/sign_up(.:format)       users/registrations#new
  edit_user_registration GET    /users/edit(.:format)          users/registrations#edit
       user_registration PATCH  /users(.:format)               users/registrations#update
                         PUT    /users(.:format)               users/registrations#update
                         DELETE /users(.:format)               users/registrations#destroy
                         POST   /users(.:format)               users/registrations#create
             user_exists POST   /user_exists(.:format)         users#user_exists
                   users GET    /users(.:format)               users#index
                         POST   /users(.:format)               users#create
                new_user GET    /users/new(.:format)           users#new
               edit_user GET    /users/:id/edit(.:format)      users#edit
                    user GET    /users/:id(.:format)           users#show
                         PATCH  /users/:id(.:format)           users#update
                         PUT    /users/:id(.:format)           users#update
                         DELETE /users/:id(.:format)           users#destroy
              user_books GET    /user_books(.:format)          user_books#index
                         POST   /user_books(.:format)          user_books#create
           new_user_book GET    /user_books/new(.:format)      user_books#new
          edit_user_book GET    /user_books/:id/edit(.:format) user_books#edit
               user_book GET    /user_books/:id(.:format)      user_books#show
                         PATCH  /user_books/:id(.:format)      user_books#update
                         PUT    /user_books/:id(.:format)      user_books#update
                         DELETE /user_books/:id(.:format)      user_books#destroy
                   books GET    /books(.:format)               books#index
                         POST   /books(.:format)               books#create
                new_book GET    /books/new(.:format)           books#new
               edit_book GET    /books/:id/edit(.:format)      books#edit
                    book GET    /books/:id(.:format)           books#show
                         PATCH  /books/:id(.:format)           books#update
                         PUT    /books/:id(.:format)           books#update
                         DELETE /books/:id(.:format)           books#destroy
                    root GET    /                              home#index
