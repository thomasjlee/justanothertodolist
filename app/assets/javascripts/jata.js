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

  // TODO: add method toggleClearCompletedButton, which takes an optional param anyCompleted
  // (if anyCompleted is false or omitted, disable the clear completed button)

  // Tested 🗸
  function enableClearCompletedButton() {
    jata.clearCompletedButton.removeAttribute('disabled');
    jata.clearCompletedButton.classList.add('clear-completed-btn--enabled');
    jata.clearCompletedButton.classList.remove('clear-completed-btn--disabled');
  }

  // Tested 🗸
  function disableClearCompletedButton() {
    jata.clearCompletedButton.setAttribute('disabled', true);
    jata.clearCompletedButton.classList.add('clear-completed-btn--disabled');
    jata.clearCompletedButton.classList.remove('clear-completed-btn--enabled');
  }

  // Tested 🗸
  function displayTodoTexts() {
    var todoTexts = document.querySelectorAll('.todo-text');
    for (let todoText of todoTexts) {
      todoText.style.display = 'block';
    }
  }

  // Tested 🗸
  function removeEditForms() {
    for (let editForm of document.getElementsByClassName('edit-form')) {
      editForm.remove();
    }
  }

  // Tested 🗸
  function setViewState() {
    jata.displayTodoTexts();
    jata.removeEditForms();
  }
});

