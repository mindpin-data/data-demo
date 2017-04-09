toggle_areas = [
  # 'THA', 'SGP', 'IND', 'VNM', 'MYS', 'IDN'
  'taiguo', 'yindu', 'yuenan', 'malai', 'yinni'
]

area_data = {
  taiguo: 
    d: 2817109
    n: '泰国'
    p: 14.3
  yinni: 
    d: 3876152
    n: '印尼'
    p: 15.4
  yuenan: 
    d: 5132828
    n: '越南'
    p: 16.5
  malai: 
    d: 4078910
    n: '马来西亚'
    p: 17.6
  yindu: 
    d: 6004324
    n: '印度'
    p: 18.7
}

# console.log area_data['taiguo']


class OneArea extends Graph
  draw: ->
    @svg = @draw_svg()

    @current_area = 'taiguo'

    @draw_flag()
    @draw_texts()

    jQuery(document).on 'data-map:next-draw', =>
      @next_draw()

  next_draw: ->
    @aidx = 0 if not @aidx?
    @aidx += 1
    @aidx = 0 if @aidx == toggle_areas.length
    @current_area = toggle_areas[@aidx]

    @draw_flag()
    @draw_texts()

  draw_flag: ->
    @svg.select('g.flag').remove()
    flag = @svg.append('g')
      .attr 'class', 'flag'

    flag
      .append 'image'
      .attr 'xlink:href', "img/#{@current_area}.png"
      .attr 'height', @height - 60
      .attr 'width', (@height - 60) / 2 * 3
      .attr 'x', 0
      .attr 'y', 30

  draw_texts: ->
    @svg.select('g.texts').remove()

    texts = @svg.append('g')
      .attr 'class', 'texts'
      .style 'transform', 'translate(260px, 0px)'

    size = 40
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 10
      .attr 'dy', '.33em'
      .text "#{area_data[@current_area].n}销量"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    size1 = 50
    number = texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + size + 40
      .attr 'dy', '.33em'
      .text 0
      .style 'font-size', size1 + 'px'
      .style 'fill', '#ffde00'

    jQuery({d: 0}).animate({d: area_data[@current_area].d}
      {
        step: (now)->
          number.text Math.floor(now)
        duration: 1000
      }
    )


    size2 = 40
    percent = texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + size + 34 + size1 + 30
      .attr 'dy', '.33em'
      .text "同比 #{0.0}%"
      .style 'font-size', size2 + 'px'
      .style 'fill', '#ffffff'

    jQuery({p: 0}).animate({p: area_data[@current_area].p}
      {
        step: (now)->
          t = Math.floor(now * 10) / 10
          t = "#{t}.0" if t == ~~t

          percent.text "同比 #{t}%"
        duration: 1000
      }
    )

    texts
      .append 'image'
      .attr 'x', 215
      .attr 'y', size / 2 + size + 34 + size1 + 30 - size2 / 2
      .attr 'xlink:href', 'img/upicon1.png'
      .attr 'height', size2
      .attr 'width', size2



BaseTile.register 'one-area', OneArea