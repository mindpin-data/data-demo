class OneArea extends Graph
  draw: ->
    @svg = @draw_svg()

    @current_area = 'lajiao'

    @draw_flag()
    @draw_texts()

  draw_flag: ->
    @svg.select('g.flag').remove()
    flag = @svg.append('g')
      .attr 'class', 'flag'

    flag
      .append 'circle'
      .attr 'r', @height / 4
      .attr 'cx', 80
      .attr 'cy', @height / 2
      .attr 'fill', 'rgb(255, 87, 87)'

    flag
      .append 'image'
      .attr 'href', "img/icon-lajiao1.png"
      .attr 'height', @height / 5 * 2
      .attr 'x', 80 - @height / 5
      .attr 'y', @height / 2 - @height / 5

  draw_texts: ->
    @svg.select('g.texts').remove()

    texts = @svg.append('g')
      .attr 'class', 'texts'
      .style 'transform', 'translate(160px, 48px)'

    size = 20
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 10
      .attr 'dy', '.33em'
      .text "即时采购价格"
      .style 'font-size', size
      .style 'fill', '#ffffff'

    texts
      .append 'text'
      .attr 'x', 130
      .attr 'y', size / 2 + 10
      .attr 'dy', '.33em'
      .text 4900045.23
      .style 'font-size', size
      .style 'fill', '#ffff05'

    texts
      .append 'text'
      .attr 'x', 245
      .attr 'y', size / 2 + 10
      .attr 'dy', '.33em'
      .text "元"
      .style 'font-size', size
      .style 'fill', '#ffffff'


    size = 20
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 10 + 40
      .attr 'dy', '.33em'
      .text "去年同期价格"
      .style 'font-size', size
      .style 'fill', '#ffffff'

    texts
      .append 'text'
      .attr 'x', 130
      .attr 'y', size / 2 + 10 + 40
      .attr 'dy', '.33em'
      .text 501782.52
      .style 'font-size', size
      .style 'fill', '#ffff05'

    texts
      .append 'text'
      .attr 'x', 245
      .attr 'y', size / 2 + 10 + 40
      .attr 'dy', '.33em'
      .text "元"
      .style 'font-size', size
      .style 'fill', '#ffffff'      

    size = 20
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 10 + 80
      .attr 'dy', '.33em'
      .text "当前指导价格"
      .style 'font-size', size
      .style 'fill', '#ffffff'

    texts
      .append 'text'
      .attr 'x', 130
      .attr 'y', size / 2 + 10 + 80
      .attr 'dy', '.33em'
      .text 620521.78
      .style 'font-size', size
      .style 'fill', '#ffff05'

    texts
      .append 'text'
      .attr 'x', 245
      .attr 'y', size / 2 + 10 + 80
      .attr 'dy', '.33em'
      .text "元"
      .style 'font-size', size
      .style 'fill', '#ffffff'   


    texts
      .append 'text'
      .attr 'x', 275
      .attr 'y', size / 2 + 10
      .attr 'dy', '.33em'
      .text "2.34%"
      .style 'font-size', size
      .style 'fill', '#ffffff'

    texts
      .append 'image'
      .attr 'x', 335
      .attr 'y', size / 2 + 10 - size / 2
      .attr 'href', 'img/downicon1.png'
      .attr 'height', size



BaseTile.register 'one-area', OneArea