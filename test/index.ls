delete require.extensions\.ls
require! \livescript-next : {parse} \babel-register : register

register babel-options =
  parser-opts: parser: parse
  presets: <[stage-0]>
  plugins: <[istanbul transform-es2015-modules-commonjs]>
  extensions: <[.ls]>

function setup
  require! jsdom: { JSDOM }
  {global.window} = new JSDOM '<!doctype html><html><body></body></html>'
  {global.document} = global.window
  {global.navigator} = global.window

units =
  \handle-actions : 'Handle Actions'
  linking: \Linking

if require.main == module
  setup!
  require! tape: {test}
  Object.keys units .for-each (name) ->
    test units[name], (require "./#name" .default)

