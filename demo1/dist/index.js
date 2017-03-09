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
  var BaseTile, Graph, Graphs;

  window.COLOR_IN = 'rgba(149, 222, 255, 0.9)';

  window.COLOR_OUT = 'rgba(65, 196, 255, 0.9)';

  window.COLOR_BALANCE = 'rgba(231, 255, 149, 0.9)';

  window.COLOR_BALANCE_OVERLOAD = 'rgba(243, 157, 119, 0.9)';

  window.COLOR_BALANCE_DEEP = 'rgba(138, 152, 89, 0.9)';

  window.BG_COLOR = '#17243C';

  window.GOOD_COLOR = '#97FF41';

  window.BAD_COLOR = '#FF7C41';

  Graphs = {};

  window.BaseTile = BaseTile = (function() {
    BaseTile.register = function(name, klass) {
      return Graphs[name] = klass;
    };

    BaseTile.paper_init = function() {
      var $root;
      $root = jQuery('body > .paper');
      $root.css({
        position: 'relative',
        width: 1920,
        height: 1080
      });
      return $root.find('> .tile').each(function(idx, dom) {
        var tile;
        tile = new BaseTile(jQuery(dom), $root);
        return tile.init();
      });
    };

    function BaseTile($tile, $parent) {
      this.$tile = $tile;
      this.$parent = $parent;
      this.graph_name = this.$tile.data('g');
    }

    BaseTile.prototype.init = function() {
      this.init_layout();
      if (this.graph_name != null) {
        return this.draw();
      }
    };

    BaseTile.prototype.init_layout = function() {
      var offb, offl, offr, offt, ph, pw, ref, th, tl, tt, tw;
      ref = this.$tile.data('layout'), tl = ref[0], tt = ref[1], tw = ref[2], th = ref[3];
      offl = parseInt(this.$parent.css('padding-left'));
      offt = parseInt(this.$parent.css('padding-top'));
      offr = parseInt(this.$parent.css('padding-right'));
      offb = parseInt(this.$parent.css('padding-bottom'));
      pw = this.$parent.width();
      ph = this.$parent.height();
      this.$tile.css({
        left: pw / 24 * tl + offl,
        top: ph / 24 * tt + offt,
        width: pw / 24 * tw,
        height: ph / 24 * th
      });
      return this.$tile.find('> .tile').each((function(_this) {
        return function(idx, dom) {
          var tile;
          tile = new BaseTile(jQuery(dom), _this.$tile);
          return tile.init();
        };
      })(this));
    };

    BaseTile.prototype.draw = function() {
      var graph;
      console.log('绘制', this.graph_name);
      graph = Graphs[this.graph_name];
      if (graph == null) {
        console.log(this.graph_name, '未注册');
        return;
      }
      return new graph(this).draw();
    };

    return BaseTile;

  })();

  window.Graph = Graph = (function() {
    function Graph(tile1) {
      this.tile = tile1;
      this.$tile = this.tile.$tile;
      this.width = this.$tile.width();
      this.height = this.$tile.height();
    }

    Graph.prototype.draw_svg = function() {
      return d3.select(this.$tile[0]).append('svg').attr('width', this.width).attr('height', this.height);
    };

    Graph.prototype.draw = function() {
      return console.log('绘图方法未实现');
    };

    return Graph;

  })();

}).call(this);

(function() {
  var OneArea,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  OneArea = (function(superClass) {
    extend(OneArea, superClass);

    function OneArea() {
      return OneArea.__super__.constructor.apply(this, arguments);
    }

    OneArea.prototype.draw = function() {
      this.svg = this.draw_svg();
      this.draw_flag();
      return this.draw_texts();
    };

    OneArea.prototype.draw_flag = function() {
      var flag;
      flag = this.svg.append('g');
      return flag.append('image').attr('href', 'img/taiguo.png').attr('height', this.height - 60).attr('x', 0).attr('y', 30);
    };

    OneArea.prototype.draw_texts = function() {
      var size, size1, size2, texts;
      texts = this.svg.append('g').style('transform', 'translate(260px, 0px)');
      size = 40;
      texts.append('text').attr('x', 0).attr('y', size / 2 + 10).attr('dy', '.33em').text('泰国销量').style('font-size', size).style('fill', '#ffffff');
      size1 = 50;
      texts.append('text').attr('x', 0).attr('y', size / 2 + size + 40).attr('dy', '.33em').text('2817109').style('font-size', size1).style('fill', '#ffff05');
      size2 = 40;
      texts.append('text').attr('x', 0).attr('y', size / 2 + size + 34 + size1 + 30).attr('dy', '.33em').text('同比 14.3%').style('font-size', size2).style('fill', '#ffffff');
      return texts.append('image').attr('x', 215).attr('y', size / 2 + size + 34 + size1 + 30 - size2 / 2).attr('href', 'img/upicon1.png').attr('height', size2);
    };

    return OneArea;

  })(Graph);

  BaseTile.register('one-area', OneArea);

}).call(this);

(function() {
  var PageTitle,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  PageTitle = (function(superClass) {
    extend(PageTitle, superClass);

    function PageTitle() {
      return PageTitle.__super__.constructor.apply(this, arguments);
    }

    PageTitle.prototype.draw = function() {
      this.svg = this.draw_svg();
      this.draw_title();
      return this.draw_points();
    };

    PageTitle.prototype.draw_title = function() {
      var size, title;
      title = this.svg.append('g');
      size = 60;
      return title.append('text').attr('x', 70 + 30).attr('y', 10 + size / 2).attr('dy', '.33em').text('一带一路国家销售情况监控').style('font-size', size).style('fill', '#aebbcb');
    };

    PageTitle.prototype.draw_points = function() {
      var points;
      points = this.svg.append('g');
      return points.append('image').attr('href', 'img/title-points.png').attr('width', 60).attr('height', 60).attr('x', 10).attr('y', 10).style('opacity', '0.5');
    };

    return PageTitle;

  })(Graph);

  BaseTile.register('title', PageTitle);

}).call(this);

(function() {
  jQuery(function() {
    return BaseTile.paper_init();
  });

}).call(this);
