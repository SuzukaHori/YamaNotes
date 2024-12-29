import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selectedStation", "selectedClockwiseMode"];

  connect() {
    this.selectedStationTarget.textContent = "品川";
    this.selectedClockwiseModeTarget.textContent = "外回り";
  }

  changeStation(event) {
    const selectedStationName =
      event.target.options[event.target.selectedIndex].text;
    this.selectedStationTarget.textContent = selectedStationName;
  }

  changeClockwiseMode(event) {
    this.selectedClockwiseModeTarget.textContent =
      event.target.value === "true" ? "外回り" : "内回り";
  }
}
