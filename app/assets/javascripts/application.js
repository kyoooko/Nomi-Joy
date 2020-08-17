// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap
//= require_tree .


// ホバーでヒントを表示するツールチップ(admin/events/index/101号室などのタグ)
$(function () {
  $('[data-toggle="tooltip"]').tooltip();
})
// =================================================================
// アップロードした画像を即時プレビューする(public/user/editページ)
$(function(){
  // （Crome検証で）inputのidから情報の取得
  $('#user_image').on('change', function (e) {
  // 既存の画像のurlの取得
  var reader = new FileReader();
  reader.onload = function (e) {
      $(".preview-image").attr('src', e.target.result);
  }
  //取得したurlにアップロード画像のurlを挿入
  reader.readAsDataURL(e.target.files[0]); 

  // 通常の表示はS3で行い、アップロード時のみ非同期で即時プレビューするため
  $('.preview-image').removeClass('d-none');
  $('.s3').remove();
  });
});