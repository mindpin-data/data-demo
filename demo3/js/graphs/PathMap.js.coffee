class PathMap extends Graph
  draw: ->
    @svg = @draw_svg()

    @load_data()

  load_data: ->
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features

      @draw_map()
      @draw_heatmap()

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @projection = d3.geoMercator()
      .center [105, 38]
      .scale @width * 0.3
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
      # .style 'stroke', 'rgba(136, 204, 236, 1)'
      .style 'stroke', (d)=>
        return 'rgba(120, 180, 208, 1)'

      .style 'stroke-width', 2
      .style 'fill', (d)=>
        return 'rgba(136, 204, 236, 0.2)' if d.id == 'CHN'
        # return 'rgba(255, 216, 40, 1)' if d.id == @current_area
        # return 'rgba(136, 204, 236, 0.5)' if @areas.indexOf(d.id) > -1
        return 'rgba(136, 204, 236, 0.1)'


  draw_heatmap: ->
    heatmapInstance = h337.create({
      # only container is required, the rest will be defaults
      container: jQuery('#heatmap')[0]
      radius: 24
      gradient:
        '0.2': '#28669b'
        '0.8': '#34cee9'
        '1.0': 'white'
    })

    points = []
    max = 0
    len = 600

    chn_feature = @features.filter((x)=> x.id == 'CHN')[0]

    # 经度数据比例尺
    xscale = d3.scaleLinear()
      .range [0, 1]
      .domain [73, 135]

    # console.log xscale 0

    yscale = d3.scaleLinear()
      .range [0, 2]
      .domain [53, 4]

    dscale = d3.scaleLinear()
      .range [-0.5, 0.5]
      .domain [0, 3]


    while len > 0
      lat = 73 + Math.random() * (135 - 73) # 生成经度范围内数据
      long = 4 + Math.random() * (53 - 4) # 生成纬度范围内数据

      if d3.geoContains(chn_feature, [lat, long]) # 在中国范围内
        len = len - 1

        val = Math.floor(150 + Math.random() * (451 - 150)) # 生成 150 ~ 450 区间的整形数据
        val = val * xscale lat
        val = val * yscale long

        [x, y] = @projection [lat, long] # 计算对应坐标

        point = {
          lat: lat
          long: long
          x: Math.floor(x * 100) / 100
          y: Math.floor(y * 100) / 100
          value: val
        }

        points.push point

    data = {
      max: 600
      data: points
    }

    heatmapInstance.setData(data)

    n = 0
    setInterval =>
      n++

      data.data = data.data.map (x, idx)=>
        delta = Math.floor(Math.random() * 20)
        p = dscale((idx + Math.floor(n / 100)) % 4)
        p = p * (xscale x.lat) * (yscale x.long)

        value = x.value + delta * p


        {
          lat: x.lat
          long: x.long
          x: x.x
          y: x.y
          value: value
        }


      heatmapInstance.setData(data)

    , 1000 / 60


BaseTile.register 'path-map', PathMap