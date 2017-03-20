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
        position: 'absolute',
        top: 0,
        left: 0,
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
      this.data0 = [0, 8, 15, 20, 26, 32, 38, 52, 59, 66, 70, 84, 88];
      this.data1 = [0, 6, 13, 22, 27, 31, 35, 50, 54, 60, 66, 75, 81];
      this.data2 = [0, 4, 10, 12, 19, 20, 26, 32, 37, 41, 43, 49, 58];
      this.h = this.height - 40;
      this.w = this.width - 60;
      this.gap = (this.w - 30) / 5;
      this.c1 = '#00c713';
      this.c2 = '#578eff';
      this.c3 = '#ff8711';
      this.xscale = d3.scaleLinear().domain([0, 11]).range([0, this.w]);
      this.yscale = d3.scaleLinear().domain([0, 100]).range([this.h, 0]);
      this.draw_axis();
      return this.draw_lines();
    };

    LineChart.prototype.draw_lines = function() {
      var d, i, idx, j, k, len, len1, len2, line1, ref, ref1, ref2, results;
      if (this.panel == null) {
        this.panel = this.svg.append('g').attr('transform', "translate(150, 10)");
      }
      line1 = d3.line().x((function(_this) {
        return function(d, idx) {
          return _this.xscale(idx);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yscale(d);
        };
      })(this)).curve(d3.curveCatmullRom.alpha(0.5));
      this.panel.selectAll('path.pre-line').remove();
      this.panel.selectAll('circle').remove();
      this.panel.append('path').datum(this.data2).attr('class', 'pre-line').attr('d', line1).style('stroke', this.c3).style('fill', 'transparent').style('stroke-width', 2);
      ref = this.data2;
      for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
        d = ref[idx];
        this.panel.append('circle').attr('cx', this.xscale(idx)).attr('cy', this.yscale(d)).attr('r', 4).attr('fill', this.c3);
      }
      this.panel.append('path').datum(this.data1).attr('class', 'pre-line').attr('d', line1).style('stroke', this.c2).style('fill', 'transparent').style('stroke-width', 2).style('stroke-dasharray', '5 5').style('stroke-linecap', 'round');
      ref1 = this.data1;
      for (idx = j = 0, len1 = ref1.length; j < len1; idx = ++j) {
        d = ref1[idx];
        this.panel.append('circle').attr('cx', this.xscale(idx)).attr('cy', this.yscale(d)).attr('r', 4).attr('fill', this.c2);
      }
      this.panel.append('path').datum(this.data0).attr('class', 'pre-line').attr('d', line1).style('stroke', this.c1).style('fill', 'transparent').style('stroke-width', 2);
      ref2 = this.data0;
      results = [];
      for (idx = k = 0, len2 = ref2.length; k < len2; idx = ++k) {
        d = ref2[idx];
        results.push(this.panel.append('circle').attr('cx', this.xscale(idx)).attr('cy', this.yscale(d)).attr('r', 4).attr('fill', this.c1));
      }
      return results;
    };

    LineChart.prototype.draw_axis = function() {
      var axisx, axisy;
      axisx = this.svg.append('g').attr('class', 'axis axis-x').attr('transform', "translate(" + 150 + ", " + (10 + this.h) + ")");
      axisy = this.svg.append('g').attr('class', 'axis axis-y').attr('transform', "translate(" + 150 + ", " + 10 + ")");
      axisx.call(d3.axisBottom(this.xscale).tickValues([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]).tickFormat(function(d, idx) {
        return (idx + 1) + "月";
      }));
      return axisy.call(d3.axisLeft(this.yscale).tickValues([0, 20, 40, 60, 80, 100]).tickFormat(function(d, idx) {
        if (d === 100) {
          return '1,000,000,000';
        }
        if (d === 0) {
          return '0';
        }
        return d + "0,000,000";
      })).selectAll('.tick line').attr('x1', this.w);
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
      this.c1 = '#00c713';
      this.c2 = '#578eff';
      this.c3 = '#ff8711';
      return this.draw_texts();
    };

    LineChartTitle.prototype.draw_texts = function() {
      var size, texts;
      texts = this.svg.append('g').style('transform', 'translate(1100px, 0px)');
      size = 40;
      texts.append('text').attr('x', -1050).attr('y', this.height / 2).attr('dy', '.33em').text('产品总体销量').style('font-size', size).style('fill', '#ffffff');
      texts.append('text').attr('x', -1050 + 270).attr('y', this.height / 2).attr('dy', '.33em').text(889718890).style('font-size', size * 1.5).style('fill', '#fcf926');
      texts.append('text').attr('x', -1050 + 600).attr('y', this.height / 2).attr('dy', '.33em').text('产品出口销量').style('font-size', size).style('fill', '#ffffff');
      texts.append('text').attr('x', -1050 + 600 + 270).attr('y', this.height / 2).attr('dy', '.33em').text(142210067).style('font-size', size * 1.5).style('fill', '#fcf926');
      size = 20;
      texts.append('rect').attr('x', 250).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c1);
      texts.append('text').attr('x', 290).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('实际销量').style('font-size', size).style('fill', '#ffffff');
      texts.append('rect').attr('x', 390).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c2);
      texts.append('text').attr('x', 430).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('预测销量').style('font-size', size).style('fill', '#ffffff');
      texts.append('rect').attr('x', 530).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c3);
      return texts.append('text').attr('x', 570).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('上年同比销量').style('font-size', size).style('fill', '#ffffff');
    };

    return LineChartTitle;

  })(Graph);

  BaseTile.register('line-chart-title', LineChartTitle);

}).call(this);

