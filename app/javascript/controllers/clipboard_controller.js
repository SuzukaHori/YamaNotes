import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    content: String,
  };

  connect() {
    this.originalContent = this.element.innerHTML;
  }

  copy() {
    navigator.clipboard.writeText(this.contentValue).then(
      () => {
        this.element.innerHTML =
          "<p class='text-xs font-semibold text-green-700'>Copied!</p>";
        setTimeout(() => {
          this.element.innerHTML = this.originalContent;
        }, 2000);
      },
      () => {
        alert("クリップボードにコピー出来ませんでした。");
      },
    );
  }
}
