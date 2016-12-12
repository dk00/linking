empty = {}
function pass => it
function flat-diff a, b
  return false if a == b
  return true if typeof a != \object or typeof b != \object
  keys = Object.keys a
  return true if keys.length != Object.keys b .length
  keys.some -> a[it] != b[it]
function name => it && (it.display-name || it.name || 'no name')

!function notify listeners
  Array.from listeners.keys! .map (update) -> update!

function handle-change select, props
  if flat-diff @selected, next = select @store.getState!, props
    @selected = next
    @changed = true
  else notify @source.store.listeners

function mount select, create-store
  listeners = new Set
  function subscribe update
    listeners.add update
    listeners.delete.bind listeners, update
  @store = (create-store? ->) or @context.store
  @source = store: Object.assign {} @store, {subscribe, listeners}
  @selected = select @store.getState!, @props

function chain create-store, select, merge, render
  if create-store || select != pass
    componentWillMount: -> mount.call @, select, create-store
    componentDidMount: ->
      @off = @store.subscribe ~>
        @setState empty if handle-change.call @, select, @props
    componentWillUnmount: -> @off!
  else
    componentWillMount: ->
      @store = @context.store
      @selected = @store.getState!
  <<<
    display-name: "linking #{name render}: " + [select, merge]map name
    render: ->
      @changed = false
      render merge @selected, @store.dispatch, @props
    getChildContext: if create-store || select != pass then -> @source
    componentWillReceiveProps: (next-props) ->
      handle-change.call @, select, next-props if select != pass
      @changed ||= merge.length > 2 && flat-diff next-props, @props
    shouldComponentUpdate: -> @changed

function link {createElement: h}: React
  do
    that = React.PropTypes.any
    context-types = store: that
    origin = childContextTypes: context-types
  function nested
    contextTypes: context-types, childContextTypes: if it.getChildContext
      context-types

  render, select=pass, merge=pass, create-store, options <- (wrap =)
  h.bind void if select == pass && !create-store && merge.length < 3
    (props, {store}) ->
      render merge store.getState!, store.dispatch, props
    <<< contextTypes: context-types, display-name: render.name
  else
    linking = chain create-store, select, merge, render
    types = if create-store then origin else nested linking
    React.createClass Object.assign {} types, linking

``export {link, link as default}``
