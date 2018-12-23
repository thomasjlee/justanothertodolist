document.addEventListener('turbolinks:load', function() {
  window.Jata = new Jata();

  function Jata() {
    this.clearCompletedButton = document.getElementById("clear_completed_button");
  }

  Jata.prototype.focus = function(domElement) {
    var inputText = domElement.value;
    domElement.focus();
    domElement.value = '';
    domElement.value = inputText;
  };

  Jata.prototype.setViewState = function() {
    this._displayTodoContents();
    this._removeEditForms();
  };

  Jata.prototype.toggleClearCompletedButton = function(anyCompletedTodoItems) {
    this.clearCompletedButton && anyCompletedTodoItems
      ? this._enableClearCompletedButton()
      : this._disableClearCompletedButton();
  };

  Jata.prototype._displayTodoContents = function() {
    for (let todoText of document.querySelectorAll('.todo-text')) {
      todoText.style.display = 'block';
    }
  };

  Jata.prototype._removeEditForms = function() {
    for (let editForm of document.getElementsByClassName('edit-form')) {
      editForm.remove();
    }
  };

  Jata.prototype._enableClearCompletedButton = function() {
    this.clearCompletedButton.removeAttribute('disabled');
    this.clearCompletedButton.classList.add('clear-completed-btn--enabled');
    this.clearCompletedButton.classList.remove('clear-completed-btn--disabled');
  };

  Jata.prototype._disableClearCompletedButton = function() {
    this.clearCompletedButton.setAttribute('disabled', true);
    this.clearCompletedButton.classList.add('clear-completed-btn--disabled');
    this.clearCompletedButton.classList.remove('clear-completed-btn--enabled');
  };
});

