$(document).on('turbolinks:load', function() {
  $('.todo-buttons').on('mouseenter', function(event) {
    var id = $(this).attr('id');
    $(`.todo-buttons#${id} .edit-btn`).fadeToggle(100);
    $(`.todo-buttons#${id} .delete-btn`).fadeToggle(100).css('display', 'inline-block');
  });

  $('.todo-buttons').on('mouseleave', function() {
    var id = $(this).attr('id');
    $(`.todo-buttons#${id} .edit-btn`).fadeToggle(100);
    $(`.todo-buttons#${id} .delete-btn`).fadeToggle(100);
  });

  $('.edit-btn').on('click', function(event) {
    var id = $(this).closest('.todo-buttons').attr('id');
    $(`#${id}.todo-text`).toggle();
    $(`#${id}.edit-todo-form`).toggle();
  });
});
