import { Controller } from 'stimulus';
import Sortable from 'sortablejs';
import Rails from '@rails/ujs';

export default class SortableController extends Controller {
  static values = {
    resource: String,
    parameter: String,
  };

  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.end.bind(this),
    });
  }

  disconnect() {
    this.sortable.destroy();
    this.sortable = undefined;
  }

  end({ item, newIndex }) {
    if (!item.dataset.sortableUpdateUrl || !window._rails_loaded) {
      return;
    }

    const data = new FormData();
    data.append(`${this.resourceValue}[${this.parameterValue}]`, newIndex + 1);

    Rails.ajax({
      url: item.dataset.sortableUpdateUrl,
      type: 'PATCH',
      data,
    });
  }
}
