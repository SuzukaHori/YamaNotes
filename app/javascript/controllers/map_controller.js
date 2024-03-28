import { Controller } from "@hotwired/stimulus";
import { allStations } from "./stations";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["ids"];

  /* eslint-disable no-undef */
  initialize() {
    const centerPosition = [35.68032, 139.73946];
    this.map = L.map("map").setView(centerPosition, 12);
  }

  connect() {
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>Tiles Ⓒ <a href="">HOT</a>',
    }).addTo(this.map);

    this.addPin(allStations);
    this.addLine(allStations);
  }

  addPin(stations) {
    const myIcon = L.divIcon({ className: "map-icon"});

    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      L.marker([station.latitude, station.longitude], { icon: myIcon }).addTo(this.map).bindPopup(station.name);
    }
  }

  addLine(stations) {
    const locations = [];
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      locations.push([station.latitude, station.longitude]);
    }
    locations.push([stations[0].latitude, stations[0].longitude]);
    
    L.polyline(locations, { color: "green", weight: 15, opacity: 0.5 }).addTo(this.map);
    console.log(locations);
  }

  draw() {
    this.addPin();
    // const ids = this.idsTarget.value;
  }
}
