class TS extends DrawTitle
  constructor: (@$elm)->
    #

  _draw: (id)->
    @draw_svg()
    @draw_title()
    @draw_gpanel()

    min = d3.min [@gwidth, @gheight]
    diameter = min * 0.7
    d3.select(@$elm[0]).append 'svg'
      .attr 'id', id
      .attr 'width', diameter
      .attr 'height', diameter
      .style 'position', 'absolute'
      .style 'left', "#{(@gwidth - diameter) / 2}px"
      .style 'bottom', "#{(@gheight - diameter) / 2 + 10}px"

window.TotalStat = class TotalStat extends TS
  draw: ->
    @_draw 'fillgauge1'

    config = liquidFillGaugeDefaultSettings()
    config.circleColor = '#CDFF41'
    config.waveColor = '#E3FF95'
    config.textColor = "#FFFFFF"
    config.waveTextColor = BG_COLOR
    config.circleThickness = 0.2
    config.waveAnimateTime = 1000
    config.waveCount = 3
    config.waveHeight = 0.1

    gauge = loadLiquidFillGauge("fillgauge1", 15, config)

    setInterval ->
      gauge.update Math.round d3.randomUniform(5, 20)()
    , 5000


window.TotalStat1 = class TotalStat1 extends TS
  draw: ->
    @_draw 'fillgauge2'

    config = liquidFillGaugeDefaultSettings()
    config.circleColor = '#FFC141'
    config.waveColor = '#FFDD95'
    config.textColor = "#FFFFFF"
    config.waveTextColor = BG_COLOR
    config.circleThickness = 0.2
    config.waveAnimateTime = 1000
    config.waveCount = 3
    config.waveHeight = 0.1

    gauge = loadLiquidFillGauge("fillgauge2", 30, config)

    setInterval ->
      gauge.update Math.round d3.randomUniform(10, 35)()
    , 5000


window.TotalStat2 = class TotalStat2 extends TS
  draw: ->
    @_draw 'fillgauge3'

    config = liquidFillGaugeDefaultSettings()
    config.circleColor = COLOR_OUT
    config.waveColor = COLOR_IN
    config.textColor = "#FFFFFF"
    config.waveTextColor = BG_COLOR
    config.circleThickness = 0.2
    config.waveAnimateTime = 1000
    config.waveCount = 3
    config.waveHeight = 0.1

    gauge = loadLiquidFillGauge("fillgauge3", 87, config)

    setInterval ->
      gauge.update Math.round d3.randomUniform(70, 90)()
    , 5000