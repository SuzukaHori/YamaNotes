/* eslint-disable no-undef */
document.addEventListener("turbo:load", function() {
  const map = L.map("map").setView([35.6583345416667, 139.699565752778], 13);

  L.tileLayer("https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png", {
  maxZoom: 19,
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>Tiles Ⓒ <a href="">HOT</a>',
}).addTo(map);
})
