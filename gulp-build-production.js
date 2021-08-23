let gulp = require('gulp');
let gutil = require('gulp-util');
let uglify = require('gulp-uglify');
let coffee = require('gulp-coffee');
let concat = require('gulp-concat');
let sourcemaps = require('gulp-sourcemaps');
let runSequence = require('gulp4-run-sequence');
let del = require('del');
let rename = require("gulp-rename");
let htmlreplace = require('gulp-html-replace');
let pathlib = require('path');
let modify = require('gulp-modify');
let os = require('os');
let fs = require('fs');
let PolymerProject = require('polymer-build').PolymerProject;
let addServiceWorker = require('polymer-build').addServiceWorker;
let mergeStream = require('merge-stream');
let glob = require('glob');

const incrementVersionWeb = () => {
  const config = fs.readFileSync('src/assets/config-production.coffee', 'utf8');
  const searchString = "clientVersion: '";
  const index = config.indexOf(searchString);
  const index2 = config.indexOf("'", (index + searchString.length + 1));
  const first = config.slice(0, (index + searchString.length));
  let middle = config.slice((index + searchString.length), index2);
  const last = config.slice(index2, config.length);
  const version = middle.split(".");
  version[2] = (parseInt(version[2])) + 1;
  middle = version.join(".");
  const finalConfig = first + middle + last;
  return fs.writeFileSync('src/assets/config-production.coffee', finalConfig);
}

const concatWeb = () => {
  return gulp.src([
    'build-debug/vendor-assets/*.js',
    'build-debug/assets/config-production.coffee-compiled.js',
    'build-debug/assets/pages.coffee-compiled.js',
    'build-debug/assets/lib.coffee-compiled.js',
    'build-debug/assets/db.coffee-compiled.js',
    'build-debug/assets/lang.coffee-compiled.js',
    'build-debug/assets/app.coffee-compiled.js'
  ])
    .pipe(concat('all.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./build-debug'))

}
const htmlReplaceWeb = () => {
  return gulp.src('build-debug/index.html')
    .pipe(htmlreplace({
      concat: 'all.js',
      bugsnag: '<script src="//d2wy8f7a9ursnm.cloudfront.net/v4/bugsnag.min.js"></script><script>window.bugsnagClient = bugsnag("2795acf6cb3feffe64bba1503d86a4e8")</script>',
      sw: '<script>"serviceWorker"in navigator&&window.addEventListener("load",function(){navigator.serviceWorker.register("./service-worker.js")});</script>'
    }))
    .pipe(gulp.dest('./build-debug'))

}
const buildCoffeeWeb = (paths) => {
  return gulp.src(paths.debug.coffee)
    // .pipe(sourcemaps.init())
    .pipe(coffee({ bare: false }).on('error', gutil.log))
    .pipe(uglify({
      compress: {
        drop_console: true
      }
    }))
    // .pipe(sourcemaps.write('.'))
    .pipe(rename(function (path) {
      if (path.extname === '.js') {
        path.basename = (path.basename += '.coffee-compiled');
      } else {
        throw new Error('Unknown Error 1');
      }
      return path;
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

}
const polymerBuildWeb = () => {
  const filePathList = glob.sync('build-debug/elements/**/*.html');
  let fragments = [];
  for (let item of Array.from(filePathList)) {
    const path = item.split("/").slice(1).join("/");
    fragments.push(path);
  }

  const project = new PolymerProject({
    root: 'build-debug',
    entrypoint: "index.html",
    shell: "elements/root-element/root-element.html",
    fragments,
    sources: [
      "elements/**/*.js",
      "elements/**/*.html",
      "assets/**/*",
      "images/**/*",
      "behaviors/*",
      "styles/*"
    ],
    extraDependencies: [
      "favicon.png",
      "all.js",
      "bower-assets/webcomponentsjs/webcomponents-lite.min.js",
      "vendor-assets/he.min.js",
      "vendor-assets/editor/**/*"
    ],
    lint: {
      rules: ["polymer-1"]
    },
    builds: [{
      bundle: true,
      js: { minify: true },
      css: { minify: true },
      html: { minify: true },
    }]
  });

  const waitFor = stream =>
    new Promise((resolve, reject) => {
      stream.on('end', resolve);
      return stream.on('error', reject);
    });

  return new Promise((resolve, reject) => {
    return del('polymer-build')
      .then(() => {
        const buildStream = mergeStream(project.sources(), project.dependencies())
          .pipe(project.bundler())
          .pipe(gulp.dest('polymer-build/'));
        return waitFor(buildStream);
      }).then(() => {
        return addServiceWorker({
          buildRoot: 'polymer-build/build-debug/',
          project,
          bundled: true,
          swPrecacheConfig: {
            navigateFallback: '/index.html',
            stripPrefix: 'build-debug/',
            staticFileGlobs: [
              '/all.js',
              '/favicon.png',
              '/assets/**/*',
              "vendor-assets/editor/**/*",
              '/bower-assets/webcomponentsjs/webcomponents-lite.min.js',
              '/images/**/*'
            ]
          }
        });
      });
  });

}


Object.assign(exports, {
  incrementVersionWeb,
  concatWeb,
  htmlReplaceWeb,
  buildCoffeeWeb,
  polymerBuildWeb
})