import { Controller } from "@hotwired/stimulus";

let currentPageNumber = 1;
const totalPageNumber = 3;

export default class extends Controller {
  connect() {
    const currentPage = document.getElementById(`page-${currentPageNumber}`);
    currentPage.classList.remove("hidden");

    this._selectStation();
    this._selectMode();
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
    const selectedStation = document.getElementById("selected_station");
    selectedStation.textContent = defaultStationName;

    departureStationInput.addEventListener("input", () => {
      selectedStation.textContent =
        departureStationInput.options[departureStationInput.selectedIndex].text;
    });
  }

  _selectMode() {
    const defaultClockwiseMode = "外回り";
    const selectedClockwiseMode = document.getElementById("clockwise_mode");
    selectedClockwiseMode.textContent = defaultClockwiseMode;

    document
      .querySelectorAll('input[name="walk[clockwise]"]')
      .forEach((radioButton) => {
        radioButton.addEventListener("change", (event) => {
          selectedClockwiseMode.textContent =
            event.target.value === "true" ? "外回り" : "内回り";
        });
      });
  }
}
