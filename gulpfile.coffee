
### =======================================
## Build Script
## Originally created by Sayem Shafayet
## extended by ParticleIT
======================================= ###

gulp = require('gulp')
gutil = require('gulp-util')
uglify = require('gulp-uglify')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
sourcemaps = require('gulp-sourcemaps')
webserver = require('gulp-webserver')
runSequence = require('run-sequence')
del = require('del')
rename = require("gulp-rename")
htmlreplace = require('gulp-html-replace')
pathlib = require 'path'
modify = require('gulp-modify')
cache = require('gulp-cached')
os = require('os')
fs = require('fs')
plumber = require('gulp-plumber')
PolymerProject = require('polymer-build').PolymerProject
addServiceWorker = require('polymer-build').addServiceWorker
mergeStream = require('merge-stream')
glob = require('glob')
notify = require("gulp-notify")
javascriptObfuscator = require('gulp-javascript-obfuscator')

{
  incrementVersionWeb,
  concatWeb,
  htmlReplaceWeb,
  buildCoffeeWeb,
  polymerBuildWeb } = require('./gulp-build')

{
  buildOnsite,
  incrementVersionOnsite,
  concatOnsite,
  htmlReplaceOnsite,
  buildCoffeeOnsite,
  polymerBuildOnsite } = require('./gulp-build-onsite')

###
  The debug build process - 
    1. delete the build-debug directory
    2. copy all contents from src to build-debug
    3. in the [ '/assets', '/elements', '/', 'vendor-assets' ] directories under 'build-debug': 
      a) compile all *.coffee files and generate source maps
    4. keep watch and redo the tasks as necessary
###

paths = 
  src:
    all: [ 'src/**' ]
    allButBower: [ 'src/**', '!src/bower-assets/**']
  debug:
    root: 'build-debug'
    coffee: [
      'build-debug/assets/*.coffee'
      # '.build-debug/static-data/*.coffee'
      'build-debug/behaviors/*.coffee'
      'build-debug/vendor-assets/*.coffee'
      'build-debug/elements/*/*.coffee'
    ]


gulp.task 'clean-debug', ->
  return del paths.debug.root

gulp.task 'copy-debug', ->
  return gulp.src paths.src.all
  .pipe gulp.dest paths.debug.root

gulp.task 'copy-debug-watch', ->
  return gulp.src paths.src.allButBower
  .pipe cache 'copy'
  .pipe gulp.dest paths.debug.root

gulp.task 'build-debug-coffee-dev', ->
  return gulp.src paths.debug.coffee
  .pipe(plumber({errorHandler: notify.onError("Error: <%= error %>")}))
  .pipe cache 'copy'
  .pipe(sourcemaps.init())
  .pipe(coffee({bare: false}))
  .pipe(sourcemaps.write('.'))
  .pipe rename (path)->
    if path.extname is '.map'
      path.basename = path.basename.replace '.js', '.coffee-compiled.js'
    else if path.extname is '.js'
      path.basename = path.basename += '.coffee-compiled'
    else
      throw new Error 'Unknown Error 1'
    return path
  .pipe modify {
    fileModifier: (vfd, contents)->
      if (''+vfd.path).indexOf('.js.map') > -1
        json = JSON.parse contents
        json.file = json.file.replace '.js', '.coffee-compiled.js'
        contents = JSON.stringify json
      else if (''+vfd.path).indexOf('.js') > -1
        index = contents.indexOf 'sourceMappingURL='
        contents = contents.substr 0, (index + ('sourceMappingURL='.length))
        contents += pathlib.basename(vfd.path)+'.map'
      return contents
  }
  .pipe gulp.dest (vfd)->
    dirname = (pathlib.dirname vfd.path)
    sep = (if os.platform() is 'win32' then '\\' else '/')
    if dirname.indexOf('elements'+ sep) > -1
      dirname = dirname.split sep
      dirname.pop()
      dirname = dirname.join sep
    return dirname

gulp.task 'build-debug-dev', (cbfn)->
  runSequence 'clean-debug', 'copy-debug', 'build-debug-coffee-dev', cbfn
  return

gulp.task 'watch', ->
  gulp.watch paths.debug.coffee, ['build-debug-coffee']
  gulp.watch paths.src.allButBower, ['copy-debug-watch']

gulp.task 'serve-debug', ->
  gulp.src paths.debug.root
  .pipe webserver {
    livereload: true
    directoryListing: false
    host: '127.0.0.1'
    port: 8005
    open: false
    fallback: '404.html'
  }
  return

gulp.task 'default', (cbfn)->
  runSequence 'build-debug-dev', 'serve-debug', 'watch', cbfn
  return



# POLYMER BUILD TASK
# ====================================================

gulp.task 'build', ->
  runSequence('clean-debug', 'increment-version-web', 'copy-debug', 'build-debug-coffee-prod', 'concat-web', 'html-replace-web', 'polymer-build');

gulp.task 'concat-web', concatWeb

gulp.task 'increment-version-web', incrementVersionWeb(paths)

gulp.task 'html-replace-web', htmlReplaceWeb

gulp.task 'polymer-build', polymerBuildWeb
# Production Only, Removes Log Statements
gulp.task 'build-debug-coffee-prod', buildCoffeeWeb


# BUILD FOR ONSITE
# ======================================================

gulp.task 'build-onsite', ->
   runSequence('clean-debug', 'increment-version-onsite', 'copy-debug', 'build-debug-coffee-onsite', 'concat-onsite', 'html-replace-onsite', 'polymer-build-onsite');

gulp.task 'concat-onsite', concatOnsite

gulp.task 'increment-version-onsite', incrementVersionOnsite

gulp.task 'html-replace-onsite', htmlReplaceOnsite

gulp.task 'polymer-build-onsite', polymerBuildOnsite

gulp.task 'build-debug-coffee-onsite', buildCoffeeOnsite