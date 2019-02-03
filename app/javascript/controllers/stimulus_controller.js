// parent controller that wraps the `= yield` tag in application.html.haml

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form"]

  // prepares forms with data-target stimulus.form to be handled by stimulus
  connect() {
    if (this.hasFormTarget) {
      this.formTargets.forEach(form => {
        form.insertAdjacentHTML("afterbegin", "<input type='hidden' name='js' value='true' />")
      })
    }
  }
}

