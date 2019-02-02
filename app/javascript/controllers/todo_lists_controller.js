import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["todos", "newTodoInput"]

  onSubmit() {
    for (let todoText of document.querySelectorAll('.todo-text.hidden')) {
      todoText.classList.remove('hidden')
    }
    for (let editForm of document.getElementsByClassName('edit-form')) {
      editForm.remove()
    }
  }

  onCreate(event) {
    const [data, status, xhr] = event.detail
    this.todosTarget.insertAdjacentHTML("beforeend", xhr.response)
    this.newTodoInputTarget.value = ""
  }
}

