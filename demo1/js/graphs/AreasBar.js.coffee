class AreasBar extends Graph
  draw: ->
    @svg = @draw_svg()

    @make_defs()
    @draw_flags()

    jQuery(document).on 'data-map:next-draw', =>
      @draw_flags()


  make_defs: ->
    # https://www.w3cplus.com/svg/svg-linear-gradients.html

    defs = @svg.append('defs')
    lg = defs.append('linearGradient')
      .attr 'id', 'areas-bar-linear'
      .attr 'x1', '0%'
      .attr 'y1', '0%'
      .attr 'x2', '100%'
      .attr 'y2', '0%'

    lg.append('stop')
      .attr 'offset', '0%'
      .attr 'stop-color', '#7184a3'

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', '#f9f9f7'

  draw_flags: ->
    @flags.remove() if @flags

    @flags = @svg.append('g')

    farr = ['xinjiapo', 'yindu', 'yuenan', 'malai', 'yinni']
    amounts = [6324210, 6004324, 5132828, 4078910, 3876152]
    names = ['新加坡', '印度', '越南', '马来西亚', '印尼']

    max = 6424210

    h = @height / 5
    w = @width * 0.8
    for f, idx in farr
      @draw_flag @flags, f, h, w, idx, amounts, max, names

  draw_flag: (flags, f, h, w, idx, amounts, max, names)->
    flag = flags
      .append 'image'
      .attr 'xlink:href', "img/#{f}.png"
      .attr 'height', h - 30
      .attr 'width', (h - 30) / 2 * 3
      .attr 'x', 0
      .attr 'y', h * idx + 30

    offl = 90

    amount = amounts[idx]
    bh = h - 40
    bw = w * (amount / max)
    bar = flags
      .append('rect')
      .attr 'fill', 'url(#areas-bar-linear)'
      .attr 'width', bw
      .attr 'height', bh
      .attr 'x', offl
      .attr 'y', h * idx + 30 + 5

    th = 24
    text = flags
      .append 'text'
      .attr 'fill', '#011224'
      .attr 'x', offl + 5
      .attr 'y', h * idx + 30 + 5 + bh / 2
      .attr 'dy', '.33em'
      .style 'font-size', th + 'px'
      .text names[idx]

    th1 = 30
    text1 = flags
      .append 'text'
      .attr 'fill', '#011224'
      .attr 'text-anchor', 'end'
      .attr 'x', offl + bw - 5
      .attr 'y', h * idx + 30 + 5 + bh / 2
      .attr 'dy', '.33em'
      .style 'font-size', th1 + 'px'
      .style 'font-weight', 'bold'
      .text amount

    jQuery({w: 100}).animate({w: bw}
      {
        step: (now)->
          bar.attr 'width', now
          text1.attr 'x', offl + now - 5
        duration: 1000
      }
    )

    jQuery({a: 0}).animate({a: amount}
      {
        step: (now)->
          text1.text Math.floor(now)
        duration: 1000
      }
    )

BaseTile.register 'areas-bar', AreasBar