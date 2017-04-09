# areas = [
#   'THA', 'SGP', 'IND', 'VNM', 'MYS', 'IDN'
#   # 'MMR', 'LAO', 'KHM', 'NPL'
#   'MMR'
#   'KAZ', 'UKR', 'TUR'
# ]

areas = [
  'KAZ', 'KGZ', 'TJK', 'IRN', 'TUR', 'RUS', 'DEU', 'NLD'
  'VNM', 'MYS', 'IDN', 'LKA', 'IND', 'KEN', 'GRC', 'ITA'

  'THA', 'SGP'
]

toggle_areas = [
  # 'THA', 'SGP', 'IND', 'VNM', 'MYS', 'IDN'
  'THA', 'IND', 'VNM', 'MYS', 'IDN'
]

cities_0 = [
  {c: '西安', lat: 34.34, long: 108.94}
  {c: '兰州', lat: 36.07, long: 103.84}
  {c: '乌鲁木齐', lat: 43.83, long: 87.62}
  {c: '霍尔果斯', lat: 44.21, long: 80.42}
  {c: '阿拉木图', lat: 43.24, long: 76.91} # 哈萨克斯坦
  {c: '比什凯克', lat: 42.87, long: 74.59} # 吉尔吉斯斯坦
  {c: '杜尚别', lat: 38.5, long: 68.9} # 塔吉克斯坦
  {c: '德黑兰', lat: 35.8, long: 51.0} # 伊朗
  {c: '伊斯坦布尔', lat: 41.0, long: 28.9} # 土耳其
  {c: '莫斯科', lat: 55.8, long: 37.6} # 俄罗斯
  {c: '杜伊斯堡', lat: 51.5, long: 6.8} # 德国
  {c: '鹿特丹', lat: 51.9, long: 4.5} # 荷兰
]

cities_1 = [
  {c: '福州', lat: 26.0, long: 119.0}
  {c: '泉州', lat: 24.9, long: 118.6}
  {c: '广州', lat: 23.0, long: 113.0}
  {c: '湛江', lat: 21.2, long: 110.3}
  {c: '海口', lat: 20.02, long: 110.35}
  {c: '北海', lat: 21.49, long: 109.12}
  {c: '河内', lat: 21.0, long: 105.9} # 越南
  {c: '吉隆坡', lat: 3.0, long: 101.8} # 马来西亚
  {c: '雅加达', lat: -6.0, long: 106.9} # 印度尼西亚
  {c: '科伦坡', lat: 6.9, long: 79.9} # 斯里兰卡
  {c: '加尔各答', lat: 22.5, long: 88.0} # 印度
  {c: '内罗毕', lat: 1.3, long: 36.8} # 肯尼亚
  {c: '雅典', lat: 38.0, long: 23.8} # 希腊
  {c: '威尼斯', lat: 45.5, long: 12.0} # 意大利
]


class PathMap extends Graph
  draw: ->
  draw: ->
    @MAP_STROKE_COLOR = '#021225'
    @MAP_FILL_COLOR = '#323c48'
    @MAP_FILL_COLOR_YDYL = '#455363'
    @MAP_FILL_COLOR_CN = '#455363'

    @svg = @draw_svg()

    @areas = areas
    @current_area = 'THA'
    @main_area = 'CHN'

    @load_data()

  load_data: ->
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features
      console.log @features.map (x)-> x.id

      @draw_map()
      # @draw_running_lines()
      @draw_cities()

      @time_loop()

  time_loop: ->
    @aidx = 0
    setInterval =>
      @aidx += 1
      @aidx = 0 if @aidx == toggle_areas.length
      @current_area = toggle_areas[@aidx]

      @_draw_map()
    , 5000

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @projection = d3.geoMercator()
      .center [68, 30]
      .scale @width * 0.42
      .translate [@width / 2, @height / 2]

    @path = d3.geoPath @projection

    @g_map = @svg.append 'g'

    @_draw_map()

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
      .style 'fill', (d)=>
        return @MAP_FILL_COLOR_CN if d.id == @main_area
        return 'rgba(52, 206, 233, 0.7)' if d.id == @current_area
        return @MAP_FILL_COLOR_YDYL if @areas.indexOf(d.id) > -1
        return @MAP_FILL_COLOR

    feature = @features.filter((x)=> x.id == @current_area)[0]

    if feature
      [x, y] = @path.centroid(feature)

      new CityAnimate(@, x, y, '#ff9999', 8).run()

      @g_map.selectAll('image').remove()
      @g_map.append 'image'
        .attr 'class', 'map-point'
        .attr 'xlink:href', 'img/mapicon1.png'
        .attr 'x', x
        .attr 'y', y
        .style 'transform', 'translate(-30px, -50px)'
        .attr 'width', 60
        .attr 'height', 60



  draw_cities: ->
    points = @svg#.append 'g'

    for city in cities_0
      [city.x, city.y] = @projection [city.long, city.lat]

      points.append 'circle'
        .attr 'class', 'runnin'
        .attr 'cx', city.x
        .attr 'cy', city.y
        .attr 'r', 8
        .attr 'fill', '#34cee9'

    for city in cities_1
      [city.x, city.y] = @projection [city.long, city.lat]

      points.append 'circle'
        .attr 'class', 'runnin'
        .attr 'cx', city.x
        .attr 'cy', city.y
        .attr 'r', 8
        .attr 'fill', '#34cee9'

    # 一带一路曲线
    line1 = d3.line()
      .x (d)=> d.x
      .y (d)=> d.y
      .curve(d3.curveCatmullRom.alpha(0.5))

    points.append 'path'
      .attr 'class', 'running'
      .datum cities_0
      .attr 'd', line1
      # .style 'stroke', '#ff7c41'
      .style 'stroke', 'rgb(205, 255, 65)'
      .style 'fill', 'transparent'
      .style 'stroke-width', 5
      .style 'stroke-dasharray', '5 10'
      .style 'stroke-linecap', 'round'

    points.append 'path'
      .attr 'class', 'running'
      .datum cities_1
      .attr 'd', line1
      .style 'stroke', '#ff7c41'
      # .style 'stroke', 'rgb(205, 255, 65)'
      .style 'fill', 'transparent'
      .style 'stroke-width', 5
      .style 'stroke-dasharray', '5 10'
      .style 'stroke-linecap', 'round'



class CityAnimate
  constructor: (@map, @x, @y, @color, @width, @img)->
    @g_map = @map.g_map

  run: ->
    @wave()


  # 在指定的位置用指定的颜色显示三个依次扩散的光圈
  wave: ->
    @circle_wave(0)
    @circle_wave(500)
    @circle_wave(1000)
    @circle_wave(1500)
    @circle_wave(2000)

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