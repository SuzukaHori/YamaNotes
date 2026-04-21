import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "addButton"]

  show() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result
      this.previewTarget.classList.remove("hidden")
      if (this.hasAddButtonTarget) {
        this.addButtonTarget.classList.add("hidden")
      }
    }
    reader.readAsDataURL(file)
  }
}
