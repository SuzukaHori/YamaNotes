import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["elapsed"];
  static values = { departureDate: String };

  elapsedTargetConnected() {
    setInterval(() => this._displayTime(), 1000);
  }

  _displayTime() {
    const now = new Date();
    const departureDate = new Date(this.departureDateValue);
    const elapsedTime = this._localizeTime(now - departureDate);
    const element = this.elapsedTarget;
    element.textContent = elapsedTime;
  }

  _localizeTime(time) {
    const hours = Math.floor(time / (1000 * 60 * 60));
    const minutes = Math.floor((time % (1000 * 60 * 60)) / (1000 * 60));
    return `${hours}時間${minutes}分`;
  }
}
