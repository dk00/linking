require! gulp
output-path = \dist

gulp.task \dist ->
  require! fs : {writeFileSync} rollup: {rollup} \./rollup.config : config
  name = "dist/#{config.module-name}"
  targets =
    * dest: "#name.js" format: \umd source-map: true
    * dest: "#name.cjs.js" format: \cjs source-map: true
    * dest: "#name.es.js"

  Promise.all targets.map ({dest}: target) ->
    rollup Object.assign config .then (bundle) ->
      bundle.write Object.assign {} target, config .then -> bundle
    .then ->
      {map} = it.generate Object.assign {} target, config
      writeFileSync dest + \.map
      #Remove sourcesContent to prevent remap messing up paths
      #And add the missing file name
      , (that <<< sourcesContent: void file: dest.split \/ .[*-1])toString! if map
    .catch ->
      return Promise.reject that if it.message
      it

gulp.task \coverage <[dist]> ->
  require! \child_process : spawnSync: spawn
  require! \remap-istanbul : remap
  {status} = spawn \./node_modules/.bin/istanbul <[cover lsc test/index]> stdio: \inherit
  throw \test if status != 0

  console.info 'Remap coverage files'
  remap \coverage/coverage.json output =
    json: \coverage/coverage.json
    lcovonly: \coverage/lcov.info
    html: \coverage/lcov-report

gulp.task \default <[coverage]>
