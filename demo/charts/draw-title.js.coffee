window.COLOR_IN = '#95deff'
window.COLOR_OUT = '#41c4ff'
window.COLOR_DEEP = '#0088c5'
window.BG_COLOR = '#17243C'
window.GOOD_COLOR = '#97FF41'
window.BAD_COLOR = '#FF7C41'

window.DrawTitle = class DrawTitle
  draw_title: (title)->
    @title = @svg.append('g')
      .attr 'class', 'title'

    @title
      .append 'rect'
        .attr 'width', @width
        .attr 'height', @margin_top
        .attr 'fill', 'rgba(0, 0, 0, 0)'

    @title
      .append('text')
      .attr('dx', @width / 2)
      .attr('dy', @margin_top - 16)
      .attr 'text-anchor', 'middle'
      .text(title)

  rotate_pie: (path)->
    rotate = 0
    n = 0
    repeat = ->
      rotate += 36
      path
        .each -> n += 1
        .transition()
        .duration(1000)
        .ease d3.easeLinear
        .attr 'transform', "rotate(#{rotate})"
        .on 'end', ->
          n -= 1
          repeat() if n == 0

    repeat()