(function() {
  var PathMap,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  PathMap = (function(superClass) {
    extend(PathMap, superClass);

    function PathMap() {
      return PathMap.__super__.constructor.apply(this, arguments);
    }

    PathMap.prototype.draw = function() {
      this.svg = this.draw_svg();
      return this.load_data();
    };

    PathMap.prototype.load_data = function() {
      return d3.json('data/world-countries.json?1', (function(_this) {
        return function(error, _data) {
          _this.features = _data.features;
          _this.draw_map();
          return _this.draw_heatmap();
        };
      })(this));
    };

    PathMap.prototype.draw_map = function() {
      this.projection = d3.geoMercator().center([105, 38]).scale(this.width * 0.3).translate([this.width / 2, this.height / 2]);
      this.path = d3.geoPath(this.projection);
      this.g_map = this.svg.append('g');
      return this._draw_map();
    };

    PathMap.prototype._draw_map = function() {
      var countries;
      this.g_map.selectAll('.country').remove();
      return countries = this.g_map.selectAll('.country').data(this.features).enter().append('path').attr('class', 'country').attr('d', this.path).style('stroke', (function(_this) {
        return function(d) {
          return 'rgba(120, 180, 208, 1)';
        };
      })(this)).style('stroke-width', 2).style('fill', (function(_this) {
        return function(d) {
          if (d.id === 'CHN') {
            return 'rgba(136, 204, 236, 0.2)';
          }
          return 'rgba(136, 204, 236, 0.1)';
        };
      })(this));
    };

    PathMap.prototype.draw_heatmap = function() {
      var chn_feature, data, dscale, heatmapInstance, lat, len, long, max, n, point, points, ref, val, x, xscale, y, yscale;
      heatmapInstance = h337.create({
        container: jQuery('#heatmap')[0],
        radius: 24,
        gradient: {
          '0.2': '#28669b',
          '0.8': '#34cee9',
          '1.0': 'white'
        }
      });
      points = [];
      max = 0;
      len = 600;
      chn_feature = this.features.filter((function(_this) {
        return function(x) {
          return x.id === 'CHN';
        };
      })(this))[0];
      xscale = d3.scaleLinear().range([0, 1]).domain([73, 135]);
      yscale = d3.scaleLinear().range([0, 2]).domain([53, 4]);
      dscale = d3.scaleLinear().range([-0.5, 0.5]).domain([0, 3]);
      while (len > 0) {
        lat = 73 + Math.random() * (135 - 73);
        long = 4 + Math.random() * (53 - 4);
        if (d3.geoContains(chn_feature, [lat, long])) {
          len = len - 1;
          val = Math.floor(150 + Math.random() * (451 - 150));
          val = val * xscale(lat);
          val = val * yscale(long);
          ref = this.projection([lat, long]), x = ref[0], y = ref[1];
          point = {
            x: Math.floor(x * 100) / 100,
            y: Math.floor(y * 100) / 100,
            value: val
          };
          points.push(point);
        }
      }
      data = {
        max: 600,
        data: points
      };
      heatmapInstance.setData(data);
      n = 0;
      return setInterval((function(_this) {
        return function() {
          n++;
          data.data = data.data.map(function(x, idx) {
            var delta, p, value;
            delta = Math.floor(Math.random() * 10);
            p = dscale((idx + Math.floor(n / 100)) % 4);
            value = x.value + delta * p;
            return {
              x: x.x,
              y: x.y,
              value: value
            };
          });
          return heatmapInstance.setData(data);
        };
      })(this), 1000 / 60);
    };

    return PathMap;

  })(Graph);

  BaseTile.register('path-map', PathMap);

}).call(this);

(function() {
  jQuery(function() {
    return BaseTile.paper_init();
  });

}).call(this);
