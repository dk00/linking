import
  \rollup-plugin-babel : babel
  \rollup-plugin-node-resolve : node-resolve

{name} = require \./package.json
options =
  entry: \src/index.ls
  plugins:
    node-resolve extensions: <[.ls]>
    babel require \./.babelrc
  module-name: name
  exports: \named source-map: true use-strict: false
  targets:
    * dest: "es/#name.js"
    * dest: "dist/#name.js" format: \umd
    * dest: "lib/#name.js" format: \cjs

export default: options
