window.components = {
  formElement: function() {
    return document.getElementById('create-component-form');
  },

  create: function() {
    formData = new FormData(components.formElement());
    data = {
      name: formData.get('name')
    };
    path = components.formElement().getAttribute('action');
    apiPOST(path, data, function(data) {
      flashMessage('Component Created!', 'notice');
      components.refresh();
      components.formElement().reset();
    });
  },

  element: function() {
    return document.getElementById('component-records');
  },

  refresh: function() {
    path = components.element().getAttribute('data-path');
    apiGET(path, components.load);
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
    removeLink.setAttribute('href', '/control/api/components/' + record.id);
    removeLink.innerHTML = 'Remove';
    removeLink.addEventListener('click', components.removeAction);
    container.appendChild(removeLink);

    return container;
  },

  createAction: function(event) {
    components.create();
    event.preventDefault();
  },

  removeAction: function(event) {
    event.preventDefault();
    targetElement = this.parentElement;
    path = this.getAttribute('href');
    apiDELETE(path, function(data) {
      flashMessage('Component Removed!', 'notice');
      targetElement.remove();
    })
  }
}

