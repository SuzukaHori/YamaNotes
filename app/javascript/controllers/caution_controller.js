import { Application } from "@hotwired/stimulus";
import { Modal } from "tailwindcss-stimulus-components";

const application = Application.start();
application.register("modal", Modal);

export default class extends Modal {
  connect() {
    localStorage.removeItem("confirm");
    if (!localStorage.getItem("confirm")) {
      setTimeout(() => {
        this.open();
      }, 500);
      localStorage.setItem("confirm", true);
    }
  }
}
