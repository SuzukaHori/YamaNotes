import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["page"];
  static values = {
    totalPages: Number,
    currentPage: { type: Number, default: 1 },
  };

  connect() {
    this.showPage(this.currentPageValue);
  }

  next(event) {
    event.preventDefault();
    if (this.currentPageValue < this.totalPagesValue) {
      this.showPage(this.currentPageValue + 1);
    }
  }

  back(event) {
    event.preventDefault();
    if (this.currentPageValue > 1) {
      this.showPage(this.currentPageValue - 1);
    }
  }

  backStartPage(event) {
    event.preventDefault();
    this.showPage(1);
  }

  showPage(pageNumber) {
    // 現在のページを非表示
    this.pageTargets.forEach((page, index) => {
      page.classList.toggle("hidden", index + 1 !== pageNumber);
    });
    // ページ番号を更新
    this.currentPageValue = pageNumber;
  }
}
