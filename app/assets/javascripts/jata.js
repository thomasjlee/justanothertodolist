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
    jata.clearCompletedButton.classList.add('clear-completed-btn--enabled');
    jata.clearCompletedButton.classList.remove('clear-completed-btn--disabled');
  }

  function disableClearCompletedButton() {
    jata.clearCompletedButton.setAttribute('disabled', true);
    jata.clearCompletedButton.classList.add('clear-completed-btn--disabled');
    jata.clearCompletedButton.classList.remove('clear-completed-btn--enabled');
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

