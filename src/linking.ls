empty = {}
function default-merge => it

function onChange listeners, update
  level = listeners
    ..add update
  level.delete.bind level, update

function notify listeners
  Array.from listeners.keys! .map (update) ->
    update!

function select-next select, props, hold
  do
    next = select @store.getState!, props
    @selected = next
    @changed = true
    @setState empty unless hold

function chain create-store, select, merge, render
  hooks = render: ->
    @changed = false
    render merge @selected, @store.dispatch, @props
  if create-store
    hooks.componentWillMount = ->
      listeners = new Set
      @resolve = notify.bind void listeners
      @store = create-store @resolve
      @source = {@store, listeners}
  else
    hooks.componentWillMount = ->
      @store = @context.store
      @selected = select @store.getState!, @props
    hooks.componentDidMount = ->
      @off = onChange @context.listeners, ~>
        select-next.call @, select, @props
  do
    hooks.getChildContext = -> @source

  if select?length > 1
    hooks.componentWillReceiveProps = ->
      select-next.call @, select, it, true
    hooks.shouldComponentUpdate = -> @changed
  hooks

function context-types {any}
  types = store: any, listeners: any
  contextTypes: types, childContextTypes: types

function link {createElement: h}: React
  types = context-types React.PropTypes
  render, select, merge=default-merge, create-store, options <- (wrap =)
  do
    return h.bind void React.createClass Object.assign {} types,\
    chain create-store, select, merge, render

``export {link, link as default}``
