data = [
  { lat: 103, long: 30, d: 30, type: 1}
  { lat: 110, long: 29, d: 20, type: 1}
  { lat: 106.9, long: 27.7, d: 25, type: 1}
  { lat: 104, long: 26, d: 20, type: 1}
  { lat: 106, long: 23, d: 20, type: 1}

  { lat: 114.3, long: 28.7, d: 20, type: 2}
  { lat: 106.3, long: 29.6, d: 17, type: 2}
  { lat: 103.7, long: 26.8, d: 23, type: 2}
  { lat: 108.6, long: 25.5, d: 24, type: 2}

  { lat: 113.7, long: 34.6, d: 30, type: 3}
  { lat: 105.1, long: 28.7, d: 25, type: 3}
  { lat: 103.7, long: 26.8, d: 24, type: 3}
  { lat: 111.8, long: 24.4, d: 20, type: 3}
  { lat: 100.2, long: 23.1, d: 19, type: 3}
]




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

      @draw_map()

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @projection = d3.geoMercator()
      .center [105, 28]
      .scale @width * 2.0
      .translate [@width / 2, @height / 2]

    @path = d3.geoPath @projection

    @g_map = @svg.append 'g'

    @_draw_map()
    @_draw_texts()
    @_draw_circle()

  _draw_texts: ->
    panel = @svg.append 'g'
      .style 'transform', "translate(50px, #{@height - 150}px)"

    size = 24
    panel
      .append 'circle'
      .attr 'cx', 8
      .attr 'cy', 8
      .attr 'r', 16
      .attr 'fill', '#f33'

    panel
      .append 'text'
      .attr 'x', 36
      .attr 'y', size / 2 - 4
      .attr 'dy', '.33em'
      .text "辣椒原产地"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'


    panel = @svg.append 'g'
      .style 'transform', "translate(50px, #{@height - 150 + 50}px)"

    size = 24
    panel
      .append 'circle'
      .attr 'cx', 8
      .attr 'cy', 8
      .attr 'r', 16
      .attr 'fill', '#ff3'

    panel
      .append 'text'
      .attr 'x', 36
      .attr 'y', size / 2 - 4
      .attr 'dy', '.33em'
      .text "生姜原产地"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'


    panel = @svg.append 'g'
      .style 'transform', "translate(50px, #{@height - 150 + 100}px)"

    size = 24
    panel
      .append 'circle'
      .attr 'cx', 8
      .attr 'cy', 8
      .attr 'r', 16
      .attr 'fill', '#3f3'

    panel
      .append 'text'
      .attr 'x', 36
      .attr 'y', size / 2 - 4
      .attr 'dy', '.33em'
      .text "大豆原产地"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'



  _draw_map: ->
    @g_map.selectAll('.country').remove()
    countries = @g_map.selectAll('.country')
      .data @features
      .enter()
      .append 'path'
      .attr 'class', 'country'
      .attr 'd', @path
      .style 'stroke', @MAP_STROKE_COLOR
      .style 'stroke-width', 2
      .style 'fill', @MAP_FILL_COLOR

  _draw_circle: ->
    points = @svg.append 'g'

    for d in data
      [x, y] = @projection [d.lat, d.long]

      @g_map.append 'circle'
        .attr 'class', 'chandi'
        .attr 'cx', x
        .attr 'cy', y
        .attr 'r', d.d
        .attr 'fill', =>
          return 'rgba(255, 51, 51, 0.7)' if d.type == 1
          return 'rgba(255, 255, 51, 0.7)' if d.type == 2
          return 'rgba(51, 255, 51, 0.7)' if d.type == 3

    [x, y] = @projection [113.7, 34.6]
    new CityAnimate(@, x, y, '#ff9999', 8, 'img/大雨.png').run()

    [x, y] = @projection [106.9, 27.7]
    new CityAnimate(@, x, y, '#ff9999', 8, 'img/大风.png').run()


class CityAnimate
  constructor: (@map, @x, @y, @color, @width, @img)->
    @g_map = @map.g_map

  run: ->
    @g_map.append 'image'
      .attr 'class', 'map-point'
      .attr 'href', @img
      .attr 'x', @x
      .attr 'y', @y
      .style 'transform', 'translate(-30px, -50px)'
      .attr 'width', 60
      .attr 'height', 60

    @wave()


  # 在指定的位置用指定的颜色显示三个依次扩散的光圈
  wave: ->
    @circle_wave(0)
    @timer = setInterval =>
      @circle_wave(0)
    , 500

  # 在指定的位置用指定的颜色显示扩散光圈
  circle_wave: (delay)->
    circle = @g_map.insert 'circle', '.map-point'
      .attr 'cx', @x
      .attr 'cy', @y
      .attr 'stroke', @color
      .attr 'stroke-width', @width
      .attr 'fill', 'transparent'

    jQuery({ r: 10, o: 1 }).delay(delay).animate({ r: 100, o: 0 }
      {
        step: (now, fx)->
          if fx.prop == 'r'
            circle.attr 'r', now
          if fx.prop == 'o'
            circle.style 'opacity', now

        duration: 2000
        easing: 'easeOutQuad'
        done: ->
          circle.remove()
      }
    )



BaseTile.register 'path-map', PathMap