# Linking

Work in progress

Alternative Redux bindings for React.

[![build status](https://travis-ci.org/dk00/linking.svg)](https://travis-ci.org/dk00/linking)
[![coverage](https://codecov.io/gh/dk00/linking/branch/master/graph/badge.svg)](https://codecov.io/gh/dk00/linking)


## API

### `link(React)`: `(render[, select][, merge][, createStore]) => linkedRender`

Link a render function to a store. Return a linked render function.

#### Arguments

- `createStore(onChange): store`: `onChange` should be called on store state change.
  Returned store is available to linked render functions in the component hierarchy below.

- `select(state[, ownProps]): selectedProps`: Called when store state changes.
  Re-rendering is skipped if result of this function is shallowly equal to previous.
  Omit this argument to ignore store updates.
  Defaults to `() => undefined`.

- `merge(selectedProps, dispatch[, ownProps]): props`
  Defaults to `selectedProps => selectedProps`.

- `render(props)`: accepts a single "props" object argument with data
  and returns a `React` element.

- `React`: `{createClass, createElement[, PropTypes]}`


#### Examples

##### implement `connect` and `Provider` of react-redux

```js
import {link} from 'linking'

function Provider({store, children}) {
  const element = react.Children.only(children)
  function seed() {
    return element
  }
  const render = link(react)(seed, void 8, void 8, onChange => {
    store.subscribe(onChange)
    return store
  })
  return render()
}

function defaultDispatch(dispatch) {
  return {dispatch}
}
function defaultMerge(state, actions, props) {
  return Object.assign({}, props, state, actions)
}
function mapDispatch(mapDispatchToProps, dispatch, ownProps) {
  if (typeof mapDispatchToProps == 'function') {
    return mapDispatchToProps(dispatch, ownProps)
  }
  return bindActionCreators(mapDispatchToProps, dispatch)
}

function connect(mapStateToProps,
  mapDispatchToProps=defaultDispatch,
  mergeProps=defaultMerge) {
  function merge(stateProps, dispatch, ownProps) {
    const actions = mapDispatch(mapDispatchToProps, dispatch, ownProps)
    return mergeProps(stateProps, actions, ownProps)
  }
  return Component => {
    const render = link(react)(
      props => h(Component, props),
      mapStateToProps, merge)
    return props => render(props)
  }
}

export {Provider, connect}
```

##### Inject store for child elements

```js
function createStore(onChange) {
  const store = Redux.createStore(reduce)
  const unsubscribe = store.subscribe(onChange)
}

link(React)(renderRoot, null, null, createStore)
```

##### Inject dispatch and todos

```js
function mapStateToProps(state) {
  return { todos: state.todos }
}

function merge(state, dispatch) {
  return Object.assign({dispatch}, state)
}

export default link(React)(mapStateToProps, merge)(todoApp)
```

## License

MIT
