class LineChartTitle extends Graph
  draw: ->
    @svg = @draw_svg()

    @draw_texts()

  draw_texts: ->
    texts = @svg.append('g')
      .style 'transform', 'translate(0px, 0px)'

    size = 20
    texts
      .append 'text'
      .attr 'x', 10
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text '销量对比（单位：万）'
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', 250
      .attr 'y', @height / 2 - 7
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', 'rgb(205, 255, 65)'

    texts
      .append 'text'
      .attr 'x', 290
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text '当前销量'
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', 390
      .attr 'y', @height / 2 - 7
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', 'rgb(60, 180, 236)'

    texts
      .append 'text'
      .attr 'x', 430
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text '历史销量'
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

BaseTile.register 'line-chart-title', LineChartTitle