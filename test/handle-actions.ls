import \../src/handle-actions : handle-actions

function main t
  init = {}
  updaters =
    increase: ({count} payload) -> count: count + payload
    reset: -> count: 0
    nop: -> null
  reduce = handle-actions updaters, init

  actual = reduce {count: 0} type: \increase payload: 3
  expected = count: 3
  t.deep-equal actual, expected, 'use updater with key equal to action type'

  actual = reduce {count: 0 test: 7} type: \increase payload: 5
  expected  = count: 5 test:7
  t.deep-equal actual, expected,
  'result of updaters is merged into current state'

  expected = {}
  actual = reduce expected, type: \other payload: 3
  t.equal actual, expected, 'return current state if no updater for the action'

  expected = {}
  actual = reduce expected, type: \nop
  t.equal actual, expected,
  'return current state if the updater returns a falsly value'

  actual = reduce void type: \init
  expected = init
  t.equal actual, expected, 'return default state at the beginning'

  actual = (handle-actions updaters) void type: \init
  t.ok actual, 'have default state'

  t.end!

export default: main
