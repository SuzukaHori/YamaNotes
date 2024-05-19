import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { departureDate: String };

  connect() {
    const departureDate = new Date(this.departureDateValue);
    setInterval(() => this._displayTime(departureDate), 1000);
  }

  _displayTime(departureDate) {
    const element = document.querySelector(".time");
    if (element) {
      const now = new Date();
      const elapsedTime = this._localizeTime(now - departureDate);
      element.textContent = elapsedTime;
    }
  }

  _localizeTime(time) {
    const hours = Math.floor(time / (1000 * 60 * 60));
    const minutes = Math.floor((time % (1000 * 60 * 60)) / (1000 * 60));
    return `${hours}時間${minutes}分`;
  }
}
