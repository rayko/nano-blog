window.logEntries = {

  element: function() {
    return document.getElementById('last-log-entry-item');
  },

  formElement: function() {
    return document.getElementById('create-log-entry-form');
  },

  refresh: function() {
    path = logEntries.element().getAttribute('data-path');
    apiGET(path, logEntries.loadLast, logEntries.requestError);
  },

  create: function() {
    formData = new FormData(logEntries.formElement());
    data = {
      severity: formData.get('severity'),
      component: formData.get('component'),
      message: formData.get('message')
    };
    path = logEntries.formElement().getAttribute('action');
    apiPOST(path, data, function(data) {
      logEntries.refresh();
      logEntries.formElement().children.message.value = null;
    }, logEntries.requestError);
  },

  requestError: function(status) {
    alert(status);
  },

  loadLast: function(data) {
    logEntries.element().innerHTML = '';
    item = logEntries.buildItem(data);
    logEntries.element().appendChild(item);
  },

  buildItem: function(record) {
    container = document.createElement('div');
    container.className = 'record-item';
    container.setAttribute('data-id', record.id);

    message = document.createElement('pre');
    message.innerHTML = record.message;
    container.appendChild(message);

    removeLink = document.createElement('a');
    removeLink.className = 'action-link delete';
    removeLink.setAttribute('href', '/control/api/log-entries/last');
    removeLink.innerHTML = 'Remove';
    removeLink.addEventListener('click', logEntries.removeAction);
    container.appendChild(removeLink);

    return container;
  },

  createAction: function(event) {
    logEntries.create();
    event.preventDefault();
  },

  removeAction: function(event) {
    event.preventDefault();
    targetElement = this.parentElement;
    path = this.getAttribute('href');
    apiDELETE(path, function(data) {
      logEntries.refresh();
    })
  }
  

}
