import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { departureDate: String };

  connect() {
    const departureDate = new Date(this.departureDateValue);
    setInterval(() => this.displayTime(departureDate), 1000);
  }

  displayTime(departureDate) {
    const now = new Date();
    const elapsedTime = this.localizeTime(now - departureDate);
    const formattedDate = this.localizeDate(departureDate);
    document.querySelector(".time").textContent =
      `出発から：${elapsedTime}（出発： ${formattedDate}）`;
  }

  localizeTime(time) {
    const hours = Math.floor(time / (1000 * 60 * 60));
    const minutes = Math.floor((time % (1000 * 60 * 60)) / (1000 * 60));
    return `${hours}時間${minutes}分`;
  }

  localizeDate(date) {
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const hours = date.getHours();
    const minutes = date.getMinutes();
    return `${month}月${day}日${hours}時${minutes}分`;
  }
}
