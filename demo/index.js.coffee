COLOR_IN = '#95deff'
COLOR_OUT = '#41c4ff'

COLOR_DEEP = '#0088c5'

BG_COLOR = '#17243C'

GOOD_COLOR = '#97FF41'
BAD_COLOR = '#FF7C41'

class DrawTitle
  draw_title: (title)->
    @title = @svg.append('g')
      .attr 'class', 'title'

    @title
      .append 'rect'
        .attr 'width', @width
        .attr 'height', @margin_top
        .attr 'fill', 'rgba(0, 0, 0, 0)'

    @title
      .append('text')
      .attr('dx', @width / 2)
      .attr('dy', @margin_top - 16)
      .attr 'text-anchor', 'middle'
      .text(title)

  rotate_pie: (path)->
    rotate = 0
    n = 0
    repeat = ->
      rotate += 36
      path
        .each -> n += 1
        .transition()
        .duration(1000)
        .ease d3.easeLinear
        .attr 'transform', "rotate(#{rotate})"
        .on 'end', ->
          n -= 1
          repeat() if n == 0

    repeat()

class AmountBar extends DrawTitle
  constructor: (@data)->
    @width = jQuery('.g7').width() - 20
    @height = jQuery('.g7').height() - 20

    @axisx_size = 30
    @axisy_size = 60

    @margin_top = 40

  draw: ->
    @svg = d3.select('.g7').append('svg')
      .attr 'width', @width
      .attr 'height', @height
      .attr 'style', "transform: translate(10px, 10px)"

    @panel = @svg.append('g')
      .attr 'transform', "translate(#{@axisy_size}, #{@margin_top})"

    @axisx = @svg.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{@axisy_size}, #{@height - @axisx_size})"

    @axisy = @svg.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{@axisy_size}, #{@margin_top})" 

    @draw_title('某品类入库出库分时统计')
    @draw_in_out_amount_bar()

  draw_in_out_amount_bar: ->
    data = @data
    width = @width - @axisy_size
    height = @height - @axisx_size - @margin_top

    yscale = d3.scaleLinear()
      .domain [0, 400]
      .range [height, 0]

    xscale = d3.scaleBand()
      .domain data.map (d)-> d.date
      .range([0, width])
      .paddingInner(0.3333)
      .paddingOuter(0.3333)

    bar_width = xscale.bandwidth() * 0.4
    off1 = xscale.bandwidth() * 0.05
    off2 = xscale.bandwidth() * 0.55

    in_amount_bar = @panel.selectAll('.in-amount-bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'in-amount-bar'
      .attr 'width', bar_width
      .attr 'fill', COLOR_IN
      .attr 'height', (d)->
        height - yscale(d.in_amount)
      .attr 'transform', (d)->
        "translate(#{xscale(d.date) + off1}, #{yscale(d.in_amount)})"

    out_amount_bar = @panel.selectAll('.out-amount-bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'out-amount-bar'
      .attr 'width', bar_width
      .attr 'height', (d)->
        height - yscale(d.out_amount)
      .attr 'fill', COLOR_OUT
      .attr 'transform', (d)->
        "translate(#{xscale(d.date) + off2}, #{yscale(d.out_amount)})"

    @axisx.call d3.axisBottom(xscale)
    @axisy.call d3.axisLeft(yscale).ticks(4)



class AmountBar2 extends DrawTitle
  constructor: (@data)->
    @width = jQuery('.g3').width() - 20
    @height = jQuery('.g3').height() - 20

    @axisx_size = 30
    @axisy_size = 60

    @margin_top = 40

  draw: ->
    @svg = d3.select('.g3').append('svg')
      .attr 'width', @width
      .attr 'height', @height
      .attr 'style', "transform: translate(10px, 10px)"

    @panel = @svg.append('g')
      .attr 'transform', "translate(#{@axisy_size}, #{@margin_top})"

    @axisx = @svg.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{@axisy_size}, #{@height - @axisx_size})"

    @axisy = @svg.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{@axisy_size}, #{@margin_top})" 

    @draw_title('库存余量分时统计')
    @draw_amount_bar()

  draw_amount_bar: ->
    data = @data.map (d)->
      Object.assign({
        upper_limit: d3.randomUniform(280, 320)()
        lower_limit: d3.randomUniform(80, 150)()
      }, d)

    # console.log data

    width = @width - @axisy_size
    height = @height - @axisx_size - @margin_top

    yscale = d3.scaleLinear()
      .domain [0, 400]
      .range [height, 0]

    xscale = d3.scaleBand()
      .domain data.map (d)-> d.date
      .range([0, width])
      .paddingInner(0.3333)
      .paddingOuter(0.3333)

    bar_width = xscale.bandwidth()

    amount_bar = @panel.selectAll('.in-amount-bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'in-amount-bar'
      .attr 'width', bar_width
      .attr 'fill', (d)->
        return '#F39D77' if d.balance_amount > d.upper_limit or d.balance_amount < d.lower_limit
        return '#E7FF95'

      .attr 'height', (d)->
        height - yscale(d.balance_amount)
      .attr 'transform', (d)->
        "translate(#{xscale(d.date)}, #{yscale(d.balance_amount)})"

    @axisx.call d3.axisBottom(xscale)
    @axisy.call d3.axisLeft(yscale).ticks(4)

    line = d3.line()
      .x (d)-> xscale(d.date) + bar_width / 2
      .y (d)-> yscale(d.upper_limit)

    @panel.append 'path'
      .datum data
      .attr 'class', 'line'
      .attr 'd', line
      .style 'stroke', BAD_COLOR
      .style 'fill', 'transparent'
      .style 'stroke-width', 5

    line1 = d3.line()
      .x (d)-> xscale(d.date) + bar_width / 2
      .y (d)-> yscale(d.lower_limit)

    @panel.append 'path'
      .datum data
      .attr 'class', 'line'
      .attr 'd', line1
      .style 'stroke', BAD_COLOR
      .style 'fill', 'transparent'
      .style 'stroke-width', 5


class AmountPie extends DrawTitle
  constructor: (@data)->
    @pie_data = [
      {
        label: '入库'
        amount: d3.sum(@data.map (d)-> d.in_amount)
        color: COLOR_IN
      }
      {
        label: '出库'
        amount: d3.sum(@data.map (d)-> d.out_amount)
        color: COLOR_OUT
      }
    ]

    @width = jQuery('.g6').width() - 20
    @height = jQuery('.g6').height() - 20

    @margin_top = 40
    @margin_left = 160


  draw: ->
    @svg = d3.select('.g6').append 'svg'
      .attr 'width', @width
      .attr 'height', @height
      .attr 'style', "transform: translate(10px, 10px)"
      
    @draw_title('某品类当前入库出库比例')

    @panel = @svg.append 'g'
      .attr 'transform', "translate(#{@margin_left + 20}, #{@margin_top})"

    @arc_panel = @panel.append 'g'
      .attr 'class', 'pie'
      .attr 'transform', "translate(#{(@width - @margin_left) / 2}, #{(@height - @margin_top) / 2})"

    @bar_panel = @svg.append 'g'
      .attr 'transform', "translate(80, #{@margin_top * 2})"

    @axis_panel = @svg.append 'g'
      .attr 'class', 'axis'
      .attr 'transform', "translate(80, #{@margin_top * 2})"

    @draw_pie()
    @draw_bar()

  draw_pie: ->
    width = @width * 0.6
    height = @height * 0.6
    radius = Math.min(width, height) / 2

    pie = d3.pie()
      .value (d)-> d.amount

    g = @arc_panel.selectAll('.arc')
      .data pie(@pie_data)
      .enter().append('g').attr('class', 'arc')

    arc = d3.arc()
      .outerRadius radius
      .innerRadius radius / 2

    path = g.append('path')
      .attr('d', arc)
      .attr 'fill', (d)-> d.data.color
      .attr 'stroke', BG_COLOR
      .attr 'stroke-width', 1

    @rotate_pie path

  draw_bar: ->
    width = @margin_left - 60
    height = @pie_data.length * 32
    data = @pie_data

    max = d3.max data.map (d)-> d.amount

    xscale = d3.scaleLinear()
      .domain [0, max]
      .range [0, width]

    yscale = d3.scaleBand()
      .domain data.map (d)-> d.label
      .range([0, height])
      .paddingInner(0.2)
      .paddingOuter(0.2)

    bar_width = yscale.bandwidth()

    @bar_panel.selectAll('.bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'bar'
      .attr 'height', bar_width
      .attr 'width', (d)->
        xscale(d.amount)
      .attr 'fill', (d)-> d.color
      .attr 'transform', (d)->
        "translate(0, #{yscale(d.label)})"

    @axis_panel.call d3.axisLeft(yscale)


class BalanceAmountPie extends DrawTitle
  constructor: (@data)->
    @width = jQuery('.g5').width() - 20
    @height = jQuery('.g5').height() - 20

    @margin_top = 40
    @margin_left = 160

  draw: ->
    @svg = d3.select('.g5').append 'svg'
      .attr 'width', @width
      .attr 'height', @height
      .attr 'style', "transform: translate(10px, 10px)"
      
    @draw_title('当前库存品类构成')

    @panel = @svg.append 'g'
      .attr 'transform', "translate(#{@margin_left + 20}, #{@margin_top})"

    @arc_panel = @panel.append 'g'
      .attr 'class', 'pie'
      .attr 'transform', "translate(#{(@width - @margin_left) / 2}, #{(@height - @margin_top) / 2})"

    @bar_panel = @svg.append 'g'
      .attr 'transform', "translate(80, #{@margin_top * 2})"

    @axis_panel = @svg.append 'g'
      .attr 'class', 'axis'
      .attr 'transform', "translate(80, #{@margin_top * 2})"

    @draw_pie()
    @draw_bar()

  draw_pie: ->
    width = @width * 0.6
    height = @height * 0.6
    radius = Math.min(width, height) / 2

    pie = d3.pie()
      .value (d)-> d.balance_amount

    g = @arc_panel.selectAll('.arc')
      .data pie @data
      .enter().append('g').attr('class', 'arc')

    arc = d3.arc()
      .outerRadius radius
      .innerRadius radius / 2

    color = d3.scaleLinear()
      .domain [0, @data.length - 1]
      .range [COLOR_IN, COLOR_DEEP]

    path = g.append('path')
      .attr('d', arc)
      .attr 'fill', (d, idx)-> color(idx)
      .attr 'stroke', BG_COLOR
      .attr 'stroke-width', 1

    @rotate_pie path

  draw_bar: ->
    width = @margin_left - 60
    height = @data.length * 32
    data = @data

    max = d3.max data.map (d)-> d.balance_amount

    xscale = d3.scaleLinear()
      .domain [0, max]
      .range [0, width]

    yscale = d3.scaleBand()
      .domain data.map (d)-> d.name
      .range([0, height])
      .paddingInner(0.2)
      .paddingOuter(0.2)

    bar_width = yscale.bandwidth()

    color = d3.scaleLinear()
      .domain [0, @data.length - 1]
      .range [COLOR_IN, COLOR_DEEP]

    @bar_panel.selectAll('.bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'bar'
      .attr 'height', bar_width
      .attr 'width', (d)->
        xscale(d.balance_amount)
      .attr 'fill', (d, idx)-> color(idx)
      .attr 'transform', (d)->
        "translate(0, #{yscale(d.name)})"

    @axis_panel.call d3.axisLeft(yscale)


class ChinaMap extends DrawTitle
  constructor: (@georoot)->
    @width = jQuery('.g8').width() - 20
    @height = jQuery('.g8').height() - 20

    @margin_top = 40
    @margin_left = 200

  draw: ->
    @svg = d3.select('.g8').append 'svg'
      .attr 'width', @width
      .attr 'height', @height
      .attr 'style', "transform: translate(10px, 10px)"

    @bar_panel = @svg.append 'g'
      .attr 'transform', "translate(80, #{@margin_top * 2})"

    @bar_panel.append 'text'
      .style 'fill', 'white'
      .text '缺货情况'

    @draw_title('某品类供货地图')
    @draw_map()


  rand_data: ->
    rand = d3.randomUniform(-4, 10)

    @georoot.features.forEach (d)->
      d.rand = rand()

  draw_map: ->
    width = @width - @margin_left
    height = @height - @margin_top

    china = d3.select('.g8').append 'svg'
      .attr 'class', 'china-map'
      .attr 'width', width
      .attr 'height', height
      .attr 'transform', "translate(#{@margin_left}, #{@margin_top})"

    projection = d3.geoMercator()
      .center [107, 37]
      .scale width * 0.85
      .translate [width / 2, height / 2]

    path = d3.geoPath projection

    color = d3.scaleLinear()
      .domain [10, -10]
      .range [GOOD_COLOR, BAD_COLOR]

    @rand_data()
    provinces = china.selectAll('.province')
      .data @georoot.features
      .enter()
      .append 'path'
      .attr 'class', 'province'
      .style 'fill', (d)-> color d.rand
      .style 'stroke', BG_COLOR
      .style 'stroke-width', 1
      .attr 'd', path

    @rand_map provinces, color

  rand_map: (path, color)->
    n = 0

    repeat = =>
      @bar_panel.selectAll('.bar').remove()

      @draw_bar()
      @rand_data()
      
      path
        .each -> n += 1
        .transition()
        .duration(20000)
        .ease d3.easeLinear
        .style 'fill', (d)-> color d.rand
        .on 'end', ->
          n -= 1
          repeat() if n == 0

    repeat()

  draw_bar: ->
    width = @margin_left - 100
    data = @georoot.features
    data = data
      .map (d)-> 
        d.rand = - d.rand
        d
      .sort (a, b)-> b.rand - a.rand

    data = data[0..10]

    height = data.length * 32

    max = d3.max data.map (d)-> d.rand

    xscale = d3.scaleLinear()
      .domain [0, max]
      .range [0, width]

    yscale = d3.scaleBand()
      .domain data.map (d)-> d.properties.name
      .range([0, height])
      .paddingInner(0.2)
      .paddingOuter(0.2)

    bar_width = yscale.bandwidth()

    color = d3.scaleLinear()
      .domain [10, -10]
      .range [GOOD_COLOR, BAD_COLOR]

    @bar_panel.selectAll('.bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'bar'
      .attr 'height', bar_width
      .attr 'width', (d)-> 0
      .attr 'fill', (d)-> color -d.rand
      .attr 'transform', (d)->
        "translate(0, #{yscale(d.properties.name) + 16})"
      .transition()
      .duration(3000)
      .attr 'width', (d)-> xscale d3.max [d.rand, 0] 

    @axis_panel.remove() if @axis_panel
    @axis_panel = @svg.append 'g'
      .attr 'class', 'axis'
      .attr 'transform', "translate(80, #{@margin_top * 2 + 16})"
    @axis_panel.call d3.axisLeft(yscale)

class TotalStat extends DrawTitle
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

class TotalStat1 extends DrawTitle
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


class TotalStat2 extends DrawTitle
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

jQuery ->
  d3.json 'data/StockRecord.json?1', (error, _data)->

    now = new Date().getTime()
    data = _data.map (d, idx)->
      date = new Date(now + idx * 86400000)
      Object.assign {date: format_date(date, "MM-dd")}, d

    new AmountBar(data).draw()
    new AmountBar2(data).draw()
    new AmountPie(data).draw()

jQuery ->
  d3.json 'data/MaterialBalanceAmount.json?1', (error, _data)->
    data = _data.sort (a, b)->
      b.balance_amount - a.balance_amount

    new BalanceAmountPie(data).draw()

jQuery ->
  d3.json 'data/china.json', (error, root)->
    # georoot = topojson.feature toporoot, toporoot.objects.china
    georoot = root

    new ChinaMap(georoot).draw()

jQuery ->
  new TotalStat().draw()
  new TotalStat1().draw()
  new TotalStat2().draw()