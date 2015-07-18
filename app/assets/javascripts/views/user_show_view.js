WY.views.user_show_view = (function(){
  var user_id, 
      press_time = 0,
      interval_id,
      moment_records,
      minutes;

  function user_show_view(params){
    user_id = params.user_id;
    moment_records = params.moment_records;
    minutes = params.minutes;

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

    init_graph();
  }

  function init_graph(){
    var pop_template = _.template('<div class="pop label"><%= start_time %> –<br><%= end_time %></div>');
    
    _.each(moment_records, function (mr) {
      var bar = $($(".graph .bar:not(.on):not(.start)")[Math.floor(mr.minute_idx)]);
      bar.addClass("on").width(Math.max(10 * mr.milliseconds / 10000, 10)).append($(pop_template(mr)));

      $(".graph .clear").remove();
      $(".graph").append($("<div />", {"class": "bar"}));
    });

      $(".graph").append($("<div />", {"class": "clear"}));
  }

  function send_press_time(){
    $.ajax({
      type: 'POST',
      url: '/api/users/' + user_id + "/moment_records.json",
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
