/* global window, document */
var Main = require('./src/Main.purs');

// bootstrap application
if (module.hot) {
  var app = Main.debug(window.puxLastState || Main.initialState)();
  app.state.subscribe(function (state) {
    window.puxLastState = state;
  });
  module.hot.accept();
}
else {
  Main.debug(Main.initialState)();
}
