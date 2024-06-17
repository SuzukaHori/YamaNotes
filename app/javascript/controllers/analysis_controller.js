import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    window.dataLayer = window.dataLayer || [];
    function gtag() {
      // eslint-disable-next-line no-undef
      dataLayer.push(arguments);
    }
    gtag("js", new Date());
    gtag("config", "G-VQT4R8C8MZ");
  }
}
