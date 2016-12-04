require! <[react redux]>
require! \react-dom : reactDOM, \../dist/linking.cjs : {link: link-base}
{createElement: h} = react

function link => (link-base react) ...
function pass => it

function render-with root, store
  render = link root,,, (onChange) ->
    store.subscribe onChange
    store
  reactDOM.render render!, document.createElement \div

sample-state = value: foo: \bar
sample-store = dispatch: pass, subscribe: pass, getState: -> sample-state

function add-context t
  desc = 'add the store to the child context'
  new Promise (resolve) ->
    function wrap => h \div,, h child
    function child _, context
      t.equal context.store, sample-store, desc
      resolve t
      null
    child.contextTypes = store: react.PropTypes.any
    render-with wrap, sample-store

function pass-state t
  desc = 'pass state and props to the given render function'
  function select => value: it.value

  new Promise (resolve) ->
    function child {value}
      t.equal value, (select sample-state .value), desc
      resolve t
      h \div,, value
    linked = link child, select
    function app
      linked!
    render-with app, sample-store

function listen-changes t
  desc = 'subscribe pure function components to the store changes'
  expected = [0 1 7]
  function reduce state=0 {type, data}
    if type == \inc then state + data else state

  store = redux.createStore reduce
  function select => value: it
  result = []

  Promise.resolve!then ->
    store.dispatch type: \inc data: 1
    store.dispatch type: \inc data: 6

  new Promise (resolve) ->
    function child {value}
      result.push value
      if result.length == 3
        t.equal (result.join ' '), (expected.join ' '), desc
        resolve t
      h \div,, value
    linked = link child, select

    function app
      linked!
    render-with app, store

function test t
  add-context t .then pass-state .then listen-changes .then -> t.end!
  .catch -> console.log it

if require.main == module
  require \./index .setup!
  require \tape .test \Linking test

module.exports = test
