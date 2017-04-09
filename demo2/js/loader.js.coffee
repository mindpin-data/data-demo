jQuery ->
  BaseTile.paper_init()

  setInterval ->
    jQuery(document).trigger('data-map:next-draw')
  , 5000