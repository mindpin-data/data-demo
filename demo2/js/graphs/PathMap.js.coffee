data = [
  { lat: 103, long: 30, d: 30, type: 'lajiao'}
  { lat: 110, long: 29, d: 20, type: 'lajiao'}
  { lat: 106.9, long: 27.7, d: 25, type: 'lajiao'}
  { lat: 104, long: 26, d: 20, type: 'lajiao'}
  { lat: 106, long: 23, d: 20, type: 'lajiao'}

  { lat: 114.3, long: 28.7, d: 20, type: 'shengjiang'}
  { lat: 106.3, long: 29.6, d: 17, type: 'shengjiang'}
  { lat: 103.7, long: 26.8, d: 23, type: 'shengjiang'}
  { lat: 108.6, long: 25.5, d: 24, type: 'shengjiang'}

  { lat: 113.7, long: 34.6, d: 30, type: 'dadou'}
  { lat: 105.1, long: 28.7, d: 25, type: 'dadou'}
  { lat: 103.7, long: 26.8, d: 24, type: 'dadou'}
  { lat: 111.8, long: 24.4, d: 20, type: 'dadou'}
  { lat: 100.2, long: 23.1, d: 19, type: 'dadou'}
]

products = ['lajiao', 'shengjiang', 'dadou']


class PathMap extends Graph
  draw: ->
    @MAP_STROKE_COLOR = '#021225'
    @MAP_FILL_COLOR = '#323c48'
    # @MAP_FILL_COLOR = '#0f2438'

    @svg = @draw_svg()
    @load_data()

  load_data: ->
    d3.json 'data/china.json?1', (error, _data)=>
      @features = _data.features

      @init()

      @idx = 0
      @current_product = products[0]
      @draw_map()

      jQuery(document).on 'data-map:next-draw', =>
        @draw_next()

  draw_next: ->
    @idx += 1
    @idx = 0 if @idx == 3
    @current_product = products[@idx]

    @_draw_texts()
    @_draw_circle()

  init: ->
    # http://s.4ye.me/ziMnfK
    @projection = d3.geoMercator()
      .center [105, 28]
      .scale @width * 2.0
      .translate [@width / 2, @height / 2]

    @path = d3.geoPath @projection

    @layer_map = @svg.append 'g'
    @layer_circles = @svg.append 'g'
    @layer_icon = @svg.append 'g'

  draw_map: ->
    @_draw_map()
    @_draw_texts()
    @_draw_circle()
    @_draw_warning()

  _draw_texts: ->
    @texts.remove() if @texts?
    @texts = @layer_map.append 'g'

    _text = (color, text, y, opacity)=>
      panel = @texts.append 'g'
        .style 'transform', "translate(50px, #{@height - 150 + y}px)"
        .style 'opacity', opacity

      size = 24
      panel
        .append 'circle'
        .attr 'cx', 8
        .attr 'cy', 8
        .attr 'r', 16
        .attr 'fill', color

      panel
        .append 'text'
        .attr 'x', 36
        .attr 'y', size / 2 - 4
        .attr 'dy', '.33em'
        .text text
        .style 'font-size', size + 'px'
        .style 'fill', '#ffffff'

    _text '#f33', '辣椒原产地', 0, if @current_product == 'lajiao' then 1 else 0.3
    _text '#ff3', '生姜原产地', 50, if @current_product == 'shengjiang' then 1 else 0.3
    _text '#3f3', '大豆原产地', 100, if @current_product == 'dadou' then 1 else 0.3



  _draw_map: ->
    @areas.remove() if @areas?

    @areas = @layer_map.selectAll('.country')
      .data @features
      .enter()
      .append 'path'
      .attr 'class', 'country'
      .attr 'd', @path
      .style 'stroke', @MAP_STROKE_COLOR
      .style 'stroke-width', 1
      .style 'fill', @MAP_FILL_COLOR

  _draw_circle: ->
    @points.remove() if @points?
    points = @points = @layer_map.append 'g'

    for d in data
      [x, y] = @projection [d.lat, d.long]

      points.append 'circle'
        .attr 'class', 'chandi'
        .attr 'cx', x
        .attr 'cy', y
        .attr 'r', d.d
        .attr 'fill', =>
          return 'rgba(255, 51, 51, 0.7)' if d.type == 'lajiao'
          return 'rgba(255, 255, 51, 0.7)' if d.type == 'shengjiang'
          return 'rgba(51, 255, 51, 0.7)' if d.type == 'dadou'
        .style 'opacity', =>
          if d.type == @current_product then 1 else 0.05

  _draw_warning: ->
    console.log 'warning'
    [x, y] = @projection [113.7, 34.6]
    new CityAnimate(@, x, y, '#ffffff', 8, 'img/dafeng.png', '郑州：近期大风').run()

    [x, y] = @projection [106.9, 27.7]
    new CityAnimate(@, x, y, '#ffffff', 8, 'img/dayu.png', '遵义：近期大雨').run()


class CityAnimate
  constructor: (@map, @x, @y, @color, @width, @img, @text)->
    @layer_icon = @map.layer_icon
    @layer_circles = @map.layer_circles

  run: ->
    w = 60
    @layer_icon.append 'image'
      .attr 'xlink:href', @img
      .attr 'x', @x
      .attr 'y', @y
      .style 'transform', "translate(-#{w / 2}px, -#{w / 2}px)"
      .attr 'width', w
      .attr 'height', w

    size = 20
    @layer_icon.append 'text'
      .attr 'x', @x + 50
      .attr 'y', @y
      .attr 'dy', '.33em'
      .text @text
      .style 'font-size', size + 'px'
      .style 'fill', '#f66'

    @wave()


  # 在指定的位置用指定的颜色显示三个依次扩散的光圈
  wave: ->
    @circle_wave(0)
    @timer = setInterval =>
      @circle_wave(0)
    , 500

  stop: ->
    clearInterval @timer

  # 在指定的位置用指定的颜色显示扩散光圈
  circle_wave: (delay)->
    circle = @layer_circles.insert 'circle', '.map-point'
      .attr 'cx', @x
      .attr 'cy', @y
      .attr 'stroke', @color
      .attr 'stroke-width', @width
      .attr 'fill', 'transparent'

    jQuery({ r: 10, o: 1, w: @width }).delay(delay).animate({ r: 100, o: 0.6, w: 0 }
      {
        step: (now, fx)->
          if fx.prop == 'r'
            circle.attr 'r', now
          if fx.prop == 'o'
            circle.style 'opacity', now
          if fx.prop == 'w'
            circle.attr 'stroke-width', now

        duration: 2000
        easing: 'easeOutQuad'
        done: ->
          circle.remove()
      }
    )



BaseTile.register 'path-map', PathMap