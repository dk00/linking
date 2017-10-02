import
  redux : {create-store}
  preact : {h, Component}
  linking: link-factory
  \./compose-reduce : compose-reduce

link = link-factory {Component}

function render-vdom {reducers, preload, component}
  state = preload {} or preload
  store = create-store (compose-reduce reducers), state
  h (link component), {store}

export {default: render-vdom, render-vdom}
