import
  redux: {create-store, combine-reducers}
  preact: {h, Component, render}
  linking: default: link-factory, side-effect: side-effect-factory
  \./compose-reduce : compose-reduce
  \./setup : setup

{link, start-app, side-effect} = setup {
  compose-reduce, h, Component, render
  link-factory, side-effect-factory
}

function render-vdom {reducers, preload, component}
  state = preload {} or preload
  store = create-store (compose-reduce reducers), state
  h (link component), {store}

export
  default: link, link-start: start-app
  {start-app, link, h, side-effect, render-vdom}
