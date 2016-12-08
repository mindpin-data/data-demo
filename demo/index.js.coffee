COLOR_IN = '#95deff'
COLOR_OUT = '#41c4ff'
BG_COLOR = '#17243C'

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

    @draw_title('入库出库分时统计')
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
      .attr 'height', (d)->
        height - yscale(d.in_amount)
      .attr 'fill', COLOR_IN
      .attr 'transform', (d)->
        "translate(#{xscale(d.date) + off1}, #{yscale(d.in_amount)})"

    out_amount_bar = @panel.selectAll('.out-amount-bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'out-amount-bar'
      .attr 'width', bar_width
      .attr 'height', (d)->
        yscale(d.out_amount)
      .attr 'fill', COLOR_OUT
      .attr 'transform', (d)->
        "translate(#{xscale(d.date) + off2}, #{height - yscale(d.out_amount)})"

    @axisx.call d3.axisBottom(xscale)

    @axisy.call d3.axisLeft(yscale).ticks(4)


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


  draw: ->
    @svg = d3.select('.g6').append 'svg'
      .attr 'width', @width
      .attr 'height', @height
      .attr 'style', "transform: translate(10px, 10px)"
      
    @draw_title('当前入库出库比例')

    @panel = @svg.append 'g'
      .attr 'transform', "translate(0, #{@margin_top})"

    @arc_panel = @panel.append 'g'
      .attr 'transform', "translate(#{@width / 2}, #{(@height - @margin_top) / 2})"

    @draw_pie()

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

    g.append('path')
      .attr('d', arc)
      .attr 'fill', (d)-> d.data.color
      .attr 'stroke', BG_COLOR
      .attr 'stroke-width', 2


jQuery ->
  d3.json 'data/StockRecord.json', (error, _data)->

    now = new Date().getTime()
    data = _data.map (d, idx)->
      date = new Date(now + idx * 86400000)
      Object.assign {date: format_date(date, "MM-dd")}, d

    new AmountBar(data).draw()
    new AmountPie(data).draw()