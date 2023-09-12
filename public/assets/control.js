window.addEventListener('load', initialize, false )

function initialize () {
  console.log('Admin Loaded!');
  templates = document.getElementsByClassName('template-item');
  for (let i = 0; i < templates.length; i ++) {
    buildTemplateForm(templates[i]);
  }

  if (components.formElement()) {
    components.formElement().addEventListener('submit', components.createAction);
    components.refresh();
  }

  if (logEntryTemplates.formElement()) {
    logEntryTemplates.formElement().addEventListener('submit', logEntryTemplates.createAction)
    logEntryTemplates.refresh();
  }

  if (logEntries.formElement()) {
    logEntries.formElement().addEventListener('submit', logEntries.createAction)
    logEntries.refresh();
  }

  if (document.getElementById('message')) {
    document.getElementById('message').addEventListener('input', inputAutoSize);
  }

}

function isEmpty(thing) {
  if (thing == '') { return true; }
  if (thing == null) { return true; }
  if (thing == undefined) { return true; }
  if (thing.length == 0) { return true; }

  false;
}

function inputAutoSize(event) {
  minSize = 10;
  this.size = Math.max(this.value.length, minSize);
}

function afterLogEntryPost() {
  logEntries.refresh();
}

function flashMessage(message, messageType) {
  container = document.getElementById('flash-container');
  box = document.createElement('div');
  box.className = messageType;
  box.innerHTML = message;
  container.appendChild(box);
  box.style.opacity = 0;
  fadeIn(box);
}

function fadeOut(element) {
  opacity = 1.0;
  interval = setInterval(function() {
    opacity -= 0.15;
    element.style.opacity = opacity;
    if (opacity <= 0) {
      clearInterval(interval);
      element.remove();
    }
  }, 50);
}

function fadeIn(element) {
  opacity = 0.0;
  interval = setInterval(function() {
    opacity += 0.15;
    element.style.opacity = opacity;
    if (opacity > 1) {
      clearInterval(interval);
      setTimeout(function() { fadeOut(element) }, 3000);
    }
  }, 50);
}
