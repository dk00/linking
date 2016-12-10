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
  listeners.add update
  listeners.delete.bind listeners, update

!function notify listeners
  Array.from listeners.keys! .map (update) -> update!

function handle-change select, props
  if flat-diff @selected, next = select @store.getState!, props
    @selected = next
    @changed = true
  else notify @source.listeners

function chain create-store, select, merge, render
  if create-store
    componentWillMount: ->
      listeners = new Set
      @resolve = notify.bind void listeners
      @store = create-store @resolve
      @source = {@store, listeners}
  else
    componentWillMount: ->
      @store = @context.store
      @selected = select @store.getState!, @props
      @source = listeners: new Set
    componentDidMount: ->
      @off = onChange @context.listeners, ~>
        @setState empty if handle-change.call @, select, @props
    componentWillUnmount: -> @off!
  <<<
    display-name: "linking #{name render}: " + [select, merge]map name
    render: ->
      @changed = false
      render merge @selected, @store.dispatch, @props
    getChildContext: -> @source
    componentWillReceiveProps: (next-props) ->
      handle-change.call @, select, next-props
      @changed ||= merge.length > 2 && flat-diff next-props, @props
    shouldComponentUpdate: -> @changed

function link {createElement: h}: React
  do
    that = React.PropTypes.any
    all = store: that, listeners: that
    origin = childContextTypes: all
    sub = contextTypes: all, childContextTypes: listeners: that

  render, select, merge=default-merge, create-store, options <- (wrap =)

  types = if create-store then origin else sub
  linking = chain create-store, select, merge, render
  h.bind void React.createClass Object.assign {} types, linking

``export {link, link as default}``
