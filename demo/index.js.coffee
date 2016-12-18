jQuery ->
  d3.json 'data/StockRecord.json?1', (error, _data)->
    now = new Date().getTime()
    data = _data.map (d, idx)->
      date = new Date(now + idx * 86400000)
      Object.assign {date: format_date(date, "MM-dd")}, d

    new AmountBar(data).draw()
    new AmountBar2(data).draw()
    new AmountPie(data).draw()

jQuery ->
  d3.json 'data/MaterialBalanceAmount.json?1', (error, _data)->
    data = _data.sort (a, b)->
      b.balance_amount - a.balance_amount

    new BalanceAmountPie(data).draw()

jQuery ->
  d3.json 'data/china.json', (error, root)->
    # georoot = topojson.feature toporoot, toporoot.objects.china
    georoot = root

    new ChinaMap(georoot).draw()

jQuery ->
  new TotalStat().draw()
  new TotalStat1().draw()
  new TotalStat2().draw()