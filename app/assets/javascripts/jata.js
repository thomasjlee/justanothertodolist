document.addEventListener('turbolinks:load', function() {
  window.Jata = new Jata();

  function Jata() {
    // this.clearCompletedButton = document.getElementById("clear_completed_button");
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

  Jata.prototype._displayTodoContents = function() {
    for (let todoText of document.querySelectorAll('.todo-text.hidden')) {
      todoText.classList.remove('hidden');
    }
  };

  Jata.prototype._removeEditForms = function() {
    for (let editForm of document.getElementsByClassName('edit-form')) {
      editForm.remove();
    }
  };
});

