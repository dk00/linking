require! path: {relative} livescript: {compile}

function transform code, name
  return unless /\.ls$/test name
  options = bare: true map: \linked filename: relative __dirname, name
  {code, map} = compile code, options
  {code, map: JSON.parse map.toString!}

export
  entry: \src/linking.ls
  plugins: [{transform}]
  moduleName: require \./package.json .name
  exports: \named
  use-strict: false
