function componentsElement() {
  return document.getElementById('component-records');
}

function refreshComponents() {
  element = 
  path = componentsElement().getAttribute('data-path');
  apiGET(path, renderComponents, componentsRequestError)
}

function componentsRequestError(status) {
  alert(status);
}

function renderComponents(data) {
  componentsElement().innerHTML = '';
  for (let i = 0; i < data.length; i++){
    item = buildComponentItem(data[i]);
    componentsElement().appendChild(item);
  }
}

function buildComponentItem(record){
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
  removeLink.addEventListener('click', removeComponentAction);
  container.appendChild(removeLink);

  return container;
}

function removeComponentAction(event) {
  this.parentElement.remove();
  alert('Removed');
  event.preventDefault()
}
