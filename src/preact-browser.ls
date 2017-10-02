import
  redux: {combine-reducers}
  preact : {h, Component, render}
  \./handle-actions : handle-actions
  \./linking : link-factory
  \./side-effect : side-effect-factory
  \./setup : setup

function compose-reduce reducers
  wrapped = Object.entries reducers .map ([key, reducer]) ->
    (key): if typeof reducer == \function then reducer
    else handle-actions reducer
  combine-reducers Object.assign ...wrapped

{link, start-app, side-effect} = setup {
  compose-reduce, h, Component, render
  link-factory, side-effect-factory
}

export {start-app, link-start: start-app, default: link, link, h, side-effect}
