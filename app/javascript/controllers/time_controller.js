import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hours", "minutes"];
  static values = {
    departureDate: String,
    hourFormat: String,
    minuteFormat: String,
  };

  hoursTargetConnected() {
    setInterval(() => this._displayTime(), 1000);
  }

  _displayTime() {
    const now = new Date();
    const departureDate = new Date(this.departureDateValue);
    const elapsed = now - departureDate;

    const hours = Math.floor(elapsed / (1000 * 60 * 60));
    const minutes = Math.floor((elapsed % (1000 * 60 * 60)) / (1000 * 60));

    this.hoursTarget.textContent = this.hourFormatValue.replace(
      "%{count}",
      hours,
    );
    this.minutesTarget.textContent = this.minuteFormatValue.replace(
      "%{count}",
      minutes,
    );
  }
}
