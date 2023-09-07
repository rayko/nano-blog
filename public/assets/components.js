window.components = {
  element: function() {
    return document.getElementById('component-records');
  },

  refresh: function() {
    path = components.element().getAttribute('data-path');
    apiGET(path, components.load, components.requestError)
  },

  requestError: function(status) {
    alert(status);
  },

  load: function(data) {
    components.element().innerHTML = '';
    for (let i = 0; i < data.length; i++){
      item = components.buildItem(data[i]);
      components.element().appendChild(item);
    }
  },

  buildItem: function(record) {
    container = document.createElement('div');
    container.className = 'record-item';
    container.setAttribute('data-id', record.id);
    container.setAttribute('data-name', record.name);
    
    span = document.createElement('span');
    span.innerHTML = record.id + ' - ' + record.name;
    container.appendChild(span);

    removeLink = document.createElement('a');
    removeLink.className = 'action-link delete';
    removeLink.setAttribute('href', '#');
    removeLink.innerHTML = 'Remove';
    removeLink.addEventListener('click', components.removeAction);
    container.appendChild(removeLink);

    return container;
  },

  removeAction: function(event) {
    this.parentElement.remove();
    alert('Removed');
    event.preventDefault()
  }
}

