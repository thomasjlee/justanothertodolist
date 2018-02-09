$(document).on('turbolinks:load', function() {
  $('.todo-buttons').hover(function() {
    $(this).find(`.edit-btn`).fadeToggle(200);
    $(this).find(`.delete-btn`).fadeToggle(200);
  });

  $('.todo-wrapper').on('click', '.edit-btn', function() {
    var todoItem = $(this).closest('.todo-wrapper');

    todoItem.find('.todo-text').toggle();
    todoItem.find('.edit-todo-form').toggle();

    focusEditForm(todoItem);
  });
});

function focusEditForm(todoItem) {
  var textArea = todoItem.find("textarea[name='todo_item[name]']");

  var currentVal = textArea.val();
  textArea.focus().val('').val(currentVal);
}
