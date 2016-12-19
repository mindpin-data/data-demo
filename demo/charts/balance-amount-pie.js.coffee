window.BalanceAmountPie = class BalanceAmountPie extends DrawTitle
  constructor: (@$elm, @data)->
    @bar_width = 120
    @text_width = 80
    @bar_top_off = 40

  draw: ->
    @draw_svg()
    @draw_title()
    @draw_gpanel()

    x = @gwidth - (@gwidth - @bar_width - @text_width) / 2
    @arc_panel = @gpanel.append 'g'
      .attr 'class', 'pie'
      .attr 'transform', "translate(#{x}, #{@gheight / 2})"

    @bar_panel = @gpanel.append 'g'
      .attr 'transform', "translate(#{@text_width}, #{@bar_top_off})"

    @axis_panel = @gpanel.append 'g'
      .attr 'class', 'axis'
      .attr 'transform', "translate(#{@text_width}, #{@bar_top_off})"

    @draw_pie()
    @draw_bar()

  draw_pie: ->
    width = @gwidth - @bar_width - @text_width
    height = @gheight
    min = Math.min(width, height) / 2
    radius = min * 0.8
    inner_radius = radius * 0.4

    pie = d3.pie().value 1

    max_amount = d3.max @data.map (d)-> d.balance_amount
    scale = d3.scaleSqrt()
      .domain [0, max_amount]
      .range [inner_radius, radius]

    g = @arc_panel.selectAll('.arc')
      .data pie @data
      .enter().append('g').attr('class', 'arc')

    arc = d3.arc()
      .outerRadius (d)-> scale d.data.balance_amount
      .innerRadius inner_radius

    color = d3.scaleLinear()
      .domain [0, @data.length - 1]
      .range [COLOR_BALANCE, COLOR_BALANCE_DEEP]

    path = g.append('path')
      .attr('d', arc)
      .attr 'fill', (d, idx)-> color(idx)
      .attr 'stroke', BG_COLOR
      .attr 'stroke-width', 1

    @rotate_pie path

  draw_bar: ->
    width = @bar_width
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
      .range [COLOR_BALANCE, COLOR_BALANCE_DEEP]

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