class PageTitle extends Graph
  draw: ->
    @svg = @draw_svg()

    @draw_title()
    @draw_points()

  draw_title: ->
    title = @svg.append('g')
    size = 60
    title
      .append 'text'
      .attr 'x', 70 + 30
      .attr 'y', 10 + size / 2
      .attr 'dy', '.33em'
      .text '一带一路国家销售情况监控'
      .style 'font-size', size
      .style 'fill', '#aebbcb'

  draw_points: ->
    points = @svg.append('g')

    points
      .append 'image'
      .attr 'href', 'img/title-points.png'
      .attr 'width', 60
      .attr 'height', 60
      .attr 'x', 10
      .attr 'y', 10
      # .attr 'transform', 'translate(0, -30)'
      .style 'opacity', '0.5'


BaseTile.register 'title', PageTitle