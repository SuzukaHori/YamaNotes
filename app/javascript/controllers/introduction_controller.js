import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selectedStation", "selectedClockwiseMode"];
  static values = {
    initialStation: String,
    initialClockwiseMode: String,
    clockwiseLabel: String,
    counterclockwiseLabel: String,
  };

  connect() {
    this.selectedStationTarget.textContent = this.initialStationValue;
    this.selectedClockwiseModeTarget.textContent =
      this.initialClockwiseModeValue;
  }

  changeStation(event) {
    const selectedStationName =
      event.target.options[event.target.selectedIndex].text;
    this.selectedStationTarget.textContent = selectedStationName;
  }

  changeClockwiseMode(event) {
    this.selectedClockwiseModeTarget.textContent =
      event.target.value === "true"
        ? this.clockwiseLabelValue
        : this.counterclockwiseLabelValue;
  }
}
