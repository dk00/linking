import
  redux: {create-store}
  \../src/linking : link-base
  preact: {Component, h: preact-create-element, render: preact-render}
  react
  \react-dom : reactDOM
  \create-react-class : create-class
  \prop-types : prop-types

h = react.create-element
link = link-base {create-element: h, create-class, prop-types}
function pass => it

sample-state = value: foo: \bar
sample-store = dispatch: pass, subscribe: pass, getState: -> sample-state

function reduce state={} {type, data} => switch type
  | \set => Object.assign {} state, (data.key): data.value
  | _ => state

function sample-render child, props
  store = create-store reduce, value: 'state value'

  new Promise (resolve, reject) ->
    function tail => h \div,, \tail
    function root => h \div,, (h child, props), tail!

    seed = link root
    app = h seed, {store}
    reactDOM.render app, document.create-element \div
    resolve!
  .then ->
    [1 3 7]reduce (previous, value) ->
      previous .then ->
        store.dispatch type: \set data: key: \count value: value
      .then -> new Promise (resolve) -> setTimeout resolve, 0
    , Promise.resolve!
    .then -> [store]

function add-context t
  desc = 'add the store to the child context'
  context-store = void
  function child _, context
    context-store := context.store
    h \div
  child.contextTypes = store: prop-types.any

  sample-render (-> h child) .then ([store]) ->
    t.equal context-store.getState, store.getState, desc

function pass-state t
  desc = 'pass state and props to the given render function'
  passed = void
  expected = 'state value, prop value'
  function child props
    passed := props?value
    h \div
  function select state, props
    return {} unless state.count > 0
    ('a' + state.count || 0): state.count
    value: [state.value, props.value]join ', '
  linked = link child, select

  sample-render linked, value: 'prop value' .then ->
    t.equal passed, expected, desc

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
    t.equal (Object.keys result .join ' '), expected, desc

function prop-changes t
  desc =\
  'invoke select every time props are changed  if it has a second argument'

  result = {}
  function child => h \div
  link-child = link child, (state, props) ->
    result[props.value] = true
    props.value % 4

  function pass-prop props
    h \div,, h link-child, props
  linked = link pass-prop, ({count}) -> value: (count || 0) + 1

  expected = '1 2 4 8'
  sample-render linked .then ->
    res = Object.keys result .join ' '
    t.equal res, expected, desc

function cut-select t
  desc =\
  'shallowly compare the selected state to prevent unnecessary updates'

  count = 0
  function child
    count++
    h \div
  lower = link child, ({count}) -> value: ((count || 0) + 1)%2

  function upper => h \div,, h lower
  linked = link upper, ({count}) -> value: count + 2

  sample-render linked .then -> t.equal count, 2 desc

function unmount-unsubscribe t
  desc = 'stop notifying unmounted components'

  last-value = 0
  function child => h \div
  link-child = link child, ->
    last-value := it.count
    value: (it.count || 0) + 1

  function wrap props
    h \div,, if props.value < 4 then h link-child
  linked = link wrap, -> value: it.count

  sample-render linked .then ->
    t.equal last-value, 3 desc

function ordered-notify t
  desc = 'notify higher hierarchy components prior to lower'

  sequence = []
  expected = 'higher lower 'repeat 4 .trim!
  function child => h \div
  function select which => ->
    sequence.push which
    value: (it.count <? 3) + which

  lower = link child, select \lower
  higher = link -> h \div,, h lower
  , select \higher

  sample-render higher .then ->
    t.equal (sequence.join ' '), expected, desc

function merge-props t
  desc = 'call props-dependent merge when props are changed'

  expected = '1 3'
  received = []
  function nested => h \div
  child = link nested, -> value: \fixed
  , (,, props) ->
    received.push that if props.value
    props

  function top => h \div,, h child, value: it.value % 4
  linked = link top, -> value: it.count
  sample-render linked .then ->
    t.equal (received.join ' '), expected, desc

function no-subscription t
  desc = 'handle link without select funciton specified'

  rendered = false
  nested = link ->
    rendered := true
    h \div
  ,, (,, props) -> props

  function render => h \div,, h nested, it
  linked = link render, -> value: it.count
  sample-render linked .then -> t.ok rendered, desc

function action-binder t
  reduce = (, action) ->
    if action.payload then action else \initial
  store = create-store reduce
  select = -> it
  touch-action = -> Promise.resolve type: \touch payload: true
  merge = (state, bind-action) ->
    on-click: bind-action type: \click payload: true
    on-touch-start: bind-action touch-action
    on-touch-move: bind-action ->

  component = -> h \p it
  app = link component, select, merge

  root = document.create-element \div
  document.body.append-child root
  reactDOM.render (h app, {store}), root
  target = root.query-selector \p

  window.onerror = ->
    t.fail 'ignote falsely values returned from create-action'

  Promise.resolve!then ->
    target.dispatch-event new window.Event \click bubbles: true
    actual = store.get-state!type
    expected = \click
    t.equal actual, expected, 'provide bind-action to merge function'

    target.dispatch-event new window.Event \touchstart bubbles: true
  .then ->
    actual = store.get-state!type
    expected = \touch
    t.equal actual, expected, 'bind-action should accept function and promise'
    target.dispatch-event new window.Event \touchmove bubbles: true
    window.onerror = void

function with-preact t
  link = link-base {Component, create-element: preact-create-element}
  actual = false
  linked = link ->
    actual := true
    h \div
  store = get-state: -> {}
  preact-render (preact-create-element linked, {store}), document.create-element \div
  t.ok actual, 'link with built-in create-class'

function test t
  cases =
    add-context, pass-state, listen-changes, prop-changes
    unmount-unsubscribe, cut-select, ordered-notify, merge-props
    no-subscription, action-binder, with-preact

  cases.reduce (previous, run) -> previous.then -> run t
  , Promise.resolve!
  .then -> t.end!
  .catch -> console.log it

export default: test
