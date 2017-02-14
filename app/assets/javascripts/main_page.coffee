# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.category-title').on 'click', (e) ->
    $('.category-title.active').removeClass('active')
    $(e.target.closest('.category-title')).addClass('active')
