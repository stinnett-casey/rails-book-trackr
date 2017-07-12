$(document).ready ->
  $('#overlay').fadeOut()

$(document).on 'turbolinks:load', ->
  return unless $('.users').length > 0
  ##########Draggable##########
  $('.collection-item:not(.not-draggable)').draggable
    snap: '.droppable'
    start: ->
      window.prevCategory = $(this).parents('li') #Store where it was to return on revert
      $count = $(this).closest('li.active').find('.collapsible-header').find('.count.badge')
      $count.text(parseInt($count.text()) - 1) #decrement # of books in that category on left
      window.prevLocation = saveLocation($(this)) #save prevlocation for restoring on revert
    revert: (accepted)->
      $count = $(this).closest('li.active').find('.collapsible-header').find('.count.badge')
      $count.text(parseInt($count.text()) + 1)
      restoreLocation(window.prevLocation) if !accepted
    connectToSortable: '.prioritize-droppable'
  ##########End Draggable##########

  ##########Droppable##########
  $('.readr-trackr-droppable, .prioritize-droppable').droppable
    accept: '.collection-item'
    drop: (event, ui)->
      if $(this).find('.no-books').length > 0 #remove placeholder when no books present
        $(this).find('.no-books').remove()

      if $(this).hasClass('prioritize-droppable') #no categories for prioritizing
        $(this).append(ui.draggable)
        ui.draggable.removeAttr('style') # reset styling (top and left got set en route)

        $.ajax 
          type: 'PUT'
          url: '/user_books/' + ui.draggable.data('user-book-id')
          data: {user_book: {priority: 1}}
          success: (result)->
            console.log result
          dataType: 'json'
      else        
        # look for the header that opens the accordian, if not there, add it
        if $(this).find('ul[data-category="' + ui.draggable.data('category') + '"]').length == 0
          $(this).append """
            <li>
              <div class="collapsible-header">
                #{ui.draggable.data('category')}
                <span class="count badge" data-badge-caption="Read">0</span>
              </div>
              <div class="collapsible-body">
                <ul class="collection overflow-visible" data-category="#{ui.draggable.data('category')}">
                </ul>
              </div>
            </li> 
          """
        # assuming the header's present, add the book li to it
        $(this).find('ul[data-category="' + ui.draggable.data('category') + '"]').append(ui.draggable)

        ui.draggable.removeAttr('style') # reset styling (top and left got set en route)
        # open the accordian header, which incidentally closes the others
        ui.draggable.closest('.collapsible-body').prev('.collapsible-header:not(.active)').click()
        # since it is just dropped, it has been read one time
        ui.draggable.append """
          <span class="times-read badge" data-badge-caption="Time">
            1
          </span>
        """
        
        # set the user_book's times_read to 1
        $.ajax 
          type: 'POST'
          url: '/user_books'
          data: {user_book: {book_id: ui.draggable.data('id'), times_read: 1}}
          success: (result)->
            user_book = result.user_book
            #if there are no more books in that category on the left,
            #then remove that category
            if $(window.prevCategory).children('.collapsible-body').find('li').length < 1
              $(window.prevCategory).remove() 
          dataType: 'json'
  ##########End Droppable##########

  ##########Pushpin##########
  removePushPin = ($elem)->
      $elem.pushpin 'remove' # remove the pushpin
      $elem.pushpin 'remove' # reset the pushpin
  addPushPin = ($elem)->
      $elem.pushpin
        top: $elem.offset().top + $elem.height()
  addPushPin($('.user-books'))
  ##########End Pushpin##########

  ##########Expand/Collapse##########
  $('.expand').click (e)->
    e.preventDefault()
    $link = $(this)
    $user_books_ul = $link.closest('.user-books')
    if $link.text().indexOf('Expand') > -1
      $link.closest('.collapsible').children('li').each ->
        toggleAll $(this), true
      $link.text('Collapse All')
      # no pushpin when .user-books is expanded
      if $user_books_ul.length > 0
        $user_books_ul.data('expanded', true)
        removePushPin($('.user-books')) 
      else if $user_books_ul.length == 0 && $user_books_ul.data('expanded') == false
        addPushPin($('.user-books'))
    else
      $user_books_ul.data('expanded', false) if $user_books_ul.length > 0
      $link.closest('.collapsible').children('li').each ->
        toggleAll $(this), false
      $link.text('Expand All')
      addPushPin($('.user-books'))
  ##########End Expand/Collapse##########

  ##########Sortable##########
  $('.prioritize-droppable').sortable
    items: 'li:not(.collection-header, .no-books)',
    change: (e,ui)->
      counter = 0
      $(this).find('.collection-item').not('.ui-sortable-placeholder').each ->
        console.log $(this), ++counter
  ##########End Sortable##########

  ##########Tabs##########
  $('ul.tabs').tabs()
  ##########End Tabs##########

  ##########Favorite##########
  $(document).on 'click', '.favorite:not(.processing)', ->
    $(this).addClass('processing')
    $book_li = $(this).parents('li[data-user-book-id]')
    $parent = $(this).parent()
    $parent.append """
      <div class="progress favorite-load">
        <div class="indeterminate"></div>
      </div>
    """
    #sends opposite of what it was
    added_to_favorites = ($book_li.attr('data-favorite') == 'false')
    $.ajax
      type: 'PATCH'
      context: $(this)
      url: '/user_books/' + $book_li.attr('data-user-book-id')
      data: {user_book: { favorite: added_to_favorites }} 
      success: (result)->
        user_book = result.user_book
        if user_book.favorite #if favorited
          $('[data-user-book-id="' + user_book.id + '"]').updateBooks('star', 'Remove From Favorites', true)
          #show toast
          Materialize.toast('Added To Favorites', 3000)
        else
          $('[data-user-book-id="' + user_book.id + '"]').updateBooks('star_border', 'Add To Favorites', false)
          #show toast
          Materialize.toast('Removed From Favorites', 3000)
        $(this).removeClass('processing')
        $parent.find('.favorite-load').remove()
        $('.tooltipped').tooltip()
      dataType: 'json'

  $.fn.updateBooks = (icon_text, tooltip_text, favorited)->
    $(this).each ->
      $star = $(this).find('.favorite')
      #change star
      $star.text(icon_text)
      #change tooltip text
      $star.attr('data-tooltip', tooltip_text)
      #change data-favorite
      $(this).attr('data-favorite', favorited)

  ##########End Favorite##########

  ##########Add Book Ownership##########
  $('.own-it').click (e)->
    e.stopPropagation()
    $(this).find('.ajax-wait').removeClass 'hidden' #show loader
    if $(this).hasClass('nice-black') #they do not own it
      change_to_owned = true
    else #they do own it
      change_to_owned = false

    $.ajax
      type: 'PATCH'
      context: $(this)
      url: '/user_books/' + $(this).parents('li[data-user-book-id]').data('user-book-id')
      data: {user_book: { own_it: change_to_owned } }
      success: (result)->
        console.log(result)
        new_html = """
          <div class="dropdown-icon">
            <i class="material-icons">check_circle</i>
            <div class="preloader-wrapper x-small active ajax-wait hidden">
              <div class="spinner-layer spinner-blue">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div>
                <div class="gap-patch">
                  <div class="circle"></div>
                </div>
                <div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>
              <div class="spinner-layer spinner-red">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div>
                <div class="gap-patch">
                  <div class="circle"></div>
                </div>
                <div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>
              <div class="spinner-layer spinner-yellow">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div>
                <div class="gap-patch">
                  <div class="circle"></div>
                </div>
                <div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>
              <div class="spinner-layer spinner-green">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div>
                <div class="gap-patch">
                  <div class="circle"></div>
                </div>
                <div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>
            </div>
          </div>
        """
        selector_id = $(this).parents('.book').attr('data-user-book-id')
        if change_to_owned
          $('[data-user-book-id=' + selector_id + ']').change_ownership ->
            $(this).removeClass('nice-black').addClass('nice-teal')
            $(this).html 'Owned' + new_html
            $(this).parents('.book').attr('data-own-it', true)
        else
          $('[data-user-book-id=' + selector_id + ']').change_ownership ->
            $(this).removeClass('nice-teal').addClass('nice-black')
            $(this).html 'Not Owned' + new_html
            $(this).parents('.book').attr('data-own-it', false)
      error: (e)->
        console.log(e)
      dataType: 'json'

  $.fn.change_ownership = (update_function)->
    $(this).each ->
      update_function.call($(this).find('.own-it'))
  ##########End Ownership##########

  ##########DropDowns##########
  $('.dropdown-button').dropdown
        constrainWidth: false
        belowOrigin: true
  ##########End DropDowns##########

  ##########HideSeek##########
    # $('#search').hideseek
    #   highlight: true

  $.fn.search_books = ->
    $(this).each -> # loop through each input this was called on
      $(this).keyup -> # add keyup listener to the input
        $input = $(this)
        search_str = $input.val()

        if search_str == 'favorites'
          show_favorites()
          return

        # get the list to run this on
        $list = $($(this).data('list')).children('.collection-item')
        $list.each ->
          $book_li = $(this)
          $book_title = $book_li.find('.title') #get title
          title_text = $book_title.data('original-text')

          $book_label = $book_li.find('.category-label')# get label
          label_text = $book_label.data('original-text') #get text

          occurances_in_label = getIndicesOf(search_str, label_text)
          occurances_in_title = getIndicesOf(search_str, title_text)

          if occurances_in_label.length == 0 && occurances_in_title.length == 0 && search_str.length > 0
            $book_li.hide()
          else
            $book_li.show()
            $book_label.addHighlights(occurances_in_label, label_text, search_str)
            $book_title.addHighlights(occurances_in_title, title_text, search_str)
            


    $.fn.addHighlights = (indices_array, original_text, search_str)->
      new_label_text = ''
      start_pos = 0
      for index, i in indices_array
        new_label_text += original_text.substring(start_pos, index)
        new_label_text += addSpans(index, search_str, original_text)
        start_pos = index + search_str.length
      new_label_text += original_text.substring(start_pos)
      $(this).html(new_label_text)

    getIndicesOf = (searchStr, str, caseSensitive = false)->
        searchStrLen = searchStr.length
        if (searchStrLen == 0)
          return []
        startIndex = 0
        index
        indices = []
        if (!caseSensitive)
            str = str.toLowerCase()
            searchStr = searchStr.toLowerCase()
        while ((index = str.indexOf(searchStr, startIndex)) > -1)
            indices.push(index)
            startIndex = index + searchStrLen
        return indices

    addSpans = (index, search_str, label_text)->
      '<span class="highlight">' + label_text.substr(index, search_str.length) + '</span>'

  show_favorites = ->
    $('.searchable .collection-item').each ->
      $('#search').val('favorites')
      if $(this).find('.favorite').text().trim() == 'star_border' 
        $(this).hide() 
      else 
        $(this).show()

  show_owned = ->
    $('.searchable .collection-item').each ->
      $('#search').val('owned')
      if $(this).attr('data-own-it') == 'true'
        $(this).show() 
      else 
        $(this).hide()    

  $('#search').search_books()
  $('.show-favorites').click(show_favorites)
  $('.show-owned').click(show_owned)
  ##########End Search##########

  toggleAll = ($this, activate)->
    if activate
      $this.addClass 'active'
      $this.find('.collapsible-header').addClass 'active'
      $this.find('.collapsible-body').attr('style', 'display: block;')
    else
      $this.removeClass 'active'
      $this.find('.collapsible-header').removeClass 'active'
      $this.find('.collapsible-body').attr('style', 'display: none;')

  saveLocation = (element)->
    loc = {}

    item = $(element).prev()
    loc.element = element
    if (item.length) 
        loc.prev = item[0];
    else 
        loc.parent = $(element).parent()[0];
    return(loc)

  restoreLocation = (loc)->
    if (loc.parent)
        $(loc.parent).prepend(loc.element)
    else
        $(loc.prev).after(loc.element)




    # Highlight partial match.
    highlight = (string, $el)-> 
      img = $el.find('img')
      matchStart = $el.text().toLowerCase().indexOf("" + string.toLowerCase() + "")
      matchEnd = matchStart + string.length - 1
      beforeMatch = $el.text().slice(0, matchStart)
      matchText = $el.text().slice(matchStart, matchEnd + 1)
      afterMatch = $el.text().slice(matchEnd + 1)
      $el.html("<span>" + beforeMatch + "<span class='highlight'>" + matchText + "</span>" + afterMatch + "</span>")
      if (img.length)
        $el.prepend(img)