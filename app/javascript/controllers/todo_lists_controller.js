import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["todos", "newTodoInput"]

  onCreate() {
    this.setViewState()
  }

  onCreateSuccess(event) {
    const [data, status, xhr] = event.detail
    this.todosTarget.insertAdjacentHTML("beforeend", xhr.response)
    this.newTodoInputTarget.value = ""
  }

  onClearCompletedSuccess() {
    this.completedTodos.forEach(todo => todo.remove())
    this.disableClearCompletedButton()
  }

  onDestroy(event) {
    const todoId = event.currentTarget.dataset.todoId
    document.getElementById(todoId).remove()
    if (!this.anyCompleted) {
      this.disableClearCompletedButton()
    }
  }

  get completedTodos() {
    return [...document.querySelectorAll("button[name='todo_item[completed]'][value='false']")]
      .map(button => button.parentElement.dataset.todoId)
      .map(id => document.getElementById(id))
  }

  get anyCompleted() {
    return Boolean(document.querySelectorAll("button[name='todo_item[completed]'][value='false']").length)
  }

  get clearCompletedButton() {
    return document.getElementById("clear_completed_button")
  }

  setViewState() {
    // display all todo text
    for (let todoText of document.querySelectorAll('.todo-text.hidden')) {
      todoText.classList.remove('hidden')
    }
    // remove all edit todo forms
    for (let editForm of document.getElementsByClassName('edit-form')) {
      editForm.remove()
    }
  }

  enableClearCompletedButton() {
    this.clearCompletedButton.removeAttribute('disabled')
    this.clearCompletedButton.classList.add('clear-completed-btn--enabled');
    this.clearCompletedButton.classList.remove('clear-completed-btn--disabled');
  }

  disableClearCompletedButton() {
    this.clearCompletedButton.setAttribute('disabled', true)
    this.clearCompletedButton.classList.add('clear-completed-btn--disabled');
    this.clearCompletedButton.classList.remove('clear-completed-btn--enabled');
  }
}

