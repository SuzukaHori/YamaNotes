import { Controller } from "@hotwired/stimulus";

let currentPageNumber = 1;
const totalPageNumber = 3;

export default class extends Controller {
  static targets = ["selectedStation", "selectedClockwiseMode"];
  connect() {
    const currentPage = document.getElementById(`page-${currentPageNumber}`);
    currentPage.classList.remove("hidden");
    this.selectedStationTarget.textContent = "品川"
    this.selectedClockwiseModeTarget.textContent = "外回り";
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
