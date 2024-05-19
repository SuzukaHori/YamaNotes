import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { departureDate: String };

  connect() {
    console.log('time')
    const departureDate = new Date(this.departureDateValue);
    setInterval(() => this._displayTime(departureDate), 1000);
  }

  _displayTime(departureDate) {
    console.log('time2')
    const element = document.querySelector(".time");
    console.log(element)
    if (element) {
      const now = new Date();
      const elapsedTime = this._localizeTime(now - departureDate);
      element.textContent = `出発から：${elapsedTime}`;
    }
  }

  _localizeTime(time) {
    console.log('time')
    const hours = Math.floor(time / (1000 * 60 * 60));
    const minutes = Math.floor((time % (1000 * 60 * 60)) / (1000 * 60));
    return `${hours}時間${minutes}分`;
  }
}
