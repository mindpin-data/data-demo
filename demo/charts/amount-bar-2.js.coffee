window.AmountBar2 = class AmountBar2 extends DrawTitle
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