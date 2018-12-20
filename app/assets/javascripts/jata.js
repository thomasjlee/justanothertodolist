document.addEventListener('turbolinks:load', function() {
  window.jata = {
    clearCompletedButton:
      document.querySelector('form[action$="clear_completed"] input[type=submit]'),
    enableClearCompletedButton  : enableClearCompletedButton,
    disableClearCompletedButton : disableClearCompletedButton,
    displayTodoTexts            : displayTodoTexts,
    removeEditForms             : removeEditForms,
    setViewState                : setViewState
  }

  function enableClearCompletedButton() {
    jata.clearCompletedButton.removeAttribute('disabled');
    jata.clearCompletedButton.classList.add('clickable', 'text-info', 'border-info');
    jata.clearCompletedButton.classList.remove('text-secondary', 'border-secondary');
  }

  function disableClearCompletedButton() {
    jata.clearCompletedButton.setAttribute('disabled', true);
    jata.clearCompletedButton.classList.add('text-secondary', 'border-secondary');
    jata.clearCompletedButton.classList.remove('clickable', 'text-info', 'border-info');
  }

  function displayTodoTexts() {
    var todoTexts = document.querySelectorAll('.todo-text');
    for (let todoText of todoTexts) {
      todoText.style.display = 'block';
    }
  }

  function removeEditForms() {
    for (let editForm of document.getElementsByClassName('edit-form')) {
      editForm.remove();
    }
  }

  function setViewState() {
    jata.displayTodoTexts();
    jata.removeEditForms();
  }
});

