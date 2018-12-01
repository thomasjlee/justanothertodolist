document.addEventListener('turbolinks:load', function() {
  window.jata = {
    clearCompletedButton: document.querySelector('form[action$="clear_completed"] input[type=submit]'),
    toggleClearCompletedButton: toggleClearCompletedButton,
  }
});

function toggleClearCompletedButton() {
  if (document.querySelector('[data-clearable]')) {
    jata.clearCompletedButton.removeAttribute('disabled');
    jata.clearCompletedButton.classList.add('clickable');
  } else {
    jata.clearCompletedButton.setAttribute('disabled', true);
    jata.clearCompletedButton.classList.remove('clickable');
  }
}

