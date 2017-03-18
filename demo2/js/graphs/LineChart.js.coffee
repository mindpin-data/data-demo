class LineChart extends Graph
  draw: ->
    @svg = @draw_svg()
    @data0 = [45, 45, 40, 48, 42, 50]
    @data1 = [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47]
    @data2 = [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60]

    @h = @height - 40
    @w = @width - 60
    @gap = (@w - 30) / 5

    @c1 = 'rgb(205, 255, 65)'
    @c2 = 'rgb(60, 180, 236)'
    @c3 = 'rgb(255, 87, 87)'

    @xscale = d3.scaleLinear()
      .domain [0, 11]
      .range [0, @w]

    @yscale = d3.scaleLinear()
      .domain [0, 70]
      .range [@h, 0]

    @make_defs()

    @draw_axis()
    @draw_lines()

  make_defs: ->
    # https://www.w3cplus.com/svg/svg-linear-gradients.html

    defs = @svg.append('defs')
    lg = defs.append('linearGradient')
      .attr 'id', 'line-chart-linear1'
      .attr 'x1', '0%'
      .attr 'y1', '0%'
      .attr 'x2', '0%'
      .attr 'y2', '100%'

    lg.append('stop')
      .attr 'offset', '0%'
      .attr 'stop-color', 'rgba(205, 255, 65, 0.5)'

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', 'rgba(205, 255, 65, 0.05)'


    lg = defs.append('linearGradient')
      .attr 'id', 'line-chart-linear2'
      .attr 'x1', '0%'
      .attr 'y1', '0%'
      .attr 'x2', '0%'
      .attr 'y2', '100%'

    lg.append('stop')
      .attr 'offset', '0%'
      .attr 'stop-color', 'rgba(60, 180, 236, 0.5)'

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', 'rgba(60, 180, 236, 0.05)'


    lg = defs.append('linearGradient')
      .attr 'id', 'line-chart-linear3'
      .attr 'x1', '0%'
      .attr 'y1', '0%'
      .attr 'x2', '0%'
      .attr 'y2', '100%'

    lg.append('stop')
      .attr 'offset', '0%'
      .attr 'stop-color', 'rgba(255, 87, 87, 0.5)'

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', 'rgba(255, 87, 87, 0.05)'



  draw_lines: ->
    if not @panel?
      @panel = @svg.append('g')
        .attr 'transform', "translate(40, 10)"

    line1 = d3.line()
      .x (d, idx)=> @xscale idx
      .y (d)=> @yscale d

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

    @panel.append 'path'
      .datum [0, 0].concat @data2
      .attr 'class', 'pre-line'
      .attr 'd', arealine3
      .style 'fill', 'url(#line-chart-linear3)'

    @panel.append 'path'
      .datum @data2
      .attr 'class', 'pre-line'
      .attr 'd', line1
      .style 'stroke', @c3
      .style 'fill', 'transparent'
      .style 'stroke-width', 2

    for d, idx in @data2
      @panel.append 'circle'
        .attr 'cx', @xscale idx
        .attr 'cy', @yscale d
        .attr 'r', 4
        .attr 'fill', @c3


    @panel.append 'path'
      .datum [0, 0].concat @data1
      .attr 'class', 'pre-line'
      .attr 'd', arealine2
      .style 'fill', 'url(#line-chart-linear2)'

    @panel.append 'path'
      .datum @data1
      .attr 'class', 'pre-line'
      .attr 'd', line1
      .style 'stroke', @c2
      .style 'fill', 'transparent'
      .style 'stroke-width', 2

    for d, idx in @data1
      @panel.append 'circle'
        .attr 'cx', @xscale idx
        .attr 'cy', @yscale d
        .attr 'r', 4
        .attr 'fill', @c2


    @panel.append 'path'
      .datum [0, 0].concat @data0
      .attr 'class', 'pre-line'
      .attr 'd', arealine1
      .style 'fill', 'url(#line-chart-linear1)'

    @panel.append 'path'
      .datum @data0
      .attr 'class', 'pre-line'
      .attr 'd', line1
      .style 'stroke', @c1
      .style 'fill', 'transparent'
      .style 'stroke-width', 2

    for d, idx in @data0
      @panel.append 'circle'
        .attr 'cx', @xscale idx
        .attr 'cy', @yscale d
        .attr 'r', 4
        .attr 'fill', @c1


  draw_axis: ->
    axisx = @svg.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{40}, #{10 + @h})"

    axisy = @svg.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{40}, #{10})"

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