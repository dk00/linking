require! \rollup-plugin-babel : babel, \livescript-next : {parse}

babel-options =
  presets: <[stage-0]>
  parser-opts: parser: parse

export
  entry: \src/linking.ls
  plugins: [babel babel-options]
  module-name: require \./package.json .name
  exports: \named
  use-strict: false
