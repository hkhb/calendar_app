// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import Rails from "@rails/ujs"
Rails.start();
// フラッシュメッセージ
$(function(){
    $('.flash').fadeOut(4000);  //４秒かけて消えていく
  });
  
  