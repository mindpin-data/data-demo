window.TotalStat = class TotalStat extends DrawTitle
  constructor: ->
    @width = jQuery('.g11').width() - 20
    @height = jQuery('.g11').height() - 20

    @margin_top = 40

  draw: ->
    @svg = d3.select('.g11').append 'svg'
      .attr 'width', @width
      .attr 'height', @margin_top
      .attr 'style', "transform: translate(10px, 10px)"

    @draw_title('产品库存量')

    min = d3.min [@width, @height - @margin_top]
    min = min * 0.6
    d3.select('.g11').append 'svg'
      .attr 'id', 'fillgauge1'
      .attr 'width', min
      .attr 'height', min
      .attr 'style', "transform: translate(#{(@width - min) / 2 + 10}px, #{@margin_top + 30}px)"

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


window.TotalStat1 = class TotalStat1 extends DrawTitle
  constructor: ->
    @width = jQuery('.g12').width() - 20
    @height = jQuery('.g12').height() - 20

    @margin_top = 40

  draw: ->
    @svg = d3.select('.g12').append 'svg'
      .attr 'width', @width
      .attr 'height', @margin_top
      .attr 'style', "transform: translate(10px, 10px)"

    @draw_title('原料库存量')

    min = d3.min [@width, @height - @margin_top]
    min = min * 0.6
    d3.select('.g12').append 'svg'
      .attr 'id', 'fillgauge2'
      .attr 'width', min
      .attr 'height', min
      .attr 'style', "transform: translate(#{(@width - min) / 2 + 10}px, #{@margin_top + 30}px)"

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


window.TotalStat2 = class TotalStat2 extends DrawTitle
  constructor: ->
    @width = jQuery('.g13').width() - 20
    @height = jQuery('.g13').height() - 20

    @margin_top = 40

  draw: ->
    @svg = d3.select('.g13').append 'svg'
      .attr 'width', @width
      .attr 'height', @margin_top
      .attr 'style', "transform: translate(10px, 10px)"

    @draw_title('生产线运转率')

    min = d3.min [@width, @height - @margin_top]
    min = min * 0.6
    d3.select('.g13').append 'svg'
      .attr 'id', 'fillgauge3'
      .attr 'width', min
      .attr 'height', min
      .attr 'style', "transform: translate(#{(@width - min) / 2 + 10}px, #{@margin_top + 30}px)"

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