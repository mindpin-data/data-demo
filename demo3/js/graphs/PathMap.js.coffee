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
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features

      @draw_map()

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
        return 'rgba(136, 204, 236, 0.5)' if d.id == 'CHN'
        # return 'rgba(255, 216, 40, 1)' if d.id == @current_area
        # return 'rgba(136, 204, 236, 0.5)' if @areas.indexOf(d.id) > -1
        return 'rgba(136, 204, 236, 0.1)'


BaseTile.register 'path-map', PathMap