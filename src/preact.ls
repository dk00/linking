import
  redux: {combine-reducers}
  preact: {h, Component, render}
  linking: default: link-factory, side-effect: side-effect-factory
  \./compose-reduce : compose-reduce
  \./setup : setup

{link, start-app, side-effect} = setup {
  compose-reduce, h, Component, render
  link-factory, side-effect-factory
}

export {start-app, link-start: start-app, default: link, link, h, side-effect}
