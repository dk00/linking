require! <[react redux]>
require! \react-dom : reactDOM, \../dist/linking.cjs : {link: link-base}
{createElement: h} = react

function link => (link-base react) ...
function pass => it

function render-with root, store
  render = link root,,, (onChange) ->
    store.subscribe onChange
    store

sample-state = value: foo: \bar
sample-store = dispatch: pass, subscribe: pass, getState: -> sample-state

function reduce state={} {type, data} => switch type
  | \set => Object.assign {} state, (data.key): data.value
  | _ => state

function sample-render child, props
  store = void
  function create-store onChange
    store := redux.createStore reduce, value: 'state value'
    store.subscribe onChange
    store

  new Promise (resolve) ->
    function tail
      resolve!
      h \div,, \tail
    function root => h \div,, (child props), tail!

    render = link root,,, create-store
    reactDOM.render render!, document.createElement \div
  .then ->
    [1 3 7]forEach ->
      store.dispatch type: \set data: key: \count value: it
    [store]

function add-context t
  desc = 'add the store to the child context'
  context-store = void
  function child _, context
    context-store := context.store
    h \div
  child.contextTypes = store: react.PropTypes.any

  sample-render (-> h child) .then ([store]) ->
    t.equal context-store, store, desc
    t

function pass-state t
  desc = 'pass state and props to the given render function'
  passed = void
  expected = 'state value, prop value'
  function child props
    passed := props?value
    h \div
  function select state, props
    return unless state.count > 0
    [to state.count || 0]reduce (res, i) -> res <<< ('a' + i): i
    , value: [state.value, props.value]join ', '
  linked = link child, select

  sample-render linked, value: 'prop value' .then ->
    t.equal passed, expected, desc
    t

function listen-changes t
  desc = 'subscribe pure function components to the store changes'
  expected = '0 1 3 7'
  result = {}

  function child {value}
    result[value] = true
    h \div
  function select => value: it.count || 0
  linked = link child, select

  sample-render linked .then ->
    res = Object.keys result .join ' '
    t.equal res, expected, desc
    t

function prop-changes t
  desc =\
  'invoke select every time props are changed  if it has a second argument'

  result = {}
  function child => h \div
  link-child = link child, (state, props) ->
    result[props.value] = true
    props.value % 4

  function pass-prop props
    h \div,, link-child props
  linked = link pass-prop, ({count}) -> value: (count || 0) + 1

  expected = '1 2 4 8'
  sample-render linked .then ->
    res = Object.keys result .join ' '
    t.equal res, expected, desc
    t

function cut-select t
  desc =\
  'shallowly compare the selected state to prevent unnecessary updates'

  count = 0
  function child
    count++
    h \div
  linked = link child, ({count}) -> value: ((count || 0) + 1)%2

  sample-render linked .then ->
    t.equal count, 2 desc
    t

function unmount-unsubscribe t
  desc = 'stop notifying unmounted components'

  last-value = 0
  function child => h \div
  link-child = link child, ->
    last-value := it.count
    value: (it.count || 0) + 1

  function wrap props
    h \div,, if props.value < 4 then link-child!
  linked = link wrap, -> value: it.count

  sample-render linked .then ->
    t.equal last-value, 3 desc
    t

function test t
  add-context t .then pass-state .then listen-changes .then prop-changes
  .then cut-select .then unmount-unsubscribe
  .then -> t.end!
  .catch -> console.log it

if require.main == module
  require \./index .setup!
  require \tape .test \Linking test

module.exports = test
