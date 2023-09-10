window.logEntryTemplates = {

  formElement: function() {
    return document.getElementById('create-log-entry-template-form');
  },

  element: function() {
    return document.getElementById('log-entry-template-records');
  },

  refresh: function() {
    path = logEntryTemplates.element().getAttribute('data-path');
    apiGET(path, logEntryTemplates.load);
  },

  // Create template, not post from tempalte
  create: function() {
    formData = new FormData(logEntryTemplates.formElement());
    data = { 
      severity: formData.get('severity'),
      component: formData.get('component'),
      message_template: formData.get('message_template')
    };
    path = logEntryTemplates.formElement().getAttribute('action');
    apiPOST(path, data, function(data) {
      flashMessage('LogEntryTemplate Created!', 'notice');
      logEntryTemplates.refresh();
      logEntryTemplates.formElement().reset();
    });
  },

  load: function(data) {
    logEntryTemplates.element().innerHTML = '';
    for (let i = 0; i < data.length; i++) {
      item = logEntryTemplates.buildItem(data[i]);
      logEntryTemplates.element().appendChild(item);
    }
  },

  buildItem: function(record) {
    itemContainer = document.createElement('div');
    itemContainer.className = 'record-item';
    itemContainer.setAttribute('data-id', record.id);

    form = document.createElement('form');
    form.className = 'template-form';
    form.method = 'post';
    form.action = '/control/api/log-entry-templates/' + record.id;

    span = document.createElement('span');
    span.className = 'log-text';
    span.innerHTML = record.id + ' -- ' + record.severity;
    if (record.component) {
      span.innerHTML += ' -- ' + record.component;
    }
    span.innerHTML += ' -> ';
    form.appendChild(span);

    hiddenField = document.createElement('input');
    hiddenField.type = 'hidden';
    hiddenField.name = 'severity';
    hiddenField.value = record.severity;
    form.appendChild(hiddenField);

    if (record.component) {
      hiddenField = document.createElement('input');
      hiddenField.type = 'hidden';
      hiddenField.name = 'component';
      hiddenField.value = record.component;
      form.appendChild(hiddenField);
    }

    templateMessage = record.message_template;
    regex = new RegExp(`{[a-z0-9_]+}`, 'g');

    words = templateMessage.split(' ');
    elements = [];
    span = document.createElement('span');
    span.className = 'log-text';
    for (let i = 0; i < words.length; i ++) {
      word = words[i];
      if (word.search(regex) >= 0){
        // New span for next words
        elements.push(span);
        span = document.createElement('span');
        span.className = 'log-text';
        span.innerHTML = ' ';

        // Input
        inputName = word.replace('{', '');
        inputName = inputName.replace('}', '');
        variableInput = document.createElement('input');
        variableInput.type = 'text';
        variableInput.size = 10;
        variableInput.name = inputName;
        variableInput.className = 'template-input-box';
        variableInput.placeholder = inputName + ' ...';
        variableInput.addEventListener('input', inputAutoSize)
        elements.push(variableInput);

      } else {
        // Normal word
        span.innerHTML += word + ' ';
      }
    }

    if (span.innerHTML != '' && span.innerHTML != null) {
      elements.push(span);
    }

    // Append all created spans and variable inputs to form
    for (let i = 0; i < elements.length; i ++) {
      item = elements[i];
      form.appendChild(item);
    }

    pushButton = document.createElement('input');
    pushButton.className = 'action-button push';
    pushButton.type = 'submit';
    pushButton.value = 'Post';
    form.appendChild(pushButton);
    form.addEventListener('submit', logEntryTemplates.postAction);

    itemContainer.appendChild(form);

    removeLink = document.createElement('a');
    removeLink.className = 'action-link delete';
    removeLink.setAttribute('href', '/control/api/log-entry-templates/' + record.id);
    removeLink.innerHTML = 'Remove';
    removeLink.addEventListener('click', logEntryTemplates.removeAction);
    itemContainer.appendChild(removeLink);

    return itemContainer;
  },

  postAction: function(event) {
    event.preventDefault();
    formData = new FormData(this);
    data = {};
    for (const attr of formData.entries()) {
      data[attr[0]] = attr[1]
    }
    path = this.getAttribute('action');
    targetForm = this;
    apiPOST(path, data, function(data) {
      targetForm.reset();
      afterLogEntryPost()
    })
  },

  createAction: function(event) {
    logEntryTemplates.create();
    event.preventDefault();
  },

  removeAction: function(event) {
    event.preventDefault();
    targetElement = this.parentElement;
    path = this.getAttribute('href');
    apiDELETE(path, function(data) {
      flashMessage('LogEntryTemplate Removed!', 'notice');
      targetElement.remove();
    })
  }

}
