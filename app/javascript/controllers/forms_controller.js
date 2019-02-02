import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    if (this.hasFormTarget) {
      this.formTargets.forEach(form => {
        form.insertAdjacentHTML("afterbegin", "<input type='hidden' name='js_enabled' value='true' />")
      })
    }
  }
}

