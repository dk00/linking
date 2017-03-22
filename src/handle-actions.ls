function handle-actions handlers, default-state={}
  (state, {type, payload}) ->
    if handlers[type]? state, payload then Object.assign {} state, that
    else state || default-state

export default: handle-actions
