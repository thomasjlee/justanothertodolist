import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["todos", "newTodoInput"]

  onCreate() {
    for (let todoText of document.querySelectorAll('.todo-text.hidden')) {
      todoText.classList.remove('hidden')
    }
    for (let editForm of document.getElementsByClassName('edit-form')) {
      editForm.remove()
    }
  }

  onCreateSuccess(event) {
    const [data, status, xhr] = event.detail
    this.todosTarget.insertAdjacentHTML("beforeend", xhr.response)
    this.newTodoInputTarget.value = ""
  }

  onDestroy(event) {
    const todoId = event.currentTarget.dataset.todoId
    document.getElementById(todoId).remove()
    if (!this.anyCompleted) {
      this.disableClearCompletedButton()
    }
  }

  get anyCompleted() {
    return Boolean(document.querySelectorAll("button[name='todo_item[completed]'][value='false']").length)
  }

  get clearCompletedButton() {
    return document.getElementById("clear_completed_button")
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

