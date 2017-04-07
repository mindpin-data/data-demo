cn_cities = [
  { name: '北京　', number: 7355291,  lat: 116.4, long: 39.9 }
  { name: '天津　', number: 3963604,  lat: 117.2, long: 39.1 }
  { name: '河北　', number: 20813492, lat: 114.3, long: 38.0 }
  { name: '山西　', number: 10654162, lat: 112.3, long: 37.6 }
  { name: '内蒙古', number: 8470472,  lat: 111.4, long: 40.5 }
  { name: '辽宁　', number: 15334912, lat: 123.3, long: 41.5 }
  { name: '吉林　', number: 9162183,  lat: 125.2, long: 43.5 }
  { name: '黑龙江', number: 13192935, lat: 126.4, long: 45.4 }
  { name: '上海　', number: 8893483,  lat: 121.2, long: 31.1 }
  { name: '江苏　', number: 25635291, lat: 118.5, long: 32.0 }
  { name: '浙江　', number: 20060115, lat: 120.2, long: 30.2 }
  { name: '安徽　', number: 19322432, lat: 117.2, long: 31.5 }
  { name: '福建　', number: 11971873, lat: 119.2, long: 26.0 }
  { name: '江西　', number: 11847841, lat: 115.6, long: 28.4 }  
  { name: '山东　', number: 30794664, lat: 117.0, long: 36.4 }  
  { name: '河南　', number: 26404973, lat: 113.4, long: 34.5 }  
  { name: '湖北　', number: 17253385, lat: 114.2, long: 30.3 }  
  { name: '湖南　', number: 19029894, lat: 112.6, long: 28.1 }  
  { name: '广东　', number: 32222752, lat: 113.2, long: 23.1 }  
  { name: '广西　', number: 13467663, lat: 108.2, long: 22.4 }  
  { name: '海南　', number: 2451819,  lat: 110.2, long: 20.0 }
  { name: '重庆　', number: 10272559, lat: 106.4, long: 29.5 }  
  { name: '四川　', number: 26383458, lat: 104.0, long: 30.4 }  
  { name: '贵州　', number: 10745630, lat: 106.4, long: 26.3 }  
  { name: '云南　', number: 12695396, lat: 102.4, long: 25.0 }  
  { name: '西藏　', number: 689521,   lat: 91.1,  long: 29.4 }
  { name: '陕西　', number: 11084516, lat: 108.6, long: 34.2 }  
  { name: '甘肃　', number: 7113833,  lat: 103.5, long: 36.0 }
  { name: '青海　', number: 1586635,  lat: 101.5, long: 36.3 }
  { name: '宁夏　', number: 1945064,  lat: 106.2, long: 38.3 }
  { name: '新疆　', number: 6902850,  lat: 87.4,  long: 43.5 }
  { name: '台湾　', number: 8222222,  lat: 121.3, long: 25.0 }
]

# 最大数量
max_number = 0
cn_cities.forEach (x)->
  max_number = Math.max(x.number, max_number)

# 循环执行
floop = (func, duration)->
  func()
  setInterval ->
    func()
  , duration

# 从数组中随机取一项
rand_item_of = (arr)->
  arr[Math.floor(arr.length * Math.random())]



class PathMap extends Graph
  draw: ->
    @svg = @draw_svg()

    @load_data()

  load_data: ->
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features

      @draw_map()
      # @draw_heatmap()

      @draw_circles()

      @random_city()
      @random_country()

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @map_scale = 0.16
    # @projection = d3.geoMercator()
    @projection = d3.geoEquirectangular()
      .center [5, 13]
      .scale @width * @map_scale
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
      .style 'stroke', '#021225'
      .style 'stroke-width', 1
      .style 'fill', '#323c48'

  draw_circles: ->
    cn_cities.forEach (p)=>
      [x, y] = @projection [p.lat, p.long] # 计算对应坐标

      oscale = d3.scaleLinear()
        .domain [0, max_number]
        .range [0, 1]

      circle = @g_map.append 'circle'
        .attr 'cx', x
        .attr 'cy', y
        .attr 'r', 8
        .attr 'fill', '#34cee9'
        .style 'opacity', oscale(p.number)

  random_city: ->
    floop =>
      p = rand_item_of cn_cities
      [x, y] = @projection [p.lat, p.long]

      @show_city_animate(x, y, '#cff1ae' ,4)
    , 1000

  random_country: ->
    floop =>
      feature = rand_item_of @features
      [x, y] = @path.centroid(feature)

      @show_city_animate(x, y, '#f1c4ae' ,4)
    , 2000

  circle_wave: (x, y, color, width, delay)->
    circle = @g_map.append 'circle'
      .attr 'cx', x
      .attr 'cy', y
      .attr 'stroke', color
      .attr 'stroke-width', width
      .attr 'fill', 'transparent'

    jQuery({ r: 5, o: 1 }).delay(delay).animate({ r: 50, o: 0 }
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

  show_city_animate: (x, y, color, width)->
    [gyx, gyy] = @projection [106.4, 26.3]

    @circle_wave(x, y, color, width, 0)
    @circle_wave(x, y, color, width, 500)
    @circle_wave(x, y, color, width, 1000)


BaseTile.register 'path-map', PathMap