class LineChart extends Graph
  draw: ->
    @svg = @draw_svg()
    @data0 = [0, 35, 100, 140]
    @data1 = [0, 30, 60, 80, 110, 140]

    @h = @height - 40
    @w = @width - 60
    @gap = (@w - 30) / 5

    @c1 = 'rgb(205, 255, 65)'
    @c2 = 'rgb(60, 180, 236)'

    @xscale = d3.scaleLinear()
      .domain [0, 5]
      .range [0, @w]

    @yscale = d3.scaleLinear()
      .domain [0, 180]
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

  draw_lines: ->
    panel = @svg.append('g')
      .attr 'transform', "translate(40, 10)"

    line1 = d3.line()
      .x (d, idx)=> @xscale idx
      .y (d)=> @yscale d

    arealine1 = d3.line()
      .x (d, idx)=>
        if idx == 0
          @xscale 3
        else if idx == 1
          @xscale 0
        else
          @xscale idx - 2
      .y (d, idx)=>
        @yscale d

    arealine2 = d3.line()
      .x (d, idx)=>
        if idx == 0
          @xscale 5
        else if idx == 1
          @xscale 0
        else
          @xscale idx - 2
      .y (d, idx)=>
        @yscale d


    panel.append 'path'
      .datum [0, 0].concat @data0
      .attr 'class', 'pre-line'
      .attr 'd', arealine1
      .style 'fill', 'url(#line-chart-linear1)'

    panel.append 'path'
      .datum @data0
      .attr 'class', 'pre-line'
      .attr 'd', line1
      .style 'stroke', @c1
      .style 'fill', 'transparent'
      .style 'stroke-width', 2

    for d, idx in @data0
      panel.append 'circle'
        .attr 'cx', @xscale idx
        .attr 'cy', @yscale d
        .attr 'r', 4
        .attr 'fill', @c1

    panel.append 'path'
      .datum [0, 0].concat @data1
      .attr 'class', 'pre-line'
      .attr 'd', arealine2
      .style 'fill', 'url(#line-chart-linear2)'

    panel.append 'path'
      .datum @data1
      .attr 'class', 'pre-line'
      .attr 'd', line1
      .style 'stroke', @c2
      .style 'fill', 'transparent'
      .style 'stroke-width', 2

    for d, idx in @data1
      panel.append 'circle'
        .attr 'cx', @xscale idx
        .attr 'cy', @yscale d
        .attr 'r', 4
        .attr 'fill', @c2


  draw_axis: ->
    axisx = @svg.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{40}, #{10 + @h})"

    axisy = @svg.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{40}, #{10})"

    axisx.call(
      d3.axisBottom(@xscale)
        .tickValues([0, 1, 2, 3, 4, 5])
        .tickFormat (d, idx)-> 
          return '' if idx == 0
          return "#{idx * 2}月"
    )

    axisy.call(
      d3.axisLeft(@yscale)
        .tickValues([0, 30, 60, 90, 120, 150, 180])
    ).selectAll '.tick line'
      .attr 'x1', @w



BaseTile.register 'line-chart', LineChart