import { Controller } from "@hotwired/stimulus";

let map = null; // 地図が複数回初期化されるとエラーが発生するため、グローバル変数として扱う

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["currentId"];
  static values = {
    stations: Array,
    arrivedIds: Array,
    currentId: String,
  };

  /* eslint-disable no-undef */
  connect() {
    this.allStations = this.stationsValue;
    this.arrivedStations = this.setArrivedStations();
    this.currentStationId = parseInt(this.currentIdValue);

    if (!document.getElementById("map")._leaflet_id) {
      this.setMap().then(() => {
        this.addLine({ stations: this.allStations, color: "green" });
        this.addPins(this.allStations);
        this.addLine({ stations: this.arrivedStations, color: "red" });
      });
    }
  }

  setArrivedStations() {
    return this.arrivedIdsValue.map((id) =>
      this.allStations.find((station) => station.id === id),
    );
  }

  setMap() {
    return new Promise((resolve) => {
      const centerPosition = [35.68032, 139.73946];
      map = L.map("map").setView(centerPosition, 12);
      L.tileLayer(
        `https://api.maptiler.com/maps/jp-mierune-streets/{z}/{x}/{y}.png?key=${gon.maptiler_key}`,
        {
          tileSize: 512,
          zoomOffset: -1,
          attribution:
            '<a href="https://www.maptiler.com/copyright/" target="_blank">&copy; MapTiler</a> <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap contributors</a> <a href="https://maptiler.jp/" target="_blank">&copy; MIERUNE</a>',
          crossOrigin: true,
        },
      ).addTo(map);
      resolve();
    });
  }

  addPins(stations) {
    const myIcon = L.divIcon({ className: "map-icon" });

    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      const pin = L.marker([station.latitude, station.longitude], {
        icon: myIcon,
      })
        .addTo(map)
        .bindPopup(`${station.name}駅`);

      if (station.id === this.currentStationId) {
        pin.openPopup();
      }
    }
  }

  addLine({ stations, color }) {
    const locations = [];
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      locations.push([station.latitude, station.longitude]);
    }
    if (stations.length === this.allStations.length + 1 || color === "green") {
      locations.push([stations[0].latitude, stations[0].longitude]);
    }
    L.polyline(locations, { color, weight: 15, opacity: 0.4 }).addTo(map);
  }
}
