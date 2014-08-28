fs = require 'fs'
gulp = require 'gulp'
gutil = require 'gulp-util'
{exec} = require 'child_process'

gulp.task 'bump', (callback) ->

  version = ''

  _bump = (file) ->
    pkg = require file
    pkg.version = pkg.version.split('.')
      .map (n, i) -> if i is 2 then Number(n) + 1 else n
      .join '.'
    version = pkg.version
    fs.writeFileSync file, JSON.stringify(pkg, null, 2)

  _bump './bower.json'
  _bump './package.json'

  gutil.log "bump to version #{version}"

  exec """
  git add --all && git commit -am "#{version}" && git tag "v#{version}"
  """, callback

gulp.task 'default', ['bump'], ->
