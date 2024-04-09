import { Application } from "@hotwired/stimulus"
import { Modal } from "tailwindcss-stimulus-components"

const application = Application.start();
application.register('modal', Modal)
