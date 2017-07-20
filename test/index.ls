require \../register <| plugins: <[istanbul]>

function setup
  require! jsdom: { JSDOM }
  {global.window} = new JSDOM '<!doctype html><html><body></body></html>'
  global{document, navigator} = global.window

units =
  \handle-actions : 'Handle Actions'
  linking: \Linking

if require.main == module
  setup!
  require! tape: {test}
  Object.keys units .for-each (name) ->
    test units[name], (require "./#name" .default)
