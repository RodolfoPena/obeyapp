$(document).on('turbolinks:load', function() {
  $("[data-form-prepend]").click(function(e) {
    var obj = $($(this).attr("data-form-prepend"));
    obj.find("input").each(function() {
      $(this).attr("name", function() {
        debugger
        return $(this)
          .attr("name")
          .replace("new_record", new Date().getTime());
      });
    });
    obj.insertBefore(this);
    return false;
  });
});
