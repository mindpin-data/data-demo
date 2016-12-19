window.AmountBar = class AmountBar extends DrawTitle
  constructor: (@$elm, @data)->
    @axisx_size = 30
    @axisy_size = 60

  draw: ->
    @draw_svg()
    @draw_title()
    @draw_gpanel()

    @_g()
    @draw_in_out_amount_bar()

  _g: ->
    @panel = @gpanel.append('g')
      .attr 'transform', "translate(#{@axisy_size}, 0)"

    @axisx = @gpanel.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{@axisy_size}, #{@gheight - @axisx_size})"

    @axisy1 = @gpanel.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{@axisy_size}, 0)" 

    @axisy2 = @gpanel.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{@axisy_size}, #{(@gheight - @axisx_size) / 2})"

    @line = @gpanel.append('g')
      .attr 'transform', "translate(#{@axisy_size}, 0)"

  draw_in_out_amount_bar: ->
    data = @data.map (d)->
      Object.assign({
        predictive_in_amount: d3.randomUniform(d.in_amount - 50, d.in_amount + 50)()
        predictive_out_amount: d3.randomUniform(d.out_amount - 50, d.out_amount + 50)()
      }, d)

    width = @gwidth - @axisy_size
    height = @gheight - @axisx_size

    yscale1 = d3.scaleLinear()
      .domain [0, 400]
      .range [height / 2, 0]

    yscale2 = d3.scaleLinear()
      .domain [0, 400]
      .range [0, height / 2]

    xscale = d3.scaleBand()
      .domain data.map (d)-> d.date
      .range([0, width])
      .paddingInner(0.3333)
      .paddingOuter(0.3333)

    bar_width = xscale.bandwidth()

    in_amount_bar = @panel.selectAll('.in-amount-bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'in-amount-bar'
      .attr 'width', bar_width
      .attr 'fill', COLOR_IN
      .attr 'height', (d)->
        height / 2 - yscale1(d.in_amount)
      .attr 'transform', (d)->
        "translate(#{xscale(d.date)}, #{yscale1(d.in_amount)})"

    out_amount_bar = @panel.selectAll('.out-amount-bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'out-amount-bar'
      .attr 'width', bar_width
      .attr 'height', (d)->
        yscale2(d.out_amount)
      .attr 'fill', COLOR_OUT
      .attr 'transform', (d)->
        "translate(#{xscale(d.date)}, #{height / 2})"

    @axisx.call d3.axisBottom(xscale)
    @axisy1.call d3.axisLeft(yscale1).ticks(4)
    @axisy2.call d3.axisLeft(yscale2).ticks(4)

    line1 = d3.line()
      .x (d)-> xscale(d.date) + bar_width / 2
      .y (d)-> yscale1(d.predictive_in_amount)

    @line.append 'path'
      .datum data
      .attr 'class', 'line'
      .attr 'd', line1
      .style 'stroke', PRE_COLOR
      .style 'fill', 'transparent'
      .style 'stroke-width', 4

    line2 = d3.line()
      .x (d)-> xscale(d.date) + bar_width / 2
      .y (d)-> yscale2(d.predictive_out_amount)

    @line.append 'path'
      .datum data
      .attr 'class', 'line'
      .attr 'd', line2
      .style 'stroke', PRE_COLOR
      .style 'fill', 'transparent'
      .style 'stroke-width', 4
      .attr 'transform', (d)->
        "translate(0, #{height / 2})"