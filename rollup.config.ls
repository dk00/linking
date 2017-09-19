import
  \rollup-plugin-babel : babel
  \rollup-plugin-node-resolve : node-resolve

{name} = require \./package.json
options =
  input: \src/index.ls
  plugins:
    node-resolve extensions: <[.ls]>
    babel require \./.babelrc
  name: name
  exports: \named sourcemap: true use-strict: false
  output:
    * file: "es/#name.js" format: \es
    * file: "dist/#name.js" format: \umd
    * file: "lib/#name.js" format: \cjs

export default: options
