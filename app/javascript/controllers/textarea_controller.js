import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "textarea" ]

  connect() {
    this.resize()
  }

  resize() {
    this.textareaTarget.style.height = "1.75rem"
    this.textareaTarget.style.height = this.scrollHeight + "px"
  }

  get scrollHeight() {
    return this.textareaTarget.scrollHeight
  }
}

