import { Application } from '@hotwired/stimulus';
import { Slideover } from 'tailwindcss-stimulus-components';

console.log("aaaaaaaa")
const application = Application.start();
application.register('slideover', Slideover);


export default class extends Slideover {}
