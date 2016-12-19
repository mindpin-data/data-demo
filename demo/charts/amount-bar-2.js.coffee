window.AmountBar2 = class AmountBar2 extends DrawTitle
  constructor: (@$elm, @data)->
    @axisx_size = 30
    @axisy_size = 60

  draw: ->
    @draw_svg()
    @draw_title()
    @draw_gpanel()

    @_g()
    @draw_amount_bar()

  _g: ->
    @panel = @gpanel.append('g')
      .attr 'transform', "translate(#{@axisy_size}, 0)"

    @axisx = @gpanel.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{@axisy_size}, #{@gheight - @axisx_size})"

    @axisy = @gpanel.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{@axisy_size}, 0)" 

  draw_amount_bar: ->
    data = @data.map (d)->
      Object.assign({
        upper_limit: d3.randomUniform(d.balance_amount - 20, d.balance_amount + 100)()
        lower_limit: d3.randomUniform(d.balance_amount - 100, d.balance_amount - 50)()
      }, d)

    width = @gwidth - @axisy_size
    height = @gheight - @axisx_size

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
        return COLOR_BALANCE_OVERLOAD if d.balance_amount > d.upper_limit or d.balance_amount < d.lower_limit
        return COLOR_BALANCE

      .attr 'height', (d)->
        height - yscale(d.balance_amount)
      .attr 'transform', (d)->
        "translate(#{xscale(d.date)}, #{yscale(d.balance_amount)})"

    @axisx.call d3.axisBottom(xscale)
    @axisy.call d3.axisLeft(yscale).ticks(4)

    line1 = d3.line()
      .x (d)-> xscale(d.date) + bar_width / 2
      .y (d)-> yscale(d.upper_limit)

    @panel.append 'path'
      .datum data
      .attr 'class', 'pre-line'
      .attr 'd', line1

    line2 = d3.line()
      .x (d)-> xscale(d.date) + bar_width / 2
      .y (d)-> yscale(d.lower_limit)

    @panel.append 'path'
      .datum data
      .attr 'class', 'pre-line'
      .attr 'd', line2