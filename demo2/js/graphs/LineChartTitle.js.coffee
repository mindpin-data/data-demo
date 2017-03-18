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
      .text '辣椒采购价格同比（单位：万元/吨）'
      .style 'font-size', size
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', 250 - 180
      .attr 'y', @height / 2 - 7 + 30
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', 'rgb(205, 255, 65)'

    texts
      .append 'text'
      .attr 'x', 290 - 180
      .attr 'y', @height / 2 + 30
      .attr 'dy', '.33em'
      .text '现价'
      .style 'font-size', size
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', 390 - 180
      .attr 'y', @height / 2 - 7 + 30
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', 'rgb(60, 180, 236)'

    texts
      .append 'text'
      .attr 'x', 430 - 180
      .attr 'y', @height / 2 + 30
      .attr 'dy', '.33em'
      .text '上一年同期价'
      .style 'font-size', size
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', 390
      .attr 'y', @height / 2 - 7 + 30
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', 'rgb(255, 87, 87)'

    texts
      .append 'text'
      .attr 'x', 430
      .attr 'y', @height / 2 + 30
      .attr 'dy', '.33em'
      .text '政府指导价'
      .style 'font-size', size
      .style 'fill', '#ffffff'

BaseTile.register 'line-chart-title', LineChartTitle