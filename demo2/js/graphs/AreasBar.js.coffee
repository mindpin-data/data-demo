class AreasBar extends Graph
  draw: ->
    @svg = @draw_svg()
    @draw_flags()

  draw_flags: ->
    @svg.select('g.flag').remove()
    panel = @svg.append('g')
      .attr 'class', 'flag'

    size = 24

    panel
      .append 'image'
      .attr 'x', 80
      .attr 'y', size / 2
      .attr 'href', 'img/大雨.png'
      .attr 'height', 40

    panel
      .append 'image'
      .attr 'x', 80
      .attr 'y', size / 2 + 60
      .attr 'href', 'img/大风.png'
      .attr 'height', 40

    panel
      .append 'text'
      .attr 'x', 150
      .attr 'y', size / 2 + 20
      .attr 'dy', '.33em'
      .text "遵义"
      .style 'font-size', size
      .style 'fill', '#ffffff'

    panel
      .append 'text'
      .attr 'x', 220
      .attr 'y', size / 2 + 20
      .attr 'dy', '.33em'
      .text "近期大雨"
      .style 'font-size', size
      .style 'fill', '#f66'

    panel
      .append 'text'
      .attr 'x', 380
      .attr 'y', size / 2 + 20
      .attr 'dy', '.33em'
      .text "2017-03-02"
      .style 'font-size', size
      .style 'fill', '#ff6'

    panel
      .append 'text'
      .attr 'x', 150
      .attr 'y', size / 2 + 80
      .attr 'dy', '.33em'
      .text "郑州"
      .style 'font-size', size
      .style 'fill', '#ffffff'

    panel
      .append 'text'
      .attr 'x', 220
      .attr 'y', size / 2 + 80
      .attr 'dy', '.33em'
      .text "近期大风"
      .style 'font-size', size
      .style 'fill', '#f66'

    panel
      .append 'text'
      .attr 'x', 380
      .attr 'y', size / 2 + 70
      .attr 'dy', '.33em'
      .text "2017-03-02"
      .style 'font-size', size
      .style 'fill', '#ff6'

BaseTile.register 'areas-bar', AreasBar