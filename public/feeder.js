window.lastMessageHash = null;
window.addEventListener('load', triggerFeeder, false )

function getMessages() {
  path = "/feed";
  if (window.lastMessageHash) {
    path += "?after=" + window.lastMessageHash;
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
}

function processData(data) {
  if (data) {
    targetElement = document.getElementById('messages-container');
    for (let index = 0; index < data.length; index ++) {
      innerMessage = document.createElement('pre');
      innerMessage.setAttribute('data-hash', data[index].hash);
      innerMessage.setHTML(data[index].message);
      window.lastMessageHash = data[index].hash;
      if (data[index].level) {
        innerMessage.className = data[index].level + '-level'
      } else {
        innerMessage.className = 'generic-level';
      }
      messageContainer = document.createElement('div');
      messageContainer.append(innerMessage);
      targetElement.append(messageContainer);
    }
  }
  window.scrollTo(0, document.body.scrollHeight);
  window.setTimeout(getMessages, 30000);
}
