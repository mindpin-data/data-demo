window.ChinaMap = class ChinaMap extends DrawTitle
  constructor: (@georoot)->
    @width = jQuery('.g8').width()
    @height = jQuery('.g8').height() - 20

    @margin_top = 40
    @margin_left = 240

  draw: ->
    @svg = d3.select('.g8').append 'svg'
      .attr 'width', @width
      .attr 'height', @height
      .attr 'style', "transform: translate(10px, 10px)"

    @bar_panel = @svg.append 'g'
      .attr 'transform', "translate(160, #{@margin_top * 2})"

    @bar_panel.append 'text'
      .style 'fill', 'white'
      .text '缺货情况'

    @draw_title('某品类供货地图')
    @draw_map()


  rand_data: ->
    rand = d3.randomUniform(-4, 10)

    @georoot.features.forEach (d)->
      d.rand = rand()

  draw_map: ->
    width = @width - @margin_left
    height = @height - @margin_top

    china = d3.select('.g8').append 'svg'
      .attr 'class', 'china-map'
      .attr 'width', width
      .attr 'height', height
      .style 'transform', "translate(#{@margin_left}px, #{@margin_top}px)"

    projection = d3.geoMercator()
      .center [104, 38]
      .scale width * 0.84
      .translate [width / 2, height / 2]

    path = d3.geoPath projection

    color = d3.scaleLinear()
      .domain [10, -10]
      .range [GOOD_COLOR, BAD_COLOR]

    @rand_data()
    provinces = china.selectAll('.province')
      .data @georoot.features
      .enter()
      .append 'path'
      .attr 'class', 'province'
      .style 'fill', (d)-> color d.rand
      .style 'stroke', BG_COLOR
      .style 'stroke-width', 1
      .attr 'd', path

    @rand_map provinces, color

  rand_map: (path, color)->
    n = 0

    repeat = =>
      @bar_panel.selectAll('.bar').remove()

      @draw_bar()
      @rand_data()
      
      path
        .each -> n += 1
        .transition()
        .duration(20000)
        .ease d3.easeLinear
        .style 'fill', (d)-> color d.rand
        .on 'end', ->
          n -= 1
          repeat() if n == 0

    repeat()

  draw_bar: ->
    width = @margin_left - 160
    data = @georoot.features
    data = data
      .map (d)-> 
        d.rand = - d.rand
        d
      .sort (a, b)-> b.rand - a.rand

    data = data[0..10]

    height = data.length * 32

    max = d3.max data.map (d)-> d.rand

    xscale = d3.scaleLinear()
      .domain [0, max]
      .range [0, width]

    yscale = d3.scaleBand()
      .domain data.map (d)-> d.properties.name
      .range([0, height])
      .paddingInner(0.2)
      .paddingOuter(0.2)

    bar_width = yscale.bandwidth()

    color = d3.scaleLinear()
      .domain [10, -10]
      .range [GOOD_COLOR, BAD_COLOR]

    @bar_panel.selectAll('.bar')
      .data data
      .enter().append 'rect'
      .attr 'class', 'bar'
      .attr 'height', bar_width
      .attr 'width', (d)-> 0
      .attr 'fill', (d)-> color -d.rand
      .attr 'transform', (d)->
        "translate(0, #{yscale(d.properties.name) + 16})"
      .transition()
      .duration(3000)
      .attr 'width', (d)-> xscale d3.max [d.rand, 0] 

    @axis_panel.remove() if @axis_panel
    @axis_panel = @svg.append 'g'
      .attr 'class', 'axis'
      .attr 'transform', "translate(160, #{@margin_top * 2 + 16})"
    @axis_panel.call d3.axisLeft(yscale)