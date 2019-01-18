$(document).on('turbolinks:load', function() {
  $('body').delegate("input[name='commitment[tasks]']", 'change', function(event) {
    $.ajax({
      url: '/tasks/' + $(this).val() + '/done.js',
      type: 'patch',
      data: { task_id: $(this).val()}
    })
    .done(function() {
      console.log("success");
    })
    .fail(function() {
      console.log("error");
    })
    .always(function() {
      console.log("complete");
    });

  });
})
