import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hours", "minutes"];
  static values = { departureDate: String };

  connect() {
    setInterval(() => this._displayTime(), 1000);
  }

  _displayTime() {
    const now = new Date();
    const departureDate = new Date(this.departureDateValue);
    const elapsed = now - departureDate;

    this.hoursTarget.textContent = Math.floor(elapsed / (1000 * 60 * 60));
    this.minutesTarget.textContent = Math.floor(
      (elapsed % (1000 * 60 * 60)) / (1000 * 60),
    );
  }
}
