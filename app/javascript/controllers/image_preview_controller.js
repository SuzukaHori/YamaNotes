import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "addButton", "cancelButton"]

  show() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result
      this.previewTarget.classList.remove("hidden")
      this.addButtonTarget.classList.add("hidden")
      this.cancelButtonTarget.classList.remove("hidden")
    }
    reader.readAsDataURL(file)
  }

  cancel() {
    this.inputTarget.value = ""
    this.previewTarget.src = ""
    this.previewTarget.classList.add("hidden")
    this.addButtonTarget.classList.remove("hidden")
    this.cancelButtonTarget.classList.add("hidden")
  }
}
