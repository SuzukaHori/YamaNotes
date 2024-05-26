import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["guide"];

  true() {
    this.guideTarget.src = "/assets/clockwise.png";
  }

  false() {
    this.guideTarget.src = "/assets/counter_clockwise.png";
  }
}
