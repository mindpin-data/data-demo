# 常用颜色
window.COLOR_IN = 'rgba(149, 222, 255, 0.9)'
window.COLOR_OUT = 'rgba(65, 196, 255, 0.9)'

window.COLOR_BALANCE = 'rgba(231, 255, 149, 0.9)'
window.COLOR_BALANCE_OVERLOAD = 'rgba(243, 157, 119, 0.9)'

window.COLOR_BALANCE_DEEP = 'rgba(138, 152, 89, 0.9)'

window.BG_COLOR = '#17243C'
window.GOOD_COLOR = '#97FF41'
window.BAD_COLOR = '#FF7C41'

Graphs = {}

# 图块基类
window.BaseTile = class BaseTile
  @register: (name, klass)->
    Graphs[name] = klass

  @paper_init: ->
    $root = jQuery('body > .paper')
    $root.css
      position: 'absolute'
      top: 0
      left: 0
      width: 1920
      height: 1080

    $root.find('> .tile').each (idx, dom)->
      tile = new BaseTile jQuery(dom), $root
      tile.init()

  constructor: (@$tile, @$parent)->
    @graph_name = @$tile.data('g')

  init: ->
    @init_layout()
    @draw() if @graph_name?

  init_layout: ->
    [tl, tt, tw, th] = @$tile.data('layout')

    offl = parseInt @$parent.css('padding-left')
    offt = parseInt @$parent.css('padding-top')
    offr = parseInt @$parent.css('padding-right')
    offb = parseInt @$parent.css('padding-bottom')

    pw = @$parent.width()
    ph = @$parent.height()

    @$tile.css
      left:   pw / 24 * tl + offl
      top:    ph / 24 * tt + offt
      width:  pw / 24 * tw
      height: ph / 24 * th

    @$tile.find('> .tile').each (idx, dom)=>
      tile = new BaseTile jQuery(dom), @$tile
      tile.init()

  draw: ->
    console.log('绘制', @graph_name)
    graph = Graphs[@graph_name]

    if not graph?
      console.log(@graph_name, '未注册')
      return

    new graph(@).draw()


window.Graph = class Graph
  constructor: (@tile)->
    @$tile = @tile.$tile
    @width = @$tile.width()
    @height = @$tile.height()

  draw_svg: ->
    d3.select(@$tile[0]).append('svg')
      .attr 'width', @width
      .attr 'height', @height

  draw: ->
    console.log('绘图方法未实现')



