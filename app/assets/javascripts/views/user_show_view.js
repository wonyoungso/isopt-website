WY.views.user_show_view = (function(){
  var user_id, 
      press_time = 0,
      interval_id;

  function user_show_view(params){
    user_id = params.user_id;

    $(".moment_btn").on("mousedown touchstart", function(e){
      interval_id = setInterval(function(){
        press_time++;
      }, 1);
    });

    $(window).on("mouseup touchend", function(e){
      console.log(press_time);
      clearInterval(interval_id);

      if (press_time > 0) {
        send_press_time();
        press_time = 0;
      }
    });
  }



  function send_press_time(){
    $.ajax({
      type: 'POST',
      url: '/api/users/' + user_id + "/minute_records.json",
      data: {milliseconds: press_time},
      success: function(data){
        if (data.success) {
          window.location.reload();
        } else {
          alert(data.message);
        }
      }
    })
  }

  return user_show_view;
})();
