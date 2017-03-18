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

    @time_loop()

  time_loop: ->
    @aidx = 0
    setInterval =>
      @aidx += 1
      @aidx = 0 if @aidx == toggle_areas.length
      @current_area = toggle_areas[@aidx]

      @draw_flag()
      @draw_texts()
    , 5000

  draw_flag: ->
    @svg.select('g.flag').remove()
    flag = @svg.append('g')
      .attr 'class', 'flag'

    flag
      .append 'image'
      .attr 'href', "img/#{@current_area}.png"
      .attr 'height', @height - 60
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
      .style 'font-size', size
      .style 'fill', '#ffffff'

    size1 = 50
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + size + 40
      .attr 'dy', '.33em'
      .text area_data[@current_area].d
      .style 'font-size', size1
      .style 'fill', '#ffff05'

    size2 = 40
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + size + 34 + size1 + 30
      .attr 'dy', '.33em'
      .text "同比 #{area_data[@current_area].p}%"
      .style 'font-size', size2
      .style 'fill', '#ffffff'

    texts
      .append 'image'
      .attr 'x', 215
      .attr 'y', size / 2 + size + 34 + size1 + 30 - size2 / 2
      .attr 'href', 'img/upicon1.png'
      .attr 'height', size2



BaseTile.register 'one-area', OneArea