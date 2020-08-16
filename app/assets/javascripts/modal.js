$(function() {
  $('#remind-modal-btn').click(function() {
    $('#modal-background-remind').fadeIn();
  });

  $('#unpaid-modal-btn').click(function() {
    $('#modal-background-unpaid').fadeIn();
  });
  $('#paid-modal-btn-1').click(function() {
    $('#modal-background-paid').fadeIn();
  });
  $('#paid-modal-btn-2').click(function() {
    $('#modal-background-paid').fadeIn();
  });
  $('#invite-modal-btn').click(function() {
    $('#modal-background-invite').fadeIn();
  });

  $('.close-modal').click(function() {
    $('#modal-background-remind').fadeOut();
    $('#modal-background-unpaid').fadeOut();
    $('#modal-background-paid').fadeOut();
    $('#modal-background-invite').fadeOut();
  });
});
