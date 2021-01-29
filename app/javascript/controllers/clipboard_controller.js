import { Controller } from 'stimulus';

export default class ClipboardController extends Controller {
  static targets = ['source', 'button'];

  async copy() {
    // Copy
    const value = this.sourceTarget.textContent;
    await navigator.clipboard.writeText(value);

    // Inform User
    const text = this.buttonTarget.textContent;
    this.buttonTarget.textContent = 'Copied!';

    setTimeout(() => {
      this.buttonTarget.textContent = text;
    }, 5000);
  }
}
