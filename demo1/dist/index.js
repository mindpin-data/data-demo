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
  var AreasBar,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  AreasBar = (function(superClass) {
    extend(AreasBar, superClass);

    function AreasBar() {
      return AreasBar.__super__.constructor.apply(this, arguments);
    }

    AreasBar.prototype.draw = function() {
      this.svg = this.draw_svg();
      this.make_defs();
      return this.draw_flags();
    };

    AreasBar.prototype.make_defs = function() {
      var defs, lg;
      defs = this.svg.append('defs');
      lg = defs.append('linearGradient').attr('id', 'areas-bar-linear').attr('x1', '0%').attr('y1', '0%').attr('x2', '100%').attr('y2', '0%');
      lg.append('stop').attr('offset', '0%').attr('stop-color', '#7184a3');
      return lg.append('stop').attr('offset', '100%').attr('stop-color', '#f9f9f7');
    };

    AreasBar.prototype.draw_flags = function() {
      var amount, amounts, bar, bh, bw, f, farr, flag, flags, h, i, idx, len, max, names, offl, results, text, text1, th, th1, w;
      flags = this.svg.append('g');
      farr = ['xinjiapo', 'yindu', 'yuenan', 'malai', 'yinni'];
      amounts = [6324210, 6004324, 5132828, 4078910, 3876152];
      names = ['新加坡', '印度', '越南', '马来西亚', '印尼'];
      max = 6424210;
      h = this.height / 5;
      w = this.width * 0.8;
      results = [];
      for (idx = i = 0, len = farr.length; i < len; idx = ++i) {
        f = farr[idx];
        flag = flags.append('image').attr('href', "img/" + f + ".png").attr('height', h - 30).attr('x', 0).attr('y', h * idx + 30);
        offl = 90;
        amount = amounts[idx];
        bh = h - 40;
        bw = w * (amount / max);
        bar = flags.append('rect').attr('fill', 'url(#areas-bar-linear)').attr('width', bw).attr('height', bh).attr('x', offl).attr('y', h * idx + 30 + 5);
        th = 24;
        text = flags.append('text').attr('fill', '#011224').attr('x', offl + 5).attr('y', h * idx + 30 + 5 + bh / 2).attr('dy', '.33em').style('font-size', th).text(names[idx]);
        th1 = 30;
        results.push(text1 = flags.append('text').attr('fill', '#011224').attr('text-anchor', 'end').attr('x', offl + bw - 5).attr('y', h * idx + 30 + 5 + bh / 2).attr('dy', '.33em').style('font-size', th1).style('font-weight', 'bold').text(amount));
      }
      return results;
    };

    return AreasBar;

  })(Graph);

  BaseTile.register('areas-bar', AreasBar);

}).call(this);

