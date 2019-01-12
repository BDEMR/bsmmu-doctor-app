const gulp = require('gulp');
const gutil = require('gulp-util');
const coffee = require('gulp-coffee');
const sourcemaps = require('gulp-sourcemaps');
const webserver = require('gulp-webserver');
const runSequence = require('run-sequence');
const del = require('del');
const rename = require("gulp-rename");
const pathlib = require('path');
const modify = require('gulp-modify');
const cache = require('gulp-cached');
const os = require('os');
const plumber = require('gulp-plumber');
const notify = require("gulp-notify");

const {
  incrementVersionWeb,
  concatWeb,
  htmlReplaceWeb,
  buildCoffeeWeb,
  polymerBuildWeb
} = require('./gulp-build-production');

const {
  buildOnsite,
  incrementVersionOnsite,
  concatOnsite,
  htmlReplaceOnsite,
  buildCoffeeOnsite,
  polymerBuildOnsite
} = require('./gulp-build-onsite');

/*
  The debug build process - 
    1. delete the build-debug directory
    2. copy all contents from src to build-debug
    3. in the [ '/assets', '/elements', '/', 'vendor-assets' ] directories under 'build-debug': 
      a) compile all *.coffee files and generate source maps
    4. keep watch and redo the tasks as necessary
*/

const paths = {
  src: {
    all: ['src/**'],
    allButBower: ['src/**', '!src/bower-assets/**']
  },
  debug: {
    root: 'build-debug',
    coffee: [
      'build-debug/assets/*.coffee',
      'build-debug/behaviors/*.coffee',
      'build-debug/vendor-assets/*.coffee',
      'build-debug/elements/*/*.coffee'
    ]
  }
};


gulp.task('clean-debug', () => del(paths.debug.root));

gulp.task('copy-debug', () =>
  gulp.src(paths.src.all)
    .pipe(gulp.dest(paths.debug.root))
);

gulp.task('copy-debug-watch', () =>
  gulp.src(paths.src.allButBower)
    .pipe(cache('copy'))
    .pipe(gulp.dest(paths.debug.root))
);

gulp.task('build-debug-coffee-dev', () =>
  gulp.src(paths.debug.coffee)
    .pipe(plumber({ errorHandler: notify.onError("Error: <%= error %>") }))
    .pipe(cache('copy'))
    .pipe(sourcemaps.init())
    .pipe(coffee({ bare: false }))
    .pipe(sourcemaps.write('.'))
    .pipe(rename(function (path) {
      if (path.extname === '.map') {
        path.basename = path.basename.replace('.js', '.coffee-compiled.js');
      } else if (path.extname === '.js') {
        path.basename = (path.basename += '.coffee-compiled');
      } else {
        throw new Error('Unknown Error 1');
      }
      return path;
    }))
    .pipe(modify({
      fileModifier(vfd, contents) {
        if ((`${vfd.path}`).indexOf('.js.map') > -1) {
          const json = JSON.parse(contents);
          json.file = json.file.replace('.js', '.coffee-compiled.js');
          contents = JSON.stringify(json);
        } else if ((`${vfd.path}`).indexOf('.js') > -1) {
          const index = contents.indexOf('sourceMappingURL=');
          contents = contents.substr(0, (index + ('sourceMappingURL='.length)));
          contents += pathlib.basename(vfd.path) + '.map';
        }
        return contents;
      }
    }))
    .pipe(gulp.dest(function (vfd) {
      let dirname = (pathlib.dirname(vfd.path));
      const sep = (os.platform() === 'win32' ? '\\' : '/');
      if (dirname.indexOf(`elements${sep}`) > -1) {
        dirname = dirname.split(sep);
        dirname.pop();
        dirname = dirname.join(sep);
      }
      return dirname;
    })
    )
);

gulp.task('build-debug-dev', function (cbfn) {
  runSequence('clean-debug', 'copy-debug', 'build-debug-coffee-dev', cbfn);
});

gulp.task('watch', function () {
  gulp.watch(paths.debug.coffee, ['build-debug-coffee-dev']);
  return gulp.watch(paths.src.allButBower, ['copy-debug-watch']);
});

gulp.task('serve-debug', function () {
  gulp.src(paths.debug.root)
    .pipe(webserver({
      livereload: false,
      directoryListing: false,
      host: '127.0.0.1',
      port: 8012,
      open: false,
      fallback: '404.html'
    }));
});

gulp.task('default', function (cbfn) {
  runSequence('build-debug-dev', 'serve-debug', 'watch', cbfn);
});



// POLYMER BUILD TASK
// ====================================================

gulp.task('increment-version-web', incrementVersionWeb);

gulp.task('build-debug-coffee-prod', () => buildCoffeeWeb(paths));

gulp.task('concat-web', concatWeb);

gulp.task('html-replace-web', htmlReplaceWeb);

gulp.task('polymer-build', polymerBuildWeb);

gulp.task('build', () => runSequence('clean-debug', 'increment-version-web', 'copy-debug', 'build-debug-coffee-prod', 'concat-web', 'html-replace-web', 'polymer-build'));


// BUILD FOR ONSITE
// ======================================================
gulp.task('increment-version-onsite', incrementVersionOnsite);

gulp.task('build-debug-coffee-onsite', () => buildCoffeeOnsite(paths));

gulp.task('concat-onsite', concatOnsite);

gulp.task('html-replace-onsite', htmlReplaceOnsite);

gulp.task('polymer-build-onsite', polymerBuildOnsite);

gulp.task('build-onsite', () => runSequence('clean-debug', 'increment-version-onsite', 'copy-debug', 'build-debug-coffee-onsite', 'concat-onsite', 'html-replace-onsite', 'polymer-build-onsite'));