delete require.extensions\.ls
require! \livescript-next : {parse} \babel-register : register

register babel-options =
  parser-opts: parser: parse
  presets: <[stage-0]>
  plugins: <[istanbul transform-es2015-modules-commonjs]>
  extensions: <[.ls]>

function setup
  require! jsdom: { jsdom }
  global.document = jsdom '<!doctype html><html><body></body></html>'
  global.window = document.defaultView
  global.navigator = global.window.navigator

if require.main == module
  setup!
  require! tape: {test}
  test \Linking (require \./linking .default)
