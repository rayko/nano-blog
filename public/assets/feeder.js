window.lastMessageID = null;
window.addEventListener('load', triggerFeeder, false )

function getMessages() {
  path = "/feed";
  if (window.lastMessageID) {
    path += "?after_id=" + window.lastMessageID;
  }

  fetch(path).then(function(response) {
    return response.json();
  }).then(function(data) {
    console.log("Success Fetch");
    processData(data);
  }).catch(function(err) {
    console.log('Fetch Error :-S', err);
  });
}

function triggerFeeder () {
  getMessages();
  window.addEventListener('resize', function(event) {
    window.scrollTo(0, document.body.scrollHeight)
  });
  document.getElementById('about-trigger').addEventListener('click', function() {
    toggleAbout();
  });

  document.getElementById('close-about-modal').addEventListener('click', function() {
    toggleAbout();
  });

}

function processData(data) {
  if (data) {
    targetElement = document.getElementById('messages-container');
    for (let index = 0; index < data.length; index ++) {
      window.lastMessageID = data[index].id;

      innerMessage = document.createElement('pre');
      innerMessage.setAttribute('data-hash', data[index].id);
      innerMessage.innerHTML = data[index].message;
      innerMessage.className = severityClassName(data[index].severity)

      messageContainer = document.createElement('div');
      messageContainer.append(innerMessage);
      targetElement.append(messageContainer);
    }
  }
  window.scrollTo(0, document.body.scrollHeight);
  window.setTimeout(getMessages, 30000);
}

function severityClassName(name) {
  if (name == 'INFO') { return 'info-level' }
  if (name == 'WARN') { return 'warn-level' }
  if (name == 'DEBUG') { return 'debug-level' }
  if (name == 'CRIT') { return 'critical-level' }
  if (name == 'ERROR') { return 'error-level' }
  if (name == '???') { return 'unknown-level' }

  return 'generic-level'
}

function toggleAbout() {
  toggleClass(document.getElementById('messages-container'), 'blur');
  toggleClass(document.getElementById('about-info-modal'), 'hidden');
}

function toggleClass(element, className) {
  if (element.className.search(className) >= 0) { 
    element.className = element.className.replace(className, '');
  } else {
    element.className += ' ' + className;
  }
}
