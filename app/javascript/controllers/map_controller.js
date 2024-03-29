import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["ids", "currentid"];

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

    fetch("/stations")
      .then((response) => response.json())
      .then((stations) => {
        this.allStations = stations;
      })
      .then(() => {
        this.addPins(this.allStations);
        this.addGreenLine(this.allStations);
      });

    
  }

  addPins(stations) {
    const myIcon = L.divIcon({ className: "map-icon" });
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      L.marker([station.latitude, station.longitude], { icon: myIcon }).addTo(this.map).bindPopup(`${station.name}駅`);
    }

    // const ids = JSON.parse(this.idsTarget.value);
    // console.log(ids);
    // const arrivedStations = ids.map((id) => allStations[id - 1]);
    // this.addRedLine(arrivedStations);

    // const currentStationId = this.currentidTarget.value;
    // const currentStation = stations[currentStationId - 1];
    // L.marker([currentStation.latitude, currentStation.longitude], { icon: myIcon }).addTo(this.map).bindPopup(`${currentStation.name}駅`).openPopup();
  }

  addGreenLine(stations) {
    const locations = [];
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      locations.push([station.latitude, station.longitude]);
    }
    locations.push([stations[0].latitude, stations[0].longitude]);
    L.polyline(locations, { color: "green", weight: 15, opacity: 0.4 }).addTo(this.map);
  }

  addRedLine(stations) {
    const locations = [];
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      locations.push([station.latitude, station.longitude]);
    }
    // console.log(locations);
    L.polyline(locations, { color: "red", weight: 15, opacity: 0.6 }).addTo(this.map);
  }
}
