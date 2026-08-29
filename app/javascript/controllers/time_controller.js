import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hours", "minutes"];
  static values = {
    elapsedSeconds: Number, // サーバーが計算した経過秒数(中断時間は控除済み)
    running: { type: Boolean, default: true },
  };

  connect() {
    if (!this.runningValue) return; // 中断中はサーバーが描画した値のまま止める

    this.connectedAt = new Date();
    this.timer = setInterval(() => this._displayTime(), 1000);
  }

  disconnect() {
    if (this.timer) clearInterval(this.timer);
  }

  _displayTime() {
    const elapsedMs =
      this.elapsedSecondsValue * 1000 + (new Date() - this.connectedAt);

    this.hoursTarget.textContent = Math.floor(elapsedMs / (1000 * 60 * 60));
    this.minutesTarget.textContent = Math.floor(
      (elapsedMs % (1000 * 60 * 60)) / (1000 * 60),
    );
  }
}
