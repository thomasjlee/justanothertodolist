document.addEventListener('turbolinks:load', function() {
  window.jata = {
    clearCompletedButton:
      document.querySelector('form[action$="clear_completed"] input[type=submit]'),
    toggleClearCompletedButton : toggleClearCompletedButton,
    hideEditForms              : hideEditForms,
    displayTodoTexts           : displayTodoTexts,
    toggleViewState            : toggleViewState
  }

  function toggleClearCompletedButton() {
    if (document.querySelector('[data-clearable]')) {
      jata.clearCompletedButton.removeAttribute('disabled');
      jata.clearCompletedButton.classList.add('clickable', 'text-info', 'border-info');
      jata.clearCompletedButton.classList.remove('text-secondary', 'border-secondary');
    } else {
      jata.clearCompletedButton.setAttribute('disabled', true);
      jata.clearCompletedButton.classList.add('text-secondary', 'border-secondary');
      jata.clearCompletedButton.classList.remove('clickable', 'text-info', 'border-info');
    }
  }

  function displayTodoTexts() {
    var todoTexts = document.querySelectorAll('.todo-text');
    for (let todoText of todoTexts) {
      todoText.style.display = 'block';
    }
  }

  function hideEditForms() {
    var editForms = document.querySelectorAll('.edit-form');
    for (let editForm of editForms) {
      editForm.style.display = 'none';
    }
  }

  function toggleViewState() {
    jata.displayTodoTexts();
    jata.hideEditForms();
  }
});