(function() {
  var LineChart,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  LineChart = (function(superClass) {
    extend(LineChart, superClass);

    function LineChart() {
      return LineChart.__super__.constructor.apply(this, arguments);
    }

    LineChart.prototype.draw = function() {
      this.svg = this.draw_svg();
      this.data0 = [0, 35, 100, 140];
      this.data1 = [0, 30, 60, 80, 110, 140];
      this.h = this.height - 40;
      this.w = this.width - 60;
      this.gap = (this.w - 30) / 5;
      this.c1 = 'rgb(205, 255, 65)';
      this.c2 = 'rgb(60, 180, 236)';
      this.xscale = d3.scaleLinear().domain([0, 5]).range([0, this.w]);
      this.yscale = d3.scaleLinear().domain([0, 180]).range([this.h, 0]);
      this.make_defs();
      this.draw_axis();
      return this.draw_lines();
    };

    LineChart.prototype.make_defs = function() {
      var defs, lg;
      defs = this.svg.append('defs');
      lg = defs.append('linearGradient').attr('id', 'line-chart-linear1').attr('x1', '0%').attr('y1', '0%').attr('x2', '0%').attr('y2', '100%');
      lg.append('stop').attr('offset', '0%').attr('stop-color', 'rgba(205, 255, 65, 0.5)');
      lg.append('stop').attr('offset', '100%').attr('stop-color', 'rgba(205, 255, 65, 0.05)');
      lg = defs.append('linearGradient').attr('id', 'line-chart-linear2').attr('x1', '0%').attr('y1', '0%').attr('x2', '0%').attr('y2', '100%');
      lg.append('stop').attr('offset', '0%').attr('stop-color', 'rgba(60, 180, 236, 0.5)');
      return lg.append('stop').attr('offset', '100%').attr('stop-color', 'rgba(60, 180, 236, 0.05)');
    };

    LineChart.prototype.draw_lines = function() {
      var arealine1, arealine2, d, i, idx, j, len, len1, line1, panel, ref, ref1, results;
      panel = this.svg.append('g').attr('transform', "translate(40, 10)");
      line1 = d3.line().x((function(_this) {
        return function(d, idx) {
          return _this.xscale(idx);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yscale(d);
        };
      })(this));
      arealine1 = d3.line().x((function(_this) {
        return function(d, idx) {
          if (idx === 0) {
            return _this.xscale(3);
          } else if (idx === 1) {
            return _this.xscale(0);
          } else {
            return _this.xscale(idx - 2);
          }
        };
      })(this)).y((function(_this) {
        return function(d, idx) {
          return _this.yscale(d);
        };
      })(this));
      arealine2 = d3.line().x((function(_this) {
        return function(d, idx) {
          if (idx === 0) {
            return _this.xscale(5);
          } else if (idx === 1) {
            return _this.xscale(0);
          } else {
            return _this.xscale(idx - 2);
          }
        };
      })(this)).y((function(_this) {
        return function(d, idx) {
          return _this.yscale(d);
        };
      })(this));
      panel.append('path').datum([0, 0].concat(this.data0)).attr('class', 'pre-line').attr('d', arealine1).style('fill', 'url(#line-chart-linear1)');
      panel.append('path').datum(this.data0).attr('class', 'pre-line').attr('d', line1).style('stroke', this.c1).style('fill', 'transparent').style('stroke-width', 2);
      ref = this.data0;
      for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
        d = ref[idx];
        panel.append('circle').attr('cx', this.xscale(idx)).attr('cy', this.yscale(d)).attr('r', 4).attr('fill', this.c1);
      }
      panel.append('path').datum([0, 0].concat(this.data1)).attr('class', 'pre-line').attr('d', arealine2).style('fill', 'url(#line-chart-linear2)');
      panel.append('path').datum(this.data1).attr('class', 'pre-line').attr('d', line1).style('stroke', this.c2).style('fill', 'transparent').style('stroke-width', 2);
      ref1 = this.data1;
      results = [];
      for (idx = j = 0, len1 = ref1.length; j < len1; idx = ++j) {
        d = ref1[idx];
        results.push(panel.append('circle').attr('cx', this.xscale(idx)).attr('cy', this.yscale(d)).attr('r', 4).attr('fill', this.c2));
      }
      return results;
    };

    LineChart.prototype.draw_axis = function() {
      var axisx, axisy;
      axisx = this.svg.append('g').attr('class', 'axis axis-x').attr('transform', "translate(" + 40 + ", " + (10 + this.h) + ")");
      axisy = this.svg.append('g').attr('class', 'axis axis-y').attr('transform', "translate(" + 40 + ", " + 10 + ")");
      axisx.call(d3.axisBottom(this.xscale).tickValues([0, 1, 2, 3, 4, 5]).tickFormat(function(d, idx) {
        if (idx === 0) {
          return '';
        }
        return (idx * 2) + "月";
      }));
      return axisy.call(d3.axisLeft(this.yscale).tickValues([0, 30, 60, 90, 120, 150, 180])).selectAll('.tick line').attr('x1', this.w);
    };

    return LineChart;

  })(Graph);

  BaseTile.register('line-chart', LineChart);

}).call(this);

(function() {
  var LineChartTitle,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  LineChartTitle = (function(superClass) {
    extend(LineChartTitle, superClass);

    function LineChartTitle() {
      return LineChartTitle.__super__.constructor.apply(this, arguments);
    }

    LineChartTitle.prototype.draw = function() {
      this.svg = this.draw_svg();
      return this.draw_texts();
    };

    LineChartTitle.prototype.draw_texts = function() {
      var size, texts;
      texts = this.svg.append('g').style('transform', 'translate(0px, 0px)');
      size = 20;
      texts.append('text').attr('x', 10).attr('y', this.height / 2).attr('dy', '.33em').text('销量对比（单位：万）').style('font-size', size).style('fill', '#ffffff');
      texts.append('rect').attr('x', 250).attr('y', this.height / 2 - 7).attr('width', 30).attr('height', 15).style('fill', 'rgb(205, 255, 65)');
      texts.append('text').attr('x', 290).attr('y', this.height / 2).attr('dy', '.33em').text('当前销量').style('font-size', size).style('fill', '#ffffff');
      texts.append('rect').attr('x', 390).attr('y', this.height / 2 - 7).attr('width', 30).attr('height', 15).style('fill', 'rgb(60, 180, 236)');
      return texts.append('text').attr('x', 430).attr('y', this.height / 2).attr('dy', '.33em').text('历史销量').style('font-size', size).style('fill', '#ffffff');
    };

    return LineChartTitle;

  })(Graph);

  BaseTile.register('line-chart-title', LineChartTitle);

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
