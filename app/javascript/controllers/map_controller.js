import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["throughStationIds", "currentId"];

  /* eslint-disable no-undef */
  connect() {
    fetch("/stations")
      .then((response) => response.json())
      .then((stations) => {
        this.allStations = stations;
        this.arrivedStations = this.setArrivedStations();
        this.map = this.setMap();
      })
      .then(() => {
        this.addLine({ stations: this.allStations, color: "green" });
        this.addPins(this.allStations);
        this.addLine({ stations: this.arrivedStations, color: "red" });
      });
  }

  setMap() {
    const centerPosition = [35.68032, 139.73946];
    const map = L.map("map").setView(centerPosition, 12);
    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright/ja">OpenStreetMap</a>contributors',
    }).addTo(map);
    return map;
  }

  setArrivedStations() {
    const throughStationIds = JSON.parse(this.throughStationIdsTarget.value);
    return throughStationIds.map((id) =>
      this.allStations.find((station) => station.id === id),
    );
  }

  addPins(stations) {
    const myIcon = L.divIcon({ className: "map-icon" });
    this.currentStationId = parseInt(this.currentIdTarget.value);

    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      if (station.id === this.currentStationId) {
        L.marker([station.latitude, station.longitude], { icon: myIcon })
          .addTo(this.map)
          .bindPopup(`${station.name}駅`)
          .openPopup();
      } else {
        L.marker([station.latitude, station.longitude], { icon: myIcon })
          .addTo(this.map)
          .bindPopup(`${station.name}駅`);
      }
    }
  }

  addLine({ stations, color }) {
    const locations = [];
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      locations.push([station.latitude, station.longitude]);
    }
    if (stations.length === this.allStations.length) {
      locations.push([stations[0].latitude, stations[0].longitude]);
    }
    L.polyline(locations, { color, weight: 15, opacity: 0.4 }).addTo(this.map);
  }
}
