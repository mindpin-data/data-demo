areas = [
  'THA', 'SGP', 'IND', 'VNM', 'MYS', 'IDN'
  # 'MMR', 'LAO', 'KHM', 'NPL'
  'MMR'
  'KAZ', 'UKR', 'TUR'
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
    @svg = @draw_svg()

    @areas = areas
    @current_area = 'MMR'
    @main_area = 'CHN'

    @load_data()

  load_data: ->
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features
      console.log @features.map (x)-> x.id

      @draw_map()
      # @draw_running_lines()
      @draw_cities()

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @projection = d3.geoMercator()
      .center [68, 30]
      .scale @width * 0.42
      .translate [@width / 2, @height / 2]

    @path = d3.geoPath @projection

    map = @svg.append 'g'

    countries = map.selectAll('.country')
      .data @features
      .enter()
      .append 'path'
      .attr 'class', 'country'
      .attr 'd', @path
      # .style 'stroke', 'rgba(136, 204, 236, 1)'
      .style 'stroke', 'rgba(120, 180, 208, 1)'
      .style 'stroke-width', 2
      .style 'fill', (d)=>
        return 'rgba(136, 204, 236, 0.6)' if d.id == @main_area
        return 'rgba(255, 216, 40, 1)' if d.id == @current_area
        return 'rgba(136, 204, 236, 0.4)' if @areas.indexOf(d.id) > -1
        return 'rgba(136, 204, 236, 0.1)'

      # .style 'fill', (d)=>
      #   # return @color_gen(d.lack1) if d.lack1 > 0
      #   return 'transparent'
      # .style 'stroke', COLOR_IN
      # .style 'stroke-width', 3
      # .attr 'd', path

  draw_cities: ->
    points = @svg.append 'g'


    for city in cities_0
      [city.x, city.y] = @projection [city.long, city.lat]

      points.append 'circle'
        .attr 'class', 'running'
        .attr 'cx', city.x
        .attr 'cy', city.y
        # .style 'r', 8
        .attr 'fill', 'rgb(255, 193, 65)'

    for city in cities_1
      [city.x, city.y] = @projection [city.long, city.lat]

      points.append 'circle'
        .attr 'class', 'running'
        .attr 'cx', city.x
        .attr 'cy', city.y
        # .style 'r', 8
        .attr 'fill', 'rgb(255, 193, 65)'


    line1 = d3.line()
      .x (d)=> d.x
      .y (d)=> d.y
      .curve(d3.curveCatmullRom.alpha(0.5))

    points.append 'path'
      .attr 'class', 'running'
      .datum cities_0
      .attr 'd', line1
      .style 'stroke', '#ff7c41'
      .style 'fill', 'transparent'
      .style 'stroke-width', 5
      .style 'stroke-dasharray', '20 20'
      .style 'stroke-linecap', 'round'

    points.append 'path'
      .attr 'class', 'running'
      .datum cities_1
      .attr 'd', line1
      .style 'stroke', '#ff7c41'
      .style 'fill', 'transparent'
      .style 'stroke-width', 5
      .style 'stroke-dasharray', '20 20'
      .style 'stroke-linecap', 'round'

  draw_running_lines: ->
    # 贵阳
    points = @svg.append 'g'

    [x0, y0] = @projection [106.71, 26.57]

    for area in @areas
      feature = @features.filter((x)-> x.id == area)[0]
      if feature
        [x, y] = @path.centroid(feature)

        points.append 'line'
          .attr 'class', 'running'
          .attr 'x1', x0
          .attr 'y1', y0
          .attr 'x2', x
          .attr 'y2', y
          .style 'stroke', 'rgb(255, 132, 65)'
          .style 'stroke-width', 4
          .style 'stroke-dasharray', '20 20'
          # .style 'stroke-dashoffset', '0'
          .style 'stroke-linecap', 'round'

        points.append 'circle'
          .attr 'class', 'running'
          .attr 'cx', x
          .attr 'cy', y
          # .style 'r', 8
          .attr 'fill', 'rgb(255, 193, 65)'

        points.append 'image'
          .attr 'href', 'img/mapicon1.png'
          .attr 'x', x
          .attr 'y', y
          .style 'transform', 'translate(-30px, -50px)'
          .attr 'width', 60
          .attr 'height', 60

    points.append 'circle'
      .attr 'cx', x0
      .attr 'cy', y0
      .attr 'r', 16
      .attr 'fill', 'rgb(255, 193, 65)'




BaseTile.register 'path-map', PathMap