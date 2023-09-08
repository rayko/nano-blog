window.addEventListener('load', initialize, false )

function initialize () {
  console.log('Admin Loaded!');
  templates = document.getElementsByClassName('template-item');
  for (let i = 0; i < templates.length; i ++) {
    buildTemplateForm(templates[i]);
  }

  components.formElement().addEventListener('submit', components.createAction);
  components.refresh();

  logEntryTemplates.formElement().addEventListener('submit', logEntryTemplates.createAction)
  logEntryTemplates.refresh();
}

function buildTemplateForm(element) {
  formPlaceholder = element.getElementsByClassName('template-form-container')[0];
  form = document.createElement('form');
  form.className = 'template-form';
  form.method = 'post';
  form.action = '/control/template-push';

  templateId = element.getAttribute('data-id');
  templateInput = document.createElement('input');
  templateInput.type = 'hidden';
  templateInput.name = 'template_id';
  templateInput.value = templateId;
  form.appendChild(templateInput);
  span = document.createElement('span');
  span.innerHTML = templateId + ' - ';
  form.appendChild(span);

  templateSeverity = element.getAttribute('data-severity');
  span = document.createElement('span');
  span.innerHTML = templateSeverity + ' - ';
  form.appendChild(span);

  templateComponent = element.getAttribute('data-component');
  if (templateComponent && templateComponent != '') {
    span = document.createElement('span');
    span.innerHTML = templateComponent + ' - ';
    form.appendChild(span);
  }

  templateMessage = element.getAttribute('data-template');
  regex = new RegExp(`{[a-z0-9_]+}`, 'g');

  words = templateMessage.split(' ');
  elements = [];
  span = document.createElement('span');
  for (let i = 0; i < words.length; i ++) {
    word = words[i];
    if (word.search(regex) >= 0){
      // New span for next words
      elements.push(span);
      span = document.createElement('span');
      span.innerHTML = ' ';

      // Input
      inputName = word.replace('{', '');
      inputName = inputName.replace('}', '');
      variableInput = document.createElement('input');
      variableInput.type = 'text';
      variableInput.name = inputName;
      variableInput.className = 'template-input-box';
      variableInput.placeholder = inputName + ' ...';
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

  // Insert the form into the dedicated span
  formPlaceholder.appendChild(form);

  // Add click action to link
  link = element.getElementsByClassName('push-form-template')[0];
  link.addEventListener("click", (event) => {
    targetForm = event.target.parentElement.getElementsByClassName('template-form')[0]
    targetForm.submit();
    event.preventDefault();
    targetForm.reset();
  })
}

function isEmpty(thing) {
  if (thing == '') { return true; }
  if (thing == null) { return true; }
  if (thing == undefined) { return true; }
  if (thing.length == 0) { return true; }

  false;
}

function pushTemplate(link) {
  form = link.parentElement.getElementsByClassName('template-form');
  
}
