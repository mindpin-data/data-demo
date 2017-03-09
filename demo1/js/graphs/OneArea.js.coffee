class OneArea extends Graph
  draw: ->
    @svg = @draw_svg()

    @draw_flag()
    @draw_texts()

  draw_flag: ->
    flag = @svg.append('g')

    flag
      .append 'image'
      .attr 'href', 'img/taiguo.png'
      .attr 'height', @height - 60
      .attr 'x', 0
      .attr 'y', 30

  draw_texts: ->
    texts = @svg.append('g')
      .style 'transform', 'translate(260px, 0px)'

    size = 40
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 10
      .attr 'dy', '.33em'
      .text '泰国销量'
      .style 'font-size', size
      .style 'fill', '#ffffff'

    size1 = 50
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + size + 40
      .attr 'dy', '.33em'
      .text '2817109'
      .style 'font-size', size1
      .style 'fill', '#ffff05'

    size2 = 40
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + size + 34 + size1 + 30
      .attr 'dy', '.33em'
      .text '同比 14.3%'
      .style 'font-size', size2
      .style 'fill', '#ffffff'

    texts
      .append 'image'
      .attr 'x', 215
      .attr 'y', size / 2 + size + 34 + size1 + 30 - size2 / 2
      .attr 'href', 'img/upicon1.png'
      .attr 'height', size2



BaseTile.register 'one-area', OneArea