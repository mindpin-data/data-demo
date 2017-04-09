plane_path = 'm25.21488,3.93375c-0.44355,0 -0.84275,0.18332 -1.17933,0.51592c-0.33397,0.33267 -0.61055,0.80884 -0.84275,1.40377c-0.45922,1.18911 -0.74362,2.85964 -0.89755,4.86085c-0.15655,1.99729 -0.18263,4.32223 -0.11741,6.81118c-5.51835,2.26427 -16.7116,6.93857 -17.60916,7.98223c-1.19759,1.38937 -0.81143,2.98095 -0.32874,4.03902l18.39971,-3.74549c0.38616,4.88048 0.94192,9.7138 1.42461,13.50099c-1.80032,0.52703 -5.1609,1.56679 -5.85232,2.21255c-0.95496,0.88711 -0.95496,3.75718 -0.95496,3.75718l7.53,-0.61316c0.17743,1.23545 0.28701,1.95767 0.28701,1.95767l0.01304,0.06557l0.06002,0l0.13829,0l0.0574,0l0.01043,-0.06557c0,0 0.11218,-0.72222 0.28961,-1.95767l7.53164,0.61316c0,0 0,-2.87006 -0.95496,-3.75718c-0.69044,-0.64577 -4.05363,-1.68813 -5.85133,-2.21516c0.48009,-3.77545 1.03061,-8.58921 1.42198,-13.45404l18.18207,3.70115c0.48009,-1.05806 0.86881,-2.64965 -0.32617,-4.03902c-0.88969,-1.03062 -11.81147,-5.60054 -17.39409,-7.89352c0.06524,-2.52287 0.04175,-4.88024 -0.1148,-6.89989l0,-0.00476c-0.15655,-1.99844 -0.44094,-3.6683 -0.90277,-4.8561c-0.22699,-0.59493 -0.50356,-1.07111 -0.83754,-1.40377c-0.33658,-0.3326 -0.73578,-0.51592 -1.18194,-0.51592l0,0l-0.00001,0l0,0z'

plane_path = "M25 0 L50 50 L0 50 z"

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

