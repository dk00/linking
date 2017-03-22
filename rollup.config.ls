require! {
  \rollup-plugin-babel : babel
  \rollup-plugin-node-resolve : node-resolve }

babel-options =
  presets: <[stage-0]>
  parser-opts: parser: \livescript-next

resolve = node-resolve extensions: <[.ls]>

export
  entry: \src/index.ls
  plugins: [resolve, babel babel-options]
  module-name: require \./package.json .name
  exports: \named
  use-strict: false
