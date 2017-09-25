require \../register <| plugins: <[istanbul]>

units =
  \handle-actions : 'Handle actions'
  linking: \Linking
  \side-effect : 'Side effect component factory'

if require.main == module
  require \./setup
  require! tape: {test}
  list = if process.argv.2 then that.split ' ' else  Object.keys units
  list.for-each (name) ->
    test units[name] || name, (require "./#name" .default)
