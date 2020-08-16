// public/users/index/タブ１（ノミカイメンバー＝マッチング済）
$(function() {
  $('.acordion').click(function() {
    var $description = $(this).find('.block-hedding__description');
    if($description.hasClass('open')) { 
      $description.removeClass('open');
      $description.slideUp();
      $(this).find('.symbol').html('<i class="fas fa-caret-down"></i>');
    } else {
      $description.addClass('open'); 
      $description.slideDown();
      $(this).find('.symbol').html('<i class="fas fa-caret-up"></i>');
    }
  });
});
