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

  // TODO: refactor - this method is doing quite a lot
  onToggleCompleteSuccess(event) {
    this.setViewState()

    const todoId = event.currentTarget.dataset.todoId
    const todoLi = document.getElementById(todoId)
    const completeButton = event.currentTarget.querySelector("button[name='todo_item[completed]']")

    todoLi.querySelector(".todo-text").classList.toggle("completed")
    todoLi.dataset.completed = todoLi.dataset.completed === "true" ? "false" : "true"

    completeButton.value = completeButton.value === "true" ? "false" : "true"
    completeButton.classList.toggle("btn-info")
    completeButton.classList.toggle("btn-completed")
    completeButton.classList.toggle("btn-outline-info")
    completeButton.classList.toggle("btn-not-completed")
    completeButton.blur()

    this.completedTodos.length ? this.enableClearCompletedButton() : this.disableClearCompletedButton()
  }

  // TODO: refactor
  onEditButtonClick(event) {
    event.preventDefault()
    const todoId = event.currentTarget.dataset.todoId
    const todoLi = document.getElementById(todoId)
    const editForm = todoLi.querySelector("form.edit-form")

    if (this.isEditing() && this.isCancelingEdit(todoId)) {
      this.setViewState()
    } else if (this.isEditing()) {
      this.setViewState()
      editForm.classList.remove("hidden")
      editForm.querySelector("textarea").style["overflow-y"] = "hidden"
      todoLi.querySelector(".todo-text").classList.add("hidden")
      const textarea = editForm.querySelector("textarea")
      const textareasController = this.application.getControllerForElementAndIdentifier(textarea, "textarea") // will be "textareas"
      textareasController.resize()
      this.focus(editForm.querySelector("textarea"))
    } else {
      editForm.classList.remove("hidden")
      editForm.querySelector("textarea").style["overflow-y"] = "hidden"
      todoLi.querySelector(".todo-text").classList.add("hidden")
      const textarea = editForm.querySelector("textarea")
      const textareasController = this.application.getControllerForElementAndIdentifier(textarea, "textarea") // will be "textareas"
      textareasController.resize()
      this.focus(editForm.querySelector("textarea"))
    }
  }

  onUpdateSuccess(event) {
    const [data, status, xhr] = event.detail
    const todoLi = event.currentTarget.parentElement
    const todoP = todoLi.querySelector(".todo-text p")
    todoP.textContent = xhr.response
    this.setViewState()
  }

  onClearCompletedSuccess() {
    this.completedTodos.forEach(todo => todo.remove())
    this.disableClearCompletedButton()
  }

  onDestroy(event) {
    const todoId = event.currentTarget.dataset.todoId
    document.getElementById(todoId).remove()
    if (!this.completedTodos.length) {
      this.disableClearCompletedButton()
    }
  }

  isEditing() {
    return Boolean(this.editTodoForm)
  }

  isCancelingEdit(editingTodoId) {
    return this.editTodoForm.dataset.todoId === editingTodoId
  }

  get completedTodos() {
    return document.querySelectorAll("[data-completed=true]")
  }

  get clearCompletedButton() {
    return document.getElementById("clear_completed_button")
  }

  get editTodoForm() {
    return document.querySelector("form.edit-form:not(.hidden)")
  }

  setViewState() {
    // display all todo text
    for (let todoText of document.querySelectorAll('.todo-text.hidden')) {
      todoText.classList.remove('hidden')
    }
    // remove all edit todo forms
    for (let editForm of document.getElementsByClassName('edit-form')) {
      editForm.classList.add('hidden')
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

  focus(element) {
    const inputText = element.value
    element.focus()
    element.value = ""
    element.value = inputText
  }
}

