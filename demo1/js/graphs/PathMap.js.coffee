class PathMap extends Graph
  draw: ->
    @svg = @draw_svg()

    @areas = [
      'THA', 'SGP', 'IND', 'VNM', 'MYS', 'IDN'
      # 'MMR', 'LAO', 'KHM', 'NPL'
      'MMR'
      'KAZ', 'UKR', 'TUR'
    ]

    @load_data()

  load_data: ->
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features
      console.log @features.map (x)-> x.id

      @draw_map()
      @draw_running_lines()

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @projection = d3.geoMercator()
      .center [80, 26]
      .scale @width * 0.5
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
        return 'rgba(136, 204, 236, 0.6)' if d.id == 'CHN'
        return 'rgba(255, 216, 40, 1)' if d.id == 'MMR'
        return 'rgba(136, 204, 236, 0.4)' if @areas.indexOf(d.id) > -1
        return 'rgba(136, 204, 236, 0.1)'

      # .style 'fill', (d)=>
      #   # return @color_gen(d.lack1) if d.lack1 > 0
      #   return 'transparent'
      # .style 'stroke', COLOR_IN
      # .style 'stroke-width', 3
      # .attr 'd', path

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