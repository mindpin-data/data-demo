areas = [
  'KAZ', 'KGZ', 'TJK', 'IRN', 'TUR', 'RUS', 'DEU', 'NLD'
  'VNM', 'MYS', 'IDN', 'LKA', 'IND', 'KEN', 'GRC', 'ITA'

  'THA', 'SGP'
]

toggle_areas = [
  'THA' # 泰国 
  'IND' # 印度
  'VNM' # 越南
  'MYS' # 马来西亚
  'IDN' # 印尼
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
    @MAP_STROKE_COLOR = '#021225'
    @MAP_FILL_COLOR = '#323c48'
    @MAP_FILL_COLOR_YDYL = '#455363'
    @MAP_FILL_COLOR_CN = '#455363'
    @MAP_FILL_COLOR_CURRENT = '#2595AE'

    @svg = @draw_svg()

    @areas = areas
    @current_area = 'THA'
    @main_area = 'CHN'

    @load_data()

  load_data: ->
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features

      @init()

      # 第一层，地图
      @draw_map()
      
      # 第二层，一带一路城市和曲线（固定）
      @draw_cities()
      @draw_ydyl_curve()
      
      # 第三层，当前展示国家节点
      @draw_current_city()

  init: ->
    # http://s.4ye.me/ziMnfK
    @projection = d3.geoMercator()
      .center [68, 30]
      .scale @width * 0.42
      .translate [@width / 2, @height / 2]

    @path = d3.geoPath @projection

    # 地图
    @g_layer_map = @svg.append 'g'
    # 一带一路城市和曲线
    @g_layer_curve = @svg.append 'g'
    # 扩散光圈
    @g_layer_circles = @svg.append 'g'
    # 地图坐标
    @g_layer_map_point = @svg.append 'g'

    jQuery(document).on 'data-map:next-draw', =>
      @next_draw()


  next_draw: ->
    @aidx = 0 if not @aidx?

    @aidx += 1
    @aidx = 0 if @aidx == toggle_areas.length
    @current_area = toggle_areas[@aidx]

    @draw_map()
    @draw_current_city()

  draw_map: ->
    @countries.remove() if @countries?
    
    @countries = @g_layer_map.selectAll('.country')
      .data @features
      .enter()
      .append 'path'
      .attr 'class', 'country'
      .attr 'd', @path
      .attr 'stroke', @MAP_STROKE_COLOR
      .attr 'stroke-width', 1
      .attr 'fill', (d)=>
        # 中国
        return @MAP_FILL_COLOR_CN       if d.id == @main_area
        # 当前展示国家
        return @MAP_FILL_COLOR_CURRENT  if d.id == @current_area
        # 一带一路国家
        return @MAP_FILL_COLOR_YDYL     if @areas.indexOf(d.id) > -1
        # 其他国家
        return @MAP_FILL_COLOR

  draw_current_city: ->
    feature = @features.filter((x)=> x.id == @current_area)[0]

    if feature?
      if @current_area == 'MYS'
        [x, y] = @projection [101.8, 3.0]
      else if @current_area == 'IDN'
        [x, y] = @projection [106.9, -6.0]
      else if @current_area == 'VNM'
        [x, y] = @projection [105.9, 21.0]
      else
        [x, y] = @path.centroid(feature)
      @_draw_map_point(x, y)
      new CityAnimate(@g_layer_circles, x, y, '#ffde00', 8).run()


  _draw_map_point: (x, y)->
    @g_layer_map_point.selectAll('image').remove()
    @g_layer_map_point.append 'image'
      .attr 'class', 'map-point'
      .attr 'xlink:href', 'img/mapicon1.png'
      .attr 'x', x
      .attr 'y', y
      .style 'transform', 'translate(-30px, -50px)'
      .attr 'width', 60
      .attr 'height', 60

  draw_cities: ->
    _draw_city = (city)=>
      circle = @g_layer_curve.append 'circle'
        .attr 'class', 'runnin'
        .attr 'cx', city.x
        .attr 'cy', city.y
        .attr 'r', 8
        .attr 'fill', '#34cee9'

      ani = ->
        jQuery({r: 8, o: 1}).animate({r: 12, o: 0.5}
          {
            step: (now, fx)->
              if fx.prop == 'r'
                circle.attr 'r', now
              if fx.prop == 'o'
                circle.style 'opacity', now
            duration: 1000
            done: ->
              ani()
          }
        )

      ani()


    for city in cities_0
      [city.x, city.y] = @projection [city.long, city.lat]
      _draw_city city

    for city in cities_1
      [city.x, city.y] = @projection [city.long, city.lat]
      _draw_city city

  draw_ydyl_curve: ->
    # 一带一路曲线
    _draw_curve = (line, cities, color)=>
      @g_layer_curve.append 'path'
        .attr 'class', 'running'
        .datum cities
        .attr 'd', line
        .style 'stroke', color
        .style 'fill', 'transparent'
        .style 'stroke-width', 4
        .style 'stroke-dasharray', '5 10'
        .style 'stroke-linecap', 'round'

    line = d3.line()
      .x (d)=> d.x
      .y (d)=> d.y
      .curve(d3.curveCatmullRom.alpha(0.5))

    _draw_curve line, cities_0, '#cdff41'
    _draw_curve line, cities_1, '#ff7c41'



class CityAnimate
  constructor: (@layer, @x, @y, @color, @width, @img)->
    #

  run: ->
    @wave()


  # 在指定的位置用指定的颜色显示依次扩散的光圈
  wave: ->
    @circle_wave(500)
    @circle_wave(1500)
    @circle_wave(2500)
    @circle_wave(3500)

  # 在指定的位置用指定的颜色显示扩散光圈
  circle_wave: (delay)->
    circle = @layer.insert 'circle', '.map-point'
      .attr 'cx', @x
      .attr 'cy', @y
      .attr 'stroke', @color
      # .attr 'stroke-width', @width
      .attr 'fill', 'transparent'

    jQuery({ r: 10, o: 1, w: @width}).delay(delay).animate({ r: 100, o: 1, w: 0}
      {
        step: (now, fx)->
          if fx.prop == 'r'
            circle.attr 'r', now
          if fx.prop == 'o'
            circle.style 'opacity', now
          if fx.prop == 'w'
            circle.attr 'stroke-width', now

        duration: 3000
        easing: 'easeOutQuad'
        done: ->
          circle.remove()
      }
    )


BaseTile.register 'path-map', PathMap