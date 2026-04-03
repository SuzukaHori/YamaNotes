import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hours", "minutes"];
  static values = { departureDate: String };

  hoursTargetConnected() {
    setInterval(() => this._displayTime(), 1000);
  }

  _displayTime() {
    const elapsed = new Date() - new Date(this.departureDateValue);
    this.hoursTarget.textContent = Math.floor(elapsed / (1000 * 60 * 60));
    this.minutesTarget.textContent = Math.floor(
      (elapsed % (1000 * 60 * 60)) / (1000 * 60),
    );
  }
}
