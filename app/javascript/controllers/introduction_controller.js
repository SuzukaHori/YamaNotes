import { Controller } from "@hotwired/stimulus";

let currentPageNumber = 1;
const totalPageNumber = 3;

export default class extends Controller {
  static targets = [ "selectedStation", "selectedClockwiseMode" ]
  connect() {
    const currentPage = document.getElementById(`page-${currentPageNumber}`);
    currentPage.classList.remove("hidden");

    this._selectStation();
    this._selectMode();
  }

  disconnect() {
    currentPageNumber = 0;
  }

  next(event) {
    event.preventDefault();
    if (currentPageNumber < totalPageNumber) {
      let currentPage = document.getElementById(`page-${currentPageNumber}`);
      currentPage.classList.add("hidden");

      currentPageNumber++;
      currentPage = document.getElementById(`page-${currentPageNumber}`);
      currentPage.classList.remove("hidden");
    }
  }

  back(event) {
    event.preventDefault();
    if (currentPageNumber > 0) {
      let currentPage = document.getElementById(`page-${currentPageNumber}`);
      currentPage.classList.add("hidden");

      if (currentPageNumber === totalPageNumber) {
        currentPageNumber = 1;
      } else {
        currentPageNumber--;
      }
      currentPage = document.getElementById(`page-${currentPageNumber}`);
      currentPage.classList.remove("hidden");
    }
  }

  _selectStation() {
    const defaultStationName = "品川";

    const departureStationInput = document.getElementById("arrival_station_id");
    this.selectedStationTarget.textContent = defaultStationName;

    departureStationInput.addEventListener("input", () => {
      this.selectedStationTarget.textContent =
          departureStationInput.options[departureStationInput.selectedIndex].text;
    });
  }

  _selectMode() {
    const defaultClockwiseMode = "外回り";
    this.selectedClockwiseModeTarget.textContent = defaultClockwiseMode;

    document.querySelectorAll('input[name="walk[clockwise]"]').forEach((radioButton) => {
      radioButton.addEventListener("change", (event) => {
        this.selectedClockwiseModeTarget.textContent = event.target.value === "true" ? "外回り" : "内回り";
      });
    });
  }
}
