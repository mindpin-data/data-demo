(function() {
  window.format_date = function(date, fmt) {
    var k, o, v;
    o = {
      "M+": date.getMonth() + 1,
      "d+": date.getDate(),
      "h+": date.getHours(),
      "m+": date.getMinutes(),
      "s+": date.getSeconds(),
      "q+": Math.floor((date.getMonth() + 3) / 3),
      "S": date.getMilliseconds(),
      "w": ['日', '一', '二', '三', '四', '五', '六'][date.getDay()]
    };
    if (/(y+)/.test(fmt)) {
      fmt = fmt.replace(RegExp.$1, ("" + (date.getFullYear())).substr(4 - RegExp.$1.length));
    }
    for (k in o) {
      v = o[k];
      if (new RegExp("(" + k + ")").test(fmt)) {
        fmt = fmt.replace(RegExp.$1, RegExp.$1.length === 1 ? v : ("00" + v).substr(("" + v).length));
      }
    }
    return fmt;
  };

}).call(this);

(function() {
  var BaseTile;

  window.COLOR_IN = 'rgba(149, 222, 255, 0.9)';

  window.COLOR_OUT = 'rgba(65, 196, 255, 0.9)';

  window.COLOR_BALANCE = 'rgba(231, 255, 149, 0.9)';

  window.COLOR_BALANCE_OVERLOAD = 'rgba(243, 157, 119, 0.9)';

  window.COLOR_BALANCE_DEEP = 'rgba(138, 152, 89, 0.9)';

  window.BG_COLOR = '#17243C';

  window.GOOD_COLOR = '#97FF41';

  window.BAD_COLOR = '#FF7C41';

  window.BaseTile = BaseTile = (function() {
    function BaseTile() {}

    BaseTile.init = function() {
      var $root, r;
      $root = jQuery('body > .paper');
      $root.css({
        position: 'relative',
        width: 1920,
        height: 1080
      });
      r = function($tile, $parent) {
        var offb, offl, offr, offt, ph, pw, ref, th, tl, tt, tw;
        ref = $tile.data('layout'), tl = ref[0], tt = ref[1], tw = ref[2], th = ref[3];
        offl = parseInt($parent.css('padding-left'));
        offt = parseInt($parent.css('padding-top'));
        offr = parseInt($parent.css('padding-right'));
        offb = parseInt($parent.css('padding-bottom'));
        pw = $parent.width();
        ph = $parent.height();
        $tile.css({
          left: pw / 24 * tl + offl,
          top: ph / 24 * tt + offt,
          width: pw / 24 * tw,
          height: ph / 24 * th
        });
        return $tile.find('> .tile').each(function(idx, dom) {
          return r(jQuery(dom), $tile);
        });
      };
      return $root.find('> .tile').each(function(idx, dom) {
        return r(jQuery(dom), $root);
      });
    };

    BaseTile.prototype.draw_svg = function() {
      this.width = this.$elm.width();
      this.height = this.$elm.height();
      return this.svg = d3.select(this.$elm[0]).append('svg').attr('width', this.width).attr('height', this.height);
    };

    return BaseTile;

  })();

}).call(this);

(function() {
  jQuery(function() {
    return BaseTile.init();
  });

}).call(this);
