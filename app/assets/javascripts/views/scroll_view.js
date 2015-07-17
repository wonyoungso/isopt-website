WY.views.scroll_view = (function(){
  function scroll_view(params){
    $('.colon').blink({delay:500});
    $('.drawings').mouseover(function() {
      $(this).hide().delay( 800 ).fadeIn( 400 );;
    });

    //mouseover
    $('.on').click(function() {
      $('.pop').hide();
      $('.pop', this).fadeIn();
    });

    //prallax
    var s = skrollr.init();
  }

  return scroll_view;
})();
