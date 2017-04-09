class LineChart extends Graph
  draw: ->
    @svg = @draw_svg()
    @data0 = [45, 45, 40, 48, 42, 50]
    @data1 = [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47]
    @data2 = [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60]

    @h = @height - 40
    @w = @width - 60
    @gap = (@w - 30) / 5

    @c1 = 'rgb(137, 189, 27)'
    @c2 = 'rgb(6, 129, 200)'
    @c3 = 'rgb(217, 6, 8)'

    @xscale = d3.scaleLinear()
      .domain [0, 11]
      .range [0, @w]

    @yscale = d3.scaleLinear()
      .domain [0, 70]
      .range [@h, 0]

    @make_defs()

    @draw_axis()
    @draw_lines()

    jQuery(document).on 'data-map:next-draw', =>
      @draw_lines()

  make_def: (r, g, b, id)->
    lg = @svg_defs.append('linearGradient')
      .attr 'id', id
      .attr 'x1', '0%'
      .attr 'y1', '0%'
      .attr 'x2', '0%'
      .attr 'y2', '100%'

    lg.append('stop')
      .attr 'offset', '0%'
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.1)"

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.0)"


  make_defs: ->
    # https://www.w3cplus.com/svg/svg-linear-gradients.html
    @svg_defs = @svg.append('defs')

    @make_def 205, 255, 65, 'line-chart-linear1'
    @make_def 60, 180, 236, 'line-chart-linear2'
    @make_def 217, 87, 87,  'line-chart-linear3'


  draw_lines: ->
    @panel.remove() if @panel?
    @panel = @svg.append('g')
      .attr 'transform', "translate(30, 10)"

    line1 = d3.line()
      .x (d, idx)=> @xscale idx
      .y (d)=> @yscale d
      .curve(d3.curveCatmullRom.alpha(0.5))

    arealine1 = d3.line()
      .x (d, idx)=>
        if idx == 0
          @xscale 5
        else if idx == 1
          @xscale 0
        else
          @xscale idx - 2
      .y (d, idx)=>
        @yscale d

    arealine2 = d3.line()
      .x (d, idx)=>
        if idx == 0
          @xscale 11
        else if idx == 1
          @xscale 0
        else
          @xscale idx - 2
      .y (d, idx)=>
        @yscale d

    arealine3 = d3.line()
      .x (d, idx)=>
        if idx == 0
          @xscale 11
        else if idx == 1
          @xscale 0
        else
          @xscale idx - 2
      .y (d, idx)=>
        @yscale d

    @panel.selectAll('path.pre-line').remove()
    @panel.selectAll('circle').remove()

    _curve = (data, arealine, color, fill)=>
      _data = data.map (x)-> 0

      area = @panel.append 'path'
        .datum [0, 0].concat _data
        .attr 'class', 'pre-line'
        .attr 'd', arealine
        .style 'fill', fill

      area.datum [0, 0].concat data
        .transition()
        .duration 1000
        .attr 'd', arealine

      curve = @panel.append 'path'
        .datum _data
        .attr 'class', 'pre-line'
        .attr 'd', line1
        .style 'stroke', color
        .style 'fill', 'transparent'
        .style 'stroke-width', 2

      curve.datum data
        .transition()
        .duration 1000
        .attr 'd', line1

      for d, idx in _data
        circle = @panel.append 'circle'
          .attr 'cx', @xscale idx
          .attr 'cy', @yscale d
          .attr 'r', 4
          .attr 'fill', color

        circle
          .transition()
          .duration 1000
          .attr 'cy', @yscale data[idx]

    _curve @data2, arealine3, @c3, 'url(#line-chart-linear3)'
    _curve @data1, arealine2, @c2, 'url(#line-chart-linear2)'
    _curve @data0, arealine1, @c1, 'url(#line-chart-linear1)'

  draw_axis: ->
    axisx = @svg.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{30}, #{10 + @h})"

    axisy = @svg.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{30}, #{10})"

    axisx.call(
      d3.axisBottom(@xscale)
        .tickValues([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
        .tickFormat (d, idx)->
          return "#{idx + 1}月"
    )

    axisy.call(
      d3.axisLeft(@yscale)
        .tickValues([0, 10, 20, 30, 40, 50, 60, 70])
    ).selectAll '.tick line'
      .attr 'x1', @w



BaseTile.register 'line-chart', LineChart