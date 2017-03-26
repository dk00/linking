function class-creator Component => (proto) ->
  function ctor =>
  properties = Object.keys proto .map (key) ->
    (key): {value: proto[key], +writable, +configurable}
  ctor:: = Object.create Component::,
    Object.assign constructor: ctor, ...properties
  ctor

export default: class-creator
