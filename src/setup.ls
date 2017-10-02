import redux : {create-store}

function setup {
  compose-reduce, Component, h, render
  link-factory, side-effect-factory
}
  link = link-factory {Component}
  link: link, side-effect: side-effect-factory Component
  start-app: ({reducers, preload, component, env=window, el='#root'}) ->
    state = preload? env or preload
    store = create-store (compose-reduce reducers),
      state, env?__REDUX_DEVTOOLS_EXTENSION__?!
    container = env?document.query-selector el
    root = container.first-element-child

    if typeof module != \undefined && module.hot
      replace-app = !-> root := render (h (link it), {store}), container, root
      replace-app component
      Object.assign {} store, {replace-app} replace-reducer: ->
        store.replace-reducer compose-reduce it
    else
      render (h (link component), {store}), container, root
      store

export default: setup
