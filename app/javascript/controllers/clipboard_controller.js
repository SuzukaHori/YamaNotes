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
        alert("共有用URLをクリップボードにコピーしました");
      },
      () => {
        alert("コピーに失敗しました");
      },
    );
  }
}
