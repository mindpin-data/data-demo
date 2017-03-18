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
    @svg = @draw_svg()

    @load_data()

  load_data: ->
    d3.json 'data/china.json?1', (error, _data)=>
      @features = _data.features

      @draw_map()

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @projection = d3.geoMercator()
      .center [105, 38]
      .scale @width * 0.85
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
      .style 'font-size', size
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
      .style 'font-size', size
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
      .style 'font-size', size
      .style 'fill', '#ffffff'



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
        # return 'rgba(136, 204, 236, 0.7)' if d.id == @main_area
        # return 'rgba(255, 216, 40, 1)' if d.id == @current_area
        # return 'rgba(136, 204, 236, 0.5)' if @areas.indexOf(d.id) > -1
        return 'rgba(136, 204, 236, 0.1)'

  _draw_circle: ->
    points = @svg.append 'g'

    for d in data
      [x, y] = @projection [d.lat, d.long]

      points.append 'circle'
        .attr 'class', 'chandi'
        .attr 'cx', x
        .attr 'cy', y
        .style 'r', d.d
        .attr 'fill', =>
          return 'rgba(255, 51, 51, 0.7)' if d.type == 1
          return 'rgba(255, 255, 51, 0.7)' if d.type == 2
          return 'rgba(51, 255, 51, 0.7)' if d.type == 3

    [x, y] = @projection [113.7, 34.6]
    points.append 'circle'
      .attr 'class', 'warning'
      .attr 'cx', x
      .attr 'cy', y
      .attr 'fill', 'rgba(255, 51, 51, 0.7)'

    points.append 'circle'
      .attr 'class', 'warning a'
      .attr 'cx', x
      .attr 'cy', y
      .attr 'fill', 'rgba(255, 51, 51, 0.7)'

    points.append 'image'
      .attr 'class', 'map-point'
      .attr 'href', 'img/大风.png'
      .attr 'x', x
      .attr 'y', y
      .style 'transform', 'translate(-30px, -50px)'
      .attr 'width', 60
      .attr 'height', 60

    [x, y] = @projection [106.9, 27.7]
    points.append 'circle'
      .attr 'class', 'warning'
      .attr 'cx', x
      .attr 'cy', y
      .attr 'fill', 'rgba(255, 51, 51, 0.7)'

    points.append 'circle'
      .attr 'class', 'warning a'
      .attr 'cx', x
      .attr 'cy', y
      .attr 'fill', 'rgba(255, 51, 51, 0.7)'

    points.append 'image'
      .attr 'class', 'map-point'
      .attr 'href', 'img/大雨.png'
      .attr 'x', x
      .attr 'y', y
      .style 'transform', 'translate(-30px, -50px)'
      .attr 'width', 60
      .attr 'height', 60

BaseTile.register 'path-map', PathMap