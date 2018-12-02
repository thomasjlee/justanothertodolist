document.addEventListener('turbolinks:load', function() {
  window.jata = {
    init: function() {
      this.attachEditHandlers();
    },
    clearCompletedButton:
      document.querySelector('form[action$="clear_completed"] input[type=submit]'),
    toggleClearCompletedButton : toggleClearCompletedButton,
    attachEditHandlers         : attachEditHandlers,
    hideEditForms              : hideEditForms,
    displayTodoTexts           : displayTodoTexts,
    onEditClicked              : onEditClicked,
    toggleViewState            : toggleViewState
  }

  jata.init();
});

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

function onEditClicked(event) {
  const todo = event.target.closest('.todo-item');
  const editForm = todo.querySelector('.edit-todo-form');
  const todoText = todo.querySelector('.todo-text');
  if (editForm.style.display === 'block') {
    jata.toggleViewState();
  } else {
    jata.toggleViewState();
    editForm.style.display = 'block';
    todoText.style.display = 'none';
  }
}

function attachEditHandlers() {
  for (let editButton of document.getElementsByClassName('edit-btn')) {
    editButton.addEventListener('click', jata.onEditClicked);
  }
}

function attachNewEditHandler(todoId) {
  const todo = document.getElementById(todoId);
  todo.addEventListener('click', jata.onEditClicked);
}

function displayTodoTexts() {
  const todoTexts = document.querySelectorAll('.todo-text');
  for (let todoText of todoTexts) {
    todoText.style.display = 'block';
  }
}

function hideEditForms() {
  const editForms = document.querySelectorAll('.edit-todo-form');
  for (let editForm of editForms) {
    editForm.style.display = 'none';
  }
}

function toggleViewState() {
  jata.displayTodoTexts();
  jata.hideEditForms();
}
