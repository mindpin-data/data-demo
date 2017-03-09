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
    js: [
      "demo/charts/utils.js.coffee"
      "demo/charts/draw-title.js.coffee"
      "demo/charts/amount-bar.js.coffee"
      "demo/charts/amount-bar-2.js.coffee"
      "demo/charts/amount-pie.js.coffee"
      "demo/charts/balance-amount-pie.js.coffee"
      "demo/charts/china-map.js.coffee"
      "demo/charts/total-stat.js.coffee"
      "demo/charts/index.js.coffee"
    ]
    css:  'demo/css/*.scss'
  dist:
    js:   'demo/charts'
    css:  'demo/css'

  src1:
    js: [
      "demo1/js/utils/date.js.coffee"
      "demo1/js/base.js.coffee"
      "demo1/js/loader.js.coffee"
    ]
    css:  'demo1/css/*.scss'
  dist1:
    js:   'demo1/dist'
    css:  'demo1/dist'

buildjs = (task, src, file_name, dist)->
  gulp.task task, ->
    gulp.src src
      .pipe plumber()
      # .pipe smaps.init()
      .pipe coffee()
      # .pipe smaps.write('../maps')
      .pipe concat(file_name)
      .pipe gulp.dest(dist)

buildjs 'js', app.src.js, 'charts.js', app.dist.js
buildjs 'js1', app.src1.js, 'index.js', app.dist1.js

gulp.task 'css', ->
  sass app.src.css
    .on 'error', sass.logError
    .pipe concat('index.css')
    .pipe gulp.dest(app.dist.css)


gulp.task 'css1', ->
  sass app.src1.css
    .on 'error', sass.logError
    .pipe concat('index.css')
    .pipe gulp.dest(app.dist1.css)


gulp.task 'build', [ 'js', 'css', 'js1', 'css1']

gulp.task 'default', ['build']

gulp.task 'watch', ['build'], ->
  gulp.watch app.src.js, ['js']
  gulp.watch app.src.css, ['css']

  gulp.watch app.src1.js, ['js1']
  gulp.watch app.src1.css, ['css1']