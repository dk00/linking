# Linking

Work in progress

Alternative Redux bindings for React.

[![build status](https://travis-ci.org/dk00/linking.svg)](https://travis-ci.org/dk00/linking)
[![coverage](https://codecov.io/gh/dk00/linking/branch/master/graph/badge.svg)](https://codecov.io/gh/dk00/linking)
[![npm](https://img.shields.io/npm/v/linking.svg)](https://www.npmjs.com/package/linking)
[![dependencies](https://david-dm.org/dk00/linking/status.svg)](https://david-dm.org/dk00/linking)

## API

### `link(React)`: `(render[, select][, merge]) => linkedRender`

Link a render function to a store. Return a linked render function.
`props.store` will be used if `store` is passed to the returned function, other components use the store provided by their ancestor.

#### Arguments

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
  const render = link(react)(seed)
  return render({store})
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
const root = link(React)(renderRoot)
ReactDOM.render(root({store}), document.querySelector('#root'))
```

##### Inject dispatch and todos

```js
function mapStateToProps(state) {
  return { todos: state.todos }
}

function merge(state, dispatch) {
  return Object.assign({dispatch}, state)
}

export default link(React)(todoApp, mapStateToProps, merge)
```
