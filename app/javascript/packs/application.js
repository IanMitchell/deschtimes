// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start();
require('turbolinks').start();
require('@rails/activestorage').start();
require('channels');

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import '../css/application.css';

import 'controllers';
import * as ActiveStorage from '@rails/activestorage';
import LocalTime from 'local-time';
import flatpickr from 'flatpickr';

// on ready and turbolinks change, run:
document.addEventListener('turbolinks:load', () => {
  flatpickr('.js-datetime-picker', {
    enableTime: true,
  });

  const mobileMenuButton = document.querySelector('#mobile-menu-trigger');
  const mobileMenu = document.querySelector('#mobile-menu');
  const closedIcon = document.querySelector('#mobile-menu-closed');
  const openIcon = document.querySelector('#mobile-menu-open');

  if (mobileMenuButton) {
    mobileMenuButton.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
      mobileMenu.classList.toggle('block');

      closedIcon.classList.toggle('hidden');
      closedIcon.classList.toggle('block');
      openIcon.classList.toggle('hidden');
      openIcon.classList.toggle('block');
    });
  }
});

LocalTime.start();
ActiveStorage.start();
