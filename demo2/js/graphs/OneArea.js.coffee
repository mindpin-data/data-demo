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
      .attr 'xlink:href', "img/icon-lajiao1.png"
      .attr 'height', @height / 6 * 2
      .attr 'width', @height / 6 * 2
      .attr 'x', 80 - @height / 6
      .attr 'y', @height / 2 - @height / 6

  draw_texts: ->
    @svg.select('g.texts').remove()

    texts = @svg.append('g')
      .attr 'class', 'texts'
      .style 'transform', 'translate(160px, 48px)'

    @draw_text texts, '即时采购价', 4.122, 0, true
    @draw_text texts, '去年同期价', 4.782, 40
    @draw_text texts, '当前指导价', 4.339, 80


  draw_text: (texts, label, number, y, flag = false)->
    size = 20
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 10 + y
      .attr 'dy', '.33em'
      .text label
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    texts
      .append 'text'
      .attr 'x', 110
      .attr 'y', size / 2 + 10 + y
      .attr 'dy', '.33em'
      .text number
      .style 'font-size', size + 'px'
      .style 'fill', '#ffde00'

    texts
      .append 'text'
      .attr 'x', 170
      .attr 'y', size / 2 + 10 + y
      .attr 'dy', '.33em'
      .text "万元 / 吨"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    if flag
      texts
        .append 'text'
        .attr 'x', 270
        .attr 'y', size / 2 + 10 + y
        .attr 'dy', '.33em'
        .text "2.34‰"
        .style 'font-size', size + 'px'
        .style 'fill', '#ffffff'

      texts
        .append 'image'
        .attr 'x', 330
        .attr 'y', size / 2 + 10 - size / 2 + y
        .attr 'xlink:href', 'img/downicon1.png'
        .attr 'height', size
        .attr 'width', size



BaseTile.register 'one-area', OneArea