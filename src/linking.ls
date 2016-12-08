empty = {}
function default-merge => it
function flat-diff a, b
  return false if a == b
  return true if typeof a != \object or typeof b != \object
  keys = Object.keys a
  return true if keys.length != Object.keys b .length
  keys.some -> a[it] != b[it]
function name => (it && (it.display-name || it.name || 'no name')) || \none

function onChange listeners, update
  level = listeners
    ..add update
  level.delete.bind level, update

function notify listeners
  Array.from listeners.keys! .map (update) ->
    update! if listeners.has update

function select-next select, props, hold
  if flat-diff @selected, next = select @store.getState!, props
    @selected = next
    @changed = true
    @setState empty unless hold
    true

function chain create-store, select, merge, render
  hooks = if create-store
    componentWillMount: ->
      listeners = new Set
      @resolve = notify.bind void listeners
      @store = create-store @resolve
      @source = {@store, listeners}
    getChildContext: -> @source
  else
    componentWillMount: ->
      @store = @context.store
      @selected = select @store.getState!, @props
    componentDidMount: ->
      @off = onChange @context.listeners, ~>
        select-next.call @, select, @props
    componentWillUnmount: -> @off!
  <<<
    display-name: "linking #{name render}: " + [select, merge]map name
    render: ->
      @changed = false
      render merge @selected, @store.dispatch, @props

  if select?length > 1
    hooks.componentWillReceiveProps = ->
      select-next.call @, select, it, true
    hooks.shouldComponentUpdate = -> @changed
  hooks

function link {createElement: h}: React
  do
    that = React.PropTypes.any
    all = store: that, listeners: that
    origin = childContextTypes: all
    sub = contextTypes: all

  render, select, merge=default-merge, create-store, options <- (wrap =)

  types = if create-store then origin else sub
  linking = chain create-store, select, merge, render
  h.bind void React.createClass Object.assign {} types, linking

``export {link, link as default}``
