//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.disclosure

$(document).on('page:change', function () {
  $('[data-disclosure]').disclosure()
})
