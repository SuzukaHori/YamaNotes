import { Controller } from "@hotwired/stimulus";

let map = null; // 地図が複数回初期化されるとエラーが発生するため、グローバル変数として扱う

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    stations: Array,
    arrivedIds: Array,
    currentId: String,
  };

  /* eslint-disable no-undef */
  async connect() {
    this.allStations = this.stationsValue;
    this.arrivedStations = this._setArrivedStations();
    this.currentStation = this._setCurrentStation();

    if (!document.getElementById("map")._leaflet_id) {
      this._setMap();
      this._addLine({ stations: this.allStations, color: "green" });
      this._addPins(this.allStations);
      this._addLine({ stations: this.arrivedStations, color: "red" });
    }
  }

  _setArrivedStations() {
    return this.arrivedIdsValue.map((id) =>
      this.allStations.find((station) => station.id === id),
    );
  }

  _setCurrentStation() {
    const currentStationId = parseInt(this.currentIdValue);
    return this.allStations.find((station) => station.id === currentStationId);
  }

  _setMap() {
    const centerPosition = [35.678, 139.73946];
    map = L.map("map", {
      scrollWheelZoom: false,
      dragging: !L.Browser.mobile,
      tap: !L.Browser.mobile
    }).setView(centerPosition, 12);
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
    L.control.scale().addTo(map);
  }

  _addPins(stations) {
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      const pin = L.marker([station.latitude, station.longitude], {
        icon: L.divIcon({ className: "map-icon" }),
      })
        .addTo(map)
        .bindPopup(`${station.name}駅`);

      if (station === this.currentStation) {
        pin.openPopup();
      }
    }
  }

  _addLine({ stations, color }) {
    const locations = [];
    for (let i = 0; i < stations.length; i++) {
      const station = stations[i];
      locations.push([station.latitude, station.longitude]);
    }
    if (color === "green" || stations.length === this.allStations.length + 1) {
      locations.push([stations[0].latitude, stations[0].longitude]);
    }
    L.polyline(locations, { color, weight: 15, opacity: 0.4 }).addTo(map);
  }
}
