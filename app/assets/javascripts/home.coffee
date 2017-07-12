$(document).on 'turbolinks:load', ->
  return unless $('.registrations.new').length > 0
  $('#user_email').blur ->
    if $(this).val() != ''
      
      $.ajax 
        type: 'POST'
        url: '/user_exists'
        data: {email: $(this).val()}
        success: (result)->
          if result.unique
            console.log 'It\'s a unique email!'
          else
            console.log 'Not a unique email'
        dataType: 'json'
      