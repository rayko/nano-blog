window.login = {

  formElement: function() {
    return document.getElementById('login-form');
  },

  authenticate: function() {
    formData = new FormData(login.formElement());
    data = { auth: btoa([formData.get('user'), formData.get('password')].join(':')) }
    path = login.formElement().getAttribute('action');
    apiPOST(path, data, login.success);
  },

  success: function(data) {
    localStorage.setItem('token', data.token);
    window.location = '/control';
  },

  currentToken: function() { localStorage.getItem('token'); },

  loggedIn: function() {
    token = login.currentToken();
    if (token == null || token == undefined || token == '') {
      localStorage.removeItem('token');
      window.location = '/control/login';
    } else { return true }
  },

  submitAction: function(event) {
    login.authenticate();
    event.preventDefault();
  }

}
