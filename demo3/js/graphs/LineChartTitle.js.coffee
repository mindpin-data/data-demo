class LineChartTitle extends Graph
  draw: ->
    @svg = @draw_svg()

    @c1 = '#00c713'
    @c2 = '#578eff'
    @c3 = '#ff8711'

    @number_color = '#ffde00'

    @draw_texts()

    jQuery(document).on 'data-map:next-draw', =>
      @draw_texts()

  draw_texts: ->
    @texts.remove() if @texts?

    texts = @texts = @svg.append('g')
      .style 'transform', 'translate(1100px, 0px)'

    size = 40
    texts
      .append 'text'
      .attr 'x', -1050
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text '产品总体销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'


    t1 = texts
      .append 'text'
      .attr 'x', -1050 + 270
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text 889718890
      .style 'font-size', "#{size * 1.5}px"
      .style 'fill', @number_color

    jQuery({n: 0}).animate({n: 889718890}
      {
        step: (now)->
          t1.text ~~now
      }
    )


    texts
      .append 'text'
      .attr 'x', -1050 + 600
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text '产品出口销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'


    t2 = texts
      .append 'text'
      .attr 'x', -1050 + 600 + 270
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text 142210067
      .style 'font-size', "#{size * 1.5}px"
      .style 'fill', @number_color

    jQuery({n: 0}).animate({n: 142210067}
      {
        step: (now)->
          t2.text ~~now
      }
    )


    size = 20
    texts
      .append 'rect'
      .attr 'x', 250
      .attr 'y', @height / 2 - 7 + 30
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', @c1

    texts
      .append 'text'
      .attr 'x', 290
      .attr 'y', @height / 2 + 30
      .attr 'dy', '.33em'
      .text '实际销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', 390
      .attr 'y', @height / 2 - 7 + 30
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', @c2

    texts
      .append 'text'
      .attr 'x', 430
      .attr 'y', @height / 2 + 30
      .attr 'dy', '.33em'
      .text '预测销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', 530
      .attr 'y', @height / 2 - 7 + 30
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', @c3

    texts
      .append 'text'
      .attr 'x', 570
      .attr 'y', @height / 2 + 30
      .attr 'dy', '.33em'
      .text '上年同比销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'

BaseTile.register 'line-chart-title', LineChartTitle