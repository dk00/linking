require! gulp
require! fs : {writeFileSync} rollup: {rollup} \./rollup.config : config
output-path = \dist

#Remove sourcesContent to prevent remap messing up paths
#And add the missing file name
function fix-map map, dest
  (map <<< sourcesContent: void file: dest.split \/ .[*-1])toString!

function build {dest}: target
  rollup config .then (bundle) ->
    bundle.write Object.assign {} config, target .then -> bundle
  .then ->
    {map} = it.generate Object.assign {} config, target
    writeFileSync dest + \.map fix-map that, dest if map
  .catch ->
    return Promise.reject that if it.message
    it

gulp.task \dist ->
  name = config.module-name
  targets =
    * dest: "dist/#name.js" format: \umd source-map: true
    * dest: "dist/#name.cjs.js" format: \cjs source-map: true
    * dest: "es/#name.js"
  Promise.all targets.map build

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
