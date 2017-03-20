require! gulp
require! rollup: {rollup} \./rollup.config : config

function build targets
  rollup config .then (bundle) ->
    Promise.all targets.map ->
      bundle.write {} <<< config <<< it

gulp.task \dist ->
  name = config.module-name
  build targets =
    * dest: "dist/#name.js" format: \umd
    * dest: "lib/#name.js" format: \cjs
    * dest: "es/#name.js"

gulp.task \default <[coverage]>
