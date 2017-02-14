$(function() {
  if (!localStorage.getItem('intro_showed')) {
    $('#intro-window').modal('show');
    localStorage.setItem('intro_showed', 'true');
  }

  $('#intro-window').on('hidden.bs.modal', function () {
    $('#intro-window iframe').attr('src', $('#intro-window iframe').attr('src'));
  });
});
