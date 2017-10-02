import
  redux: {combine-reducers}
  linking: {handle-actions}

function compose-reduce reducers
  wrapped = Object.entries reducers .map ([key, reducer]) ->
    (key): if typeof reducer == \function then reducer
    else handle-actions reducer
  combine-reducers Object.assign ...wrapped

export default: compose-reduce
