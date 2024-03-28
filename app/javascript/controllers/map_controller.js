import { Controller } from "@hotwired/stimulus";
import { allStations } from "./stations";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["ids"];

  /* eslint-disable no-undef */
  initialize() {
    this.map = L.map("map").setView([35.6583345416667, 139.699565752778], 13);
  }

  connect() {
    L.tileLayer("https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>Tiles Ⓒ <a href="">HOT</a>',
    }).addTo(this.map);
    this.addPin(allStations);
    this.addLine(allStations);
  }

  addPin(stations) {
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      L.marker([station.latitude, station.longitude]).addTo(this.map).bindPopup(station.name);
    }
  }

  addLine(stations) {
    const locations = [];
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      locations.push([station.latitude, station.longitude]);
    }
    L.polyline(locations, { color: "green", weight: 10, opacity: 0.5 }).addTo(this.map);
    console.log(locations);
  }

  draw() {
    this.addPin();
    // const ids = this.idsTarget.value;
  }
}
