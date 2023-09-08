function apiGET(path, onSuccess, onError) {
  requestConfig = {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  }

  fetch(path, requestConfig).then(function (response) {
    if (response.ok) {
      return response.json();
    } else {
      if (onError) { return onError(response.status) }
      return flashMessage("Error Status " + response.status, 'alert')
    }
  }).then(function (data) {
    if (data) { onSuccess(data); }
  })
}

function apiDELETE(path, onSuccess, onError) {
  requestConfig = {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json'
    }
  }

  fetch(path, requestConfig).then(function (response) {
    if (response.ok) {
      return response.json();
    } else {
      if (onError) { return onError(response.status) }
      return flashMessage("Error Status " + response.status, 'alert')
    }
  }).then(function (data) {
    if (data) { onSuccess(data); }
  })
}

function apiPOST(path, data, onSuccess, onError) {
  requestConfig = {
    method: 'POST',
    body: JSON.stringify(data),
    headers: {
      'Content-Type': 'application/json'
    }
  }

  fetch(path, requestConfig).then(function (response) {
    if (response.ok) {
      return response.json();
    } else {
      if (onError) { return onError(response.status) }
      return flashMessage("Error Status " + response.status, 'alert')
    }
  }).then(function (data) {
    if (data) { onSuccess(data); }
  })
}
