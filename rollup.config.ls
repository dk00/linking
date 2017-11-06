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
    output:
      * file: "preact/index.esm.js" format: \es
      * file: "preact/index.js" format: \cjs exports: \named
  * input: \src/preact-browser.ls
    output: file: "dist/preact.js" format: \umd exports: \named
    external: []

target-list = targets.map -> Object.assign {} default-options, it

export default: target-list
