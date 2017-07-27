import \./class-factory : class-factory

empty = {}
function name => it.display-name || it.name || it
function pass => it
function flat-diff a, b
  return false if a == b
  return true if typeof a != \object or typeof b != \object
  keys = Object.keys a
  return true if keys.length != Object.keys b .length
  keys.some -> a[it] != b[it]

function nested store
  listeners = new Set
  Object.assign {} store,
    subscribe: ->
      listeners.add it
      listeners.delete.bind listeners, it
    notify: -> Array.from listeners.keys! .map -> it!

!function init instance, select, merge, render
  store = instance.props.store || instance.context.store
  context = store: next = if select != pass then nested store else store
  selected = select store.get-state!, instance.props
  changed = false

  function handle-change props=instance.props
    prev = selected
    selected := select store.get-state!, props
    if flat-diff prev, selected then changed := true else next.notify!

  function bind-action create-action, props => (event) ->
    action = create-action? event, props or create-action
    action.then? store.dispatch or store.dispatch action

  handle-mount = if select != pass then component-did-mount: !->
    instance.component-will-unmount = store.subscribe ~>
      handle-change! && instance.set-state empty
  Object.assign instance, handle-mount,
    get-child-context: -> context
    component-will-receive-props: !->
      handle-change it if select != pass
      changed ||:= merge.length > 2 && flat-diff instance.props, it
    should-component-update: -> changed
    render: ->
      changed := false
      render merge selected, bind-action, instance.props

function chain select, merge, render
  display-name: name render
  component-will-mount: !-> init @, select, merge, render
  render: pass

function link {Component, prop-types, create-class=class-factory Component}
  types = if prop-types?any
    context-types = store: that
    {context-types, child-context-types: context-types}

  (render, select=pass, merge=pass) ->
    linking = chain select, merge, render
    create-class Object.assign {} types, linking

export {default: link, link}
