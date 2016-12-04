function setup
  require! jsdom: { jsdom }
  global.document = jsdom '<!doctype html><html><body></body></html>'
  global.window = document.defaultView
  global.navigator = global.window.navigator

if require.main == module
  setup!
  require! tape: {test}
  test \Linking require \./linking
