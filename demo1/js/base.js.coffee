# 常用颜色
window.COLOR_IN = 'rgba(149, 222, 255, 0.9)'
window.COLOR_OUT = 'rgba(65, 196, 255, 0.9)'

window.COLOR_BALANCE = 'rgba(231, 255, 149, 0.9)'
window.COLOR_BALANCE_OVERLOAD = 'rgba(243, 157, 119, 0.9)'

window.COLOR_BALANCE_DEEP = 'rgba(138, 152, 89, 0.9)'

window.BG_COLOR = '#17243C'
window.GOOD_COLOR = '#97FF41'
window.BAD_COLOR = '#FF7C41'

# 图块基类
window.BaseTile = class BaseTile
  @init: ->
    $root = jQuery('body > .paper')
    $root.css
      position: 'relative'
      width: 1920
      height: 1080

    r = ($tile, $parent)->
      [tl, tt, tw, th] = $tile.data('layout')

      offl = parseInt $parent.css('padding-left')
      offt = parseInt $parent.css('padding-top')
      offr = parseInt $parent.css('padding-right')
      offb = parseInt $parent.css('padding-bottom')

      pw = $parent.width()
      ph = $parent.height()

      $tile.css
        left:   pw / 24 * tl + offl
        top:    ph / 24 * tt + offt
        width:  pw / 24 * tw
        height: ph / 24 * th

      $tile.find('> .tile').each (idx, dom)->
        r jQuery(dom), $tile

    $root.find('> .tile').each (idx, dom)->
      r jQuery(dom), $root



  draw_svg: ->
    @width = @$elm.width()
    @height = @$elm.height()
    @svg = d3.select(@$elm[0]).append('svg')
      .attr 'width', @width
      .attr 'height', @height


