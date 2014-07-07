$(document).on 'ready page:load', ->
  $('.reminder').click ->
    $(this).children(".description").collapse('toggle')