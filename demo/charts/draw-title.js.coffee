window.COLOR_IN = '#95deff'
window.COLOR_OUT = '#41c4ff'
window.COLOR_DEEP = '#0088c5'
window.BG_COLOR = '#17243C'
window.GOOD_COLOR = '#97FF41'
window.BAD_COLOR = '#FF7C41'
# window.PRE_COLOR = '#41FF85'
window.PRE_COLOR = '#FF7C41'

window.DrawTitle = class DrawTitle
  draw_svg: ->
    @width = @$elm.width()
    @height = @$elm.height()
    @svg = d3.select(@$elm[0]).append('svg')
      .attr 'width', @width
      .attr 'height', @height

  draw_title: (text)->
    text = @$elm.data('title') if not text?

    @title_height = 40

    title = @svg.append('g')
      .attr 'class', 'title'

    # title
    #   .append 'rect'
    #     .attr 'width', @width
    #     .attr 'height', @title_height

    title
      .append('text')
      .attr('dx', @width / 2)
      .attr('dy', @title_height / 2 + 16 / 2 - 2)
      .attr 'text-anchor', 'middle'
      .text(text)

  draw_gpanel: ->
    @gheight = @height - @title_height
    @gwidth = @width
    @gpanel = @svg.append('g')
      .attr 'transform', "translate(0, #{@title_height})"



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