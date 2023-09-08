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

  logEntries.formElement().addEventListener('submit', logEntries.createAction)
  logEntries.refresh();

}

function isEmpty(thing) {
  if (thing == '') { return true; }
  if (thing == null) { return true; }
  if (thing == undefined) { return true; }
  if (thing.length == 0) { return true; }

  false;
}

function inputAutoSize(event) {
  minSize = 10;
  this.size = Math.max(this.value.length, minSize);
}

function afterLogEntryPost() {
  logEntries.refresh();
}
