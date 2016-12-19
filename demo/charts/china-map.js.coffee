window.ChinaMap = class ChinaMap extends DrawTitle
  constructor: (@$elm, @georoot)->
    @bar_width = 125
    @text_width = 100
    @bar_top_off = 40
    @bar_label_height = 16

    @duration = 6000

    @amount_rand = d3.randomUniform(100, 200) # 库存
    @order_rand = d3.randomUniform(50, 300) # 订单

  draw: ->
    @draw_svg()
    @draw_title()
    @draw_gpanel()

    @_d()
    setInterval =>
      @_d()
    , @duration


  _d: ->
    @bar_panel.remove() if @bar_panel
    @bar_panel = @gpanel.append 'g'
      .attr 'transform', "translate(#{@text_width}, #{@bar_top_off})"

    @axis_panel.remove() if @axis_panel
    @axis_panel = @gpanel.append 'g'
      .attr 'class', 'axis'
      .attr 'transform', "translate(#{@text_width}, #{@bar_top_off + @bar_label_height})"

    @china.remove() if @china
    @china = d3.select(@$elm[0]).append 'svg'
      .attr 'class', 'china-map'
      .attr 'width', @gwidth - @bar_width - @text_width
      .attr 'height', @gheight

    @rand_data()
    @draw_bar()
    @draw_map()

  rand_data: ->
    @data = @georoot.features.map (d)=>
      amount = @amount_rand()
      order = @order_rand()
      lack = order - amount

      Object.assign({
        amount: amount
        order: order
        lack: lack
      }, d)

    @data = @data
      .sort (a, b)-> b.lack - a.lack
    @lack_max = d3.max @data.map (d)-> d.lack
    @color_gen = d3.scaleLinear()
      .domain [0, @lack_max]
      .range [GOOD_COLOR, BAD_COLOR]

  draw_bar: ->
    width = @bar_width
    data = @data.filter (d)-> d.lack > 0
    data = data[0..10]

    height = data.length * 32

    xscale = d3.scaleLinear()
      .domain [0, @lack_max]
      .range [0, width]

    yscale = d3.scaleBand()
      .domain data.map (d)-> d.properties.name
      .range([0, height])
      .paddingInner(0.2)
      .paddingOuter(0.2)

    bar_width = yscale.bandwidth()

    @bar_panel.append 'text'
      .style 'fill', 'white'
      .text '缺货预警'

    @bar_panel.selectAll('.bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'bar'
      .attr 'height', bar_width
      .attr 'width', (d)-> 0
      .attr 'fill', (d)=> @color_gen(d.lack)
      .attr 'transform', (d)=>
        "translate(0, #{yscale(d.properties.name) + @bar_label_height})"
      .transition()
      .duration @duration / 2
      .attr 'width', (d)-> xscale d.lack

    @axis_panel.call d3.axisLeft(yscale)

  draw_map: ->
    width = @gwidth - @bar_width - @text_width
    height = @gheight

    data = @data.map (d, idx)->
      d.lack1 = 0
      d.lack1 = d.lack if idx < 10
      d

    projection = d3.geoMercator()
      .center [104, 38]
      .scale width * 0.9
      .translate [width / 2, height / 2]

    path = d3.geoPath projection

    scale = d3.scaleSqrt()
      .domain [0, @lack_max]
      .range [0, 30]

    provinces = @china.selectAll('.province')
      .data data
      .enter()
      .append 'path'
      .attr 'class', 'province'
      .style 'fill', (d)=>
        # return @color_gen(d.lack1) if d.lack1 > 0
        return 'transparent'
      .style 'stroke', COLOR_IN
      .style 'stroke-width', 3
      .attr 'd', path

    data1 = data.filter (x)-> x.lack1 > 0
    data1 = data1.map (d)->
      d.centroid = path.centroid(d)
      d

    points = @china.selectAll('.point')
      .data data1
      .enter()
      .append 'circle'
      .attr 'class', 'point'
      .style 'fill', BAD_COLOR
      .style 'opacity', '0.7'
      .attr 'cx', (d)->
        d.centroid[0]
      .attr 'cy', (d)->
        d.centroid[1]
      .attr 'r', 0
      .transition()
      .duration @duration / 2
      .attr 'r', (d)->
        scale d.lack1
