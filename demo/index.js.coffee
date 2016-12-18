jQuery ->
  w = 1920 / 24
  h = 1080 / 24

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

    new AmountBar(data).draw()
    new AmountBar2(data).draw()
    new AmountPie(data).draw()

fn2 = ->
  d3.json 'data/MaterialBalanceAmount.json?1', (error, _data)->
    data = _data.sort (a, b)->
      b.balance_amount - a.balance_amount

    new BalanceAmountPie(data).draw()

fn3 = ->
  d3.json 'data/china.json', (error, root)->
    # georoot = topojson.feature toporoot, toporoot.objects.china
    georoot = root

    new ChinaMap(georoot).draw()

fn4 = ->
  new TotalStat().draw()
  new TotalStat1().draw()
  new TotalStat2().draw()