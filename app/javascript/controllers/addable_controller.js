import { Controller } from 'stimulus';

export default class AddableController extends Controller {
  static targets = ['container', 'template'];

  add() {
    this.containerTarget.appendChild(
      document.importNode(this.templateTarget.content, true)
    );
  }
}
