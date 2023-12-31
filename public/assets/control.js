window.addEventListener('load', initialize, false )

function initialize () {
  console.log('Admin Loaded!');

  if (window.components && components.formElement()) {
    components.formElement().addEventListener('submit', components.createAction);
    components.refresh();
  }

  if (window.logEntryTemplates && logEntryTemplates.formElement()) {
    logEntryTemplates.formElement().addEventListener('submit', logEntryTemplates.createAction)
    logEntryTemplates.refresh();
  }

  if (window.logEntries && logEntries.formElement()) {
    logEntries.formElement().addEventListener('submit', logEntries.createAction)
    logEntries.refresh();
  }

  if (document.getElementById('message')) {
    document.getElementById('message').addEventListener('input', inputAutoSize);
  }

  if (window.login && login.formElement()){
    login.formElement().addEventListener('submit', login.submitAction);
  }
}

function genericAPIErrorHandler(statusCode) {
  if (statusCode == 401) {
    window.location = '/control/login';
  } else {
    flashMessage("Error Status " + statusCode, 'alert');
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
