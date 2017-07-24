function identity => it
function class-factory component => (spec) ->
  ctor = identity ->
  ctor:: = Object.assign (Object.create component::), spec, constructor: ctor
  Object.assign ctor, {spec.display-name}

export default: class-factory
