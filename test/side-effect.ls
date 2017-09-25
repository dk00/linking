import
  \../src/side-effect : side-effect
  \../src/class-factory : class-factory
  react
  \react-dom : react-dom

h = react.create-element
create-class = class-factory react.Component

function mount component
  element = document.create-element \div
  react-dom.render component, element
  document.body.append-child element
  element

function main t
  external = void
  set-external = -> external := it.map (.value) .join ' '
  effect-component = (side-effect react.Component) set-external

  phases = <[mount change change]>
  next = ({count}) -> count: count + 1
  wrap = create-class do
    component-will-mount: -> @set-state count: 0
    render: ->
      on-click = ~> @set-state next
      h \p {on-click} if phases[@state.count]
        h effect-component, value: that
      else ''
  target = mount h wrap .query-selector \p

  actual = external
  expected = \mount
  t.is actual, expected, 'emit side effects when mounting'

  target.dispatch-event new window.Event \click bubbles: true

  actual = external
  expected = \change
  t.is actual, expected, 'emit side effects when updating'

  external := \keep
  target.dispatch-event new window.Event \click bubbles: true

  actual = external
  expected = \keep
  t.is actual, expected, 'recompute only when component updates'

  target.dispatch-event new window.Event \click bubbles: true

  actual = external
  expected = ''
  t.is actual, expected, 'remove instances when unmounting'

  t.end!

export default: main
