import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    url: String,
    successMessage: String,
    errorMessage: String,
  };

  copy() {
    navigator.clipboard.writeText(this.urlValue).then(
      () => {
        alert(this.successMessageValue);
      },
      () => {
        alert(this.errorMessageValue);
      },
    );
  }
}
