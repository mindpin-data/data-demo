class LineChart extends Graph
  draw: ->
    @svg = @draw_svg()
    @data0 = [0, 8, 15, 20, 26, 32, 38, 52, 59, 66, 70, 84, 88]
    @data1 = [0, 6, 13, 22, 27, 31, 35, 50, 54, 60, 66, 75, 81]
    @data2 = [0, 4, 10, 12, 19, 20, 26, 32, 37, 41, 43, 49, 58]

    @h = @height - 40
    @w = @width - 60
    @gap = (@w - 30) / 5

    @c1 = '#00c713'
    @c2 = '#578eff'
    @c3 = '#ff8711'

    @xscale = d3.scaleLinear()
      .domain [0, 11]
      .range [0, @w]

    @yscale = d3.scaleLinear()
      .domain [0, 100]
      .range [@h, 0]

    @draw_axis()
    @draw_lines()

    jQuery(document).on 'data-map:next-draw', =>
      @draw_lines()

  draw_lines: ->
    @panel.remove() if @panel?

    @panel = @svg.append('g')
      .attr 'transform', "translate(150, 10)"

    line1 = d3.line()
      .x (d, idx)=> @xscale idx
      .y (d)=> @yscale d
      .curve(d3.curveCatmullRom.alpha(0.5))

    @panel.selectAll('path.pre-line').remove()
    @panel.selectAll('circle').remove()

    _draw = (data, color, dasharray)=>
      _data = data.map (x)-> 0

      curve = @panel.append 'path'
        .datum _data
        .attr 'class', 'pre-line'
        .attr 'd', line1
        .style 'stroke', color
        .style 'fill', 'transparent'
        .style 'stroke-width', 2
        .style 'stroke-dasharray', dasharray
        .style 'stroke-linecap', 'round'

      curve.datum data
        .transition()
        .duration 1000
        .attr 'd', line1


      _data.forEach (d, idx)=>
        c = @panel.append 'circle'
          .attr 'cx', @xscale idx
          .attr 'cy', @yscale d
          .attr 'r', 4
          .attr 'fill', color

        c
          .transition()
          .duration 1000
          .attr 'cy', @yscale data[idx]


    _draw @data2, @c3
    _draw @data1, @c2, '5 5'
    _draw @data0, @c1


  draw_axis: ->
    axisx = @svg.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{150}, #{10 + @h})"

    axisy = @svg.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{150}, #{10})"

    axisx.call(
      d3.axisBottom(@xscale)
        .tickValues([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
        .tickFormat (d, idx)->
          return "#{idx + 1}月"
    )

    axisy.call(
      d3.axisLeft(@yscale)
        .tickValues([0, 20, 40, 60, 80, 100])
        .tickFormat (d, idx)->
          return '1,000,000,000' if d == 100
          return '0' if d == 0
          return "#{d}0,000,000"

    ).selectAll '.tick line'
      .attr 'x1', @w



BaseTile.register 'line-chart', LineChart