world_cities = [
  { name: '莫斯科', number: 17355291,  lat: 37.4, long: 55.5 }
  { name: '柏林　', number: 17355291,  lat: 13.3, long: 52.3 }
  { name: '伦敦　', number: 17355291,  lat: 0.1,  long: 51.3 }
  { name: '巴黎　', number: 17355291,  lat: 2.2,  long: 48.5 }
  { name: '罗马　', number: 17355291,  lat: 12.3, long: 41.5 }
  { name: '华盛顿', number: 17355291,  lat: -77.0, long: 38.5 }
  { name: '首尔　', number: 17355291,  lat: 126.1, long: 37.3 }
  { name: '东京　', number: 17355291,  lat: 139.5, long: 35.4 }
  { name: '洛杉矶', number: 17355291,  lat: -118.2, long: 34.5 }
  { name: '新加坡', number: 17355291,  lat: 103.5, long: 1.2 }

  { name: '雅加达　　', number: 17355291,  lat: 106.5, long: -6.1 }
  { name: '里约热内卢', number: 17355291,  lat: -43.2, long: -22.5 }
  { name: '圣地亚哥　', number: 17355291,  lat: -70.4, long: -33.3 }
  { name: '悉尼　　　', number: 17355291,  lat: 151.1, long: -33.3 }
  { name: '奥克兰　　', number: 17355291,  lat: 174.5, long: -36.5 }
  { name: '墨尔本　　', number: 17355291,  lat: 144.6, long: -37.5 }
  { name: '新德里　　', number: 17355291,  lat: 77.2, long: 28.5 }
  { name: '开普敦　　', number: 17355291,  lat: 19.0, long: -34.0 }
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
    @MAP_STROKE_COLOR = '#021225'
    @MAP_FILL_COLOR = '#323c48'

    @svg = @draw_svg()
    @load_data()

    jQuery(document).on 'data-map:next-draw', =>
      @next_draw()

  next_draw: ->
    @random_city()

  load_data: ->
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features

      @draw_map()

      @draw_heatmap()
      # @draw_circles()

      @random_city()

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @map_scale = 0.16
    # @projection = d3.geoMercator()
    @projection = d3.geoEquirectangular()
      .center [8, 13]
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
      .style 'stroke', @MAP_STROKE_COLOR
      .style 'stroke-width', 1
      .style 'fill', @MAP_FILL_COLOR

  draw_circles: ->
    cities = [].concat(cn_cities).concat(world_cities)

    cities.forEach (p)=>
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

  draw_heatmap: ->
    heatmapInstance = h337.create({
      # only container is required, the rest will be defaults
      container: jQuery('#heatmap')[0]
      radius: 8
      gradient:
        '0.0': '#34cee9'
        '0.3': '#34cee9'
        '1.0': 'white'
    })

    cities = [].concat(cn_cities).concat(world_cities)
    points = cities.map (c)=>
      [x, y] = @projection [c.lat, c.long]

      {
        x: ~~x
        y: ~~y
        value: c.number
      }

    data = {
      max: max_number
      data: points
    }

    console.log points

    heatmapInstance.setData(data)

  random_city: ->
    @_r cn_cities, '#cff1ae'
    @_r cn_cities, '#cff1ae'
    @_r world_cities, '#f1c4ae'
    @_r world_cities, '#f1c4ae'

    setTimeout =>
      @_r cn_cities, '#cff1ae'
      @_r cn_cities, '#cff1ae'
      @_r world_cities, '#f1c4ae'
      @_r world_cities, '#f1c4ae'
    , 2500

  _r: (arr, color)->
    p = rand_item_of arr
    [x, y] = @projection [p.lat, p.long]
    new CityAnimate(this, x, y, color, 4).run()


class CityAnimate
  constructor: (@map, @x, @y, @color, @width)->
    @g_map = @map.g_map

  run: ->
    @flight_animate()

  # 飞机飞行动画
  flight_animate: ->
    [@gyx, @gyy] = @map.projection [106.4, 26.3]

    @draw_plane()
    @draw_route()
    @fly()

  # 在贵阳画一个小飞机
  draw_plane: ->
    @plane = @g_map.append 'path'
      .attr 'class', 'plane'
      .attr 'd', plane_path
      # .attr 'fill', '#ff8711'
      .attr 'fill', 'white'

  # 画贵阳到收货地的航线
  draw_route: ->
    @route = @g_map.append 'path'
      .attr 'd', "M#{@gyx} #{@gyy} L#{@x} #{@y}"
      # .attr 'x1', @gyx
      # .attr 'y1', @gyy
      # .attr 'x2', @x
      # .attr 'y2', @y
      # .style 'stroke', 'rgb(255, 132, 65)'
      .style 'stroke', 'transparent'

  # 飞行
  fly: ->
    path = @route.node()
    l = path.getTotalLength()

    dx = @x - @gyx
    dy = @y - @gyy
    r = 90 - Math.atan2(-dy, dx) * 180 / Math.PI

    scale = 0.3
    xoff = 50 * scale * 0.5
    yoff = 50 * scale * 0.5

    # @plane
    #   .transition()
    #   .duration l * 10
    #   .ease d3.easeCubicInOut
    #   .attrTween 'transform', =>
    #     (t)=>
    #       p = path.getPointAtLength(t * l)
    #       @route_circle_wave(p.x, p.y)
    #       "translate(#{p.x - xoff}, #{p.y - yoff}) rotate(#{r}, #{xoff}, #{yoff}) scale(#{scale})"

    #   .on 'end', =>
    #     @route.remove()
    #     @three_circles_wave()

    #     @plane
    #       .transition()
    #       .duration 1000
    #       .styleTween 'opacity', ->
    #         (t)->
    #           1 - t
    #       .on 'end', =>
    #         @plane.remove()

    count = 0
    jQuery({ t: 0 }).animate({ t: 1 }
      {
        step: (now, fx)=>
          p = path.getPointAtLength(now * l)

          count += 1
          if count % 4 == 0
            @route_circle_wave(p.x, p.y)
          
          @plane
            .attr 'transform', "translate(#{p.x - xoff}, #{p.y - yoff}) rotate(#{r}, #{xoff}, #{yoff}) scale(#{scale})"

        duration: Math.sqrt(l) * 150
        easing: 'linear'
        done: =>
          @route.remove()
          @three_circles_wave()

          jQuery({ o: 1 }).animate({ o: 0 }
            {
              step: (now, fx)=>
                @plane
                  .style 'opacity', now
              duration: 1000
              done: =>
                @plane.remove()
            }
          )
      }
    )

  # 在指定的位置用指定的颜色显示扩散光圈
  route_circle_wave: (x, y)->
    circle = @g_map.insert 'circle', '.plane'
      .attr 'cx', x
      .attr 'cy', y
      .attr 'stroke', @color
      .attr 'stroke-width', @width
      # .attr 'fill', 'transparent'
      .attr 'fill', @color

    jQuery({ r: 0, o: 0.9 }).delay(100).animate({ r: 5, o: 0 }
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



  # 在指定的位置用指定的颜色显示三个依次扩散的光圈
  three_circles_wave: ->
    @circle_wave(0)
    @circle_wave(500)
    @circle_wave(1000)

  # 在指定的位置用指定的颜色显示扩散光圈
  circle_wave: (delay)->
    circle = @g_map.append 'circle'
      .attr 'cx', @x
      .attr 'cy', @y
      .attr 'stroke', @color
      .attr 'stroke-width', @width
      .attr 'fill', 'transparent'

    # rscale = d3.scaleLinear()
    #   .domain [0, 1]
    #   .range [5, 40]

    # oscale = d3.scaleLinear()
    #   .domain [0, 1]
    #   .range [1, 0]

    # circle
    #   .transition()
    #   .ease d3.easeCubicOut
    #   .duration 2000
    #   .delay delay
    #   .attrTween 'r', (d)->
    #     (t)-> rscale(t)
    #   .styleTween 'opacity', (d)->
    #     (t)-> oscale(t)
    #   .on 'end', ->
    #     circle.remove()

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



BaseTile.register 'path-map', PathMap