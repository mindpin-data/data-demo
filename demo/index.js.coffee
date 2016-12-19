jQuery ->
  w = jQuery('.paper').width() / 24
  h = jQuery('.paper').height() / 24

  jQuery('.g').each (idx, g)->
    $g = jQuery(g)
    if pos = $g.data('pos')
      $g.css
        left:   pos[0] * w
        top:    pos[1] * h
        width:  pos[2] * w
        height: pos[3] * h

  fn1()
  fn2()
  fn3()
  fn4()

fn1 = ->
  d3.json 'data/StockRecord.json?1', (error, _data)->
    now = new Date().getTime()
    data = _data.map (d, idx)->
      date = new Date(now + idx * 86400000)
      Object.assign {date: format_date(date, "MM-dd")}, d

    new AmountBar(jQuery('.g7'), data).draw()
    new AmountBar2(jQuery('.g3'), data).draw()
    new AmountPie(jQuery('.g6'), data).draw()

fn2 = ->
  d3.json 'data/MaterialBalanceAmount.json?1', (error, _data)->
    data = _data.sort (a, b)->
      b.balance_amount - a.balance_amount

    new BalanceAmountPie(jQuery('.g5'), data).draw()

fn3 = ->
  d3.json 'data/china.json?1', (error, root)->
    # georoot = topojson.feature toporoot, toporoot.objects.china
    georoot = root

    # new ChinaMap(georoot).draw()

fn4 = ->
  new TotalStat(jQuery('.g11')).draw()
  new TotalStat1(jQuery('.g12')).draw()
  new TotalStat2(jQuery('.g13')).draw()