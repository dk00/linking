import
  \rollup-plugin-babel : babel
  \rollup-plugin-node-resolve : node-resolve

{name} = require \./package.json
default-options =
  plugins:
    node-resolve jsnext: true extensions: <[.ls .js]>
    babel require \./.babelrc
  name: name
  exports: \named sourcemap: true use-strict: false
  external: <[redux preact linking]>

targets =
  * input: \src/index.ls
    output:
      * file: "dist/#name.esm.js" format: \es
      * file: "dist/#name.js" format: \umd
  * input: \src/preact.ls
    output: file: "preact.js" format: \es
  * input: \src/preact-browser.ls
    output: file: "preact.umd.js" format: \umd exports: \named
    external: []
  * input: \src/preact-node.ls
    output: file: "preact/index.js" format: \cjs exports: \named

target-list = targets.map -> Object.assign {} default-options, it

export default: target-list
