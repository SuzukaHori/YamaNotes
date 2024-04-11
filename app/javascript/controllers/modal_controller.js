import { Controller, Application } from "@hotwired/stimulus";
import { Modal } from "tailwindcss-stimulus-components";

const application = Application.start();
application.register("modal", Modal);
export default class extends Controller {
  connect() {
    super.connect()
  }
}
