import { Controller } from 'stimulus';

export default class RemovableController extends Controller {
  static targets = ['container'];

  remove() {
    this.containerTarget.parentNode.removeChild(this.containerTarget);
  }
}
