class PageTitle extends Graph
  draw: ->
    @TEXT_SIZE = 50

    @svg = @draw_svg()
    @draw_title()
    @draw_points()

  draw_title: ->
    title = @svg.append('g')
      .append 'text'
      .attr 'x', 70 + 30
      .attr 'y', 10 + @TEXT_SIZE / 2
      .attr 'dy', '.33em'
      .text '原材料产地监控'
      .style 'font-size', @TEXT_SIZE + 'px'
      .style 'fill', '#aebbcb'

  draw_points: ->
    points = @svg.append('g')
      .append 'image'
      .attr 'href', 'img/title-points.png'
      .attr 'width', @TEXT_SIZE
      .attr 'height', @TEXT_SIZE
      .attr 'x', 10
      .attr 'y', 10
      .style 'opacity', '0.5'


BaseTile.register 'title', PageTitle