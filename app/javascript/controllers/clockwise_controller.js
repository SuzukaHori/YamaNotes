import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["guide"];
  static values = { truePath: String, falsePath: String };

  async connect() {
    const trueImage = await fetch(this.truePathValue);
    this.truePath = trueImage.url;
    const falseImage = await fetch(this.falsePathValue);
    this.falsePath = falseImage.url;
  }

  async true() {
    this.guideTarget.src = this.truePath;
  }

  false() {
    this.guideTarget.src = this.falsePath;
  }
}
