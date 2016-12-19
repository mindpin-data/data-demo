gulp   = require 'gulp'
util   = require 'gulp-util'
concat = require 'gulp-concat'

smaps  = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
sass   = require 'gulp-ruby-sass'
haml   = require 'gulp-ruby-haml'

# 防止编译 coffee 过程中 watch 进程中止
plumber = require("gulp-plumber")

app =
  src:
    js:   'demo/charts/*.coffee'
    css:  'demo/css/*.scss'
  dist:
    js:   'demo/charts'
    css:  'demo/css'

gulp.task 'js', ->
  gulp.src app.src.js
    .pipe plumber()
    # .pipe smaps.init()
    .pipe coffee()
    # .pipe smaps.write('../maps')
    .pipe concat('charts.js')
    .pipe gulp.dest(app.dist.js)

gulp.task 'css', ->
  gulp.src app.src.css
    .pipe sass({
        "sourcemap=none": true
    })
    .on 'error', (err)->
      file = err.message.match(/^error\s([\w\.]*)\s/)[1]
      util.log [
        err.plugin,
        util.colors.red file
        err.message
      ].join ' '
    .pipe concat('index.css')
    .pipe gulp.dest(app.dist.css)

gulp.task 'build', [
  # 'js'
  'css'
]

gulp.task 'default', ['build']

gulp.task 'watch', ['build'], ->
  # gulp.watch app.src.js, ['js']
  gulp.watch app.src.css, ['css']