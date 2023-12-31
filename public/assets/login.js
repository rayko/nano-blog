window.login = {

  formElement: function() {
    return document.getElementById('login-form');
  },

  authenticate: function() {
    formData = new FormData(login.formElement());
    data = { auth: btoa([formData.get('user'), formData.get('password')].join(':')) }
    path = login.formElement().getAttribute('action');
    apiAUTH(path, data, login.success, login.handleLoginError);
  },

  handleLoginError: function(data) {
    login.formElement().reset();
    genericAPIErrorHandler(data);
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
