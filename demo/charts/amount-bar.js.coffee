window.AmountBar = class AmountBar extends DrawTitle
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