window.BalanceAmountPie = class BalanceAmountPie extends DrawTitle
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