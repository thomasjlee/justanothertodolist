import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "editTodoButton" ]

  connect() {
    this.overrideEditTodoButtons()
  }

  overrideEditTodoButtons() {
    for (let button of this.editTodoButtonTargets) {
      button.setAttribute("href", "/lists/" + this.listId.toString())
    }
  }

  get listId() {
    return document.querySelector("[data-list-id]").dataset.listId
  }
}

