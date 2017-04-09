class AreasBar extends Graph
  draw: ->
    @svg = @draw_svg()
    @draw_stitle()
    @draw_infos()

  draw_stitle: ->
    size = 24

    @svg
      .append 'text'
      .attr 'x', 50
      .attr 'y', size / 2 + 30
      .attr 'dy', '.33em'
      .text "原料产地自然灾害预警"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

  draw_infos: ->
    panel = @svg.append('g')
      .style 'transform', 'translate(-30px, 70px)'


    @draw_info panel, 'img/dayu-0.png', '遵义', '近期大雨', '2017-03-02'
    @draw_info panel, 'img/dafeng-0.png', '郑州', '近期大风', '2017-03-02', 60

  draw_info: (panel, img, city, weather, date, y = 0)->

    size = 24

    panel
      .append 'image'
      .attr 'x', 80
      .attr 'y', size / 2 + y
      .attr 'xlink:href', img
      .attr 'height', 40 + 'px'
      .attr 'width', 40 + 'px'

    panel
      .append 'text'
      .attr 'x', 150
      .attr 'y', size / 2 + 20 + y
      .attr 'dy', '.33em'
      .text city
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    panel
      .append 'text'
      .attr 'x', 220
      .attr 'y', size / 2 + 20 + y
      .attr 'dy', '.33em'
      .text weather
      .style 'font-size', size + 'px'
      .style 'fill', '#f66'

    panel
      .append 'text'
      .attr 'x', 340
      .attr 'y', size / 2 + 20 + y
      .attr 'dy', '.33em'
      .text date
      .style 'font-size', size + 'px'
      .style 'fill', '#ffde00'


BaseTile.register 'areas-bar', AreasBar