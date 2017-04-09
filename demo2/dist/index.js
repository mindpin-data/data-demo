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
      this.draw_stitle();
      return this.draw_infos();
    };

    AreasBar.prototype.draw_stitle = function() {
      var size;
      size = 24;
      return this.svg.append('text').attr('x', 50).attr('y', size / 2 + 30).attr('dy', '.33em').text("原料产地自然灾害预警").style('font-size', size + 'px').style('fill', '#ffffff');
    };

    AreasBar.prototype.draw_infos = function() {
      var panel;
      panel = this.svg.append('g').style('transform', 'translate(-30px, 70px)');
      this.draw_info(panel, 'img/dayu-0.png', '遵义', '近期大雨', '2017-03-02');
      return this.draw_info(panel, 'img/dafeng-0.png', '郑州', '近期大风', '2017-03-02', 60);
    };

    AreasBar.prototype.draw_info = function(panel, img, city, weather, date, y) {
      var size;
      if (y == null) {
        y = 0;
      }
      size = 24;
      panel.append('image').attr('x', 80).attr('y', size / 2 + y).attr('xlink:href', img).attr('height', 40 + 'px').attr('width', 40 + 'px');
      panel.append('text').attr('x', 150).attr('y', size / 2 + 20 + y).attr('dy', '.33em').text(city).style('font-size', size + 'px').style('fill', '#ffffff');
      panel.append('text').attr('x', 220).attr('y', size / 2 + 20 + y).attr('dy', '.33em').text(weather).style('font-size', size + 'px').style('fill', '#f66');
      return panel.append('text').attr('x', 340).attr('y', size / 2 + 20 + y).attr('dy', '.33em').text(date).style('font-size', size + 'px').style('fill', '#ffde00');
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
      this.data0 = [45, 45, 40, 48, 42, 50];
      this.data1 = [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47];
      this.data2 = [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60];
      this.h = this.height - 40;
      this.w = this.width - 60;
      this.gap = (this.w - 30) / 5;
      this.c1 = 'rgb(137, 189, 27)';
      this.c2 = 'rgb(6, 129, 200)';
      this.c3 = 'rgb(217, 6, 8)';
      this.xscale = d3.scaleLinear().domain([0, 11]).range([0, this.w]);
      this.yscale = d3.scaleLinear().domain([0, 70]).range([this.h, 0]);
      this.make_defs();
      this.draw_axis();
      this.draw_lines();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          return _this.draw_lines();
        };
      })(this));
    };

    LineChart.prototype.make_def = function(r, g, b, id) {
      var lg;
      lg = this.svg_defs.append('linearGradient').attr('id', id).attr('x1', '0%').attr('y1', '0%').attr('x2', '0%').attr('y2', '100%');
      lg.append('stop').attr('offset', '0%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.1)");
      return lg.append('stop').attr('offset', '100%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.0)");
    };

    LineChart.prototype.make_defs = function() {
      this.svg_defs = this.svg.append('defs');
      this.make_def(205, 255, 65, 'line-chart-linear1');
      this.make_def(60, 180, 236, 'line-chart-linear2');
      return this.make_def(217, 87, 87, 'line-chart-linear3');
    };

    LineChart.prototype.draw_lines = function() {
      var _curve, arealine1, arealine2, arealine3, line1;
      if (this.panel != null) {
        this.panel.remove();
      }
      this.panel = this.svg.append('g').attr('transform', "translate(30, 10)");
      line1 = d3.line().x((function(_this) {
        return function(d, idx) {
          return _this.xscale(idx);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yscale(d);
        };
      })(this)).curve(d3.curveCatmullRom.alpha(0.5));
      arealine1 = d3.line().x((function(_this) {
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
      arealine2 = d3.line().x((function(_this) {
        return function(d, idx) {
          if (idx === 0) {
            return _this.xscale(11);
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
      arealine3 = d3.line().x((function(_this) {
        return function(d, idx) {
          if (idx === 0) {
            return _this.xscale(11);
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
      this.panel.selectAll('path.pre-line').remove();
      this.panel.selectAll('circle').remove();
      _curve = (function(_this) {
        return function(data, arealine, color, fill) {
          var _data, area, circle, curve, d, i, idx, len, results;
          _data = data.map(function(x) {
            return 0;
          });
          area = _this.panel.append('path').datum([0, 0].concat(_data)).attr('class', 'pre-line').attr('d', arealine).style('fill', fill);
          area.datum([0, 0].concat(data)).transition().duration(1000).attr('d', arealine);
          curve = _this.panel.append('path').datum(_data).attr('class', 'pre-line').attr('d', line1).style('stroke', color).style('fill', 'transparent').style('stroke-width', 2);
          curve.datum(data).transition().duration(1000).attr('d', line1);
          results = [];
          for (idx = i = 0, len = _data.length; i < len; idx = ++i) {
            d = _data[idx];
            circle = _this.panel.append('circle').attr('cx', _this.xscale(idx)).attr('cy', _this.yscale(d)).attr('r', 4).attr('fill', color);
            results.push(circle.transition().duration(1000).attr('cy', _this.yscale(data[idx])));
          }
          return results;
        };
      })(this);
      _curve(this.data2, arealine3, this.c3, 'url(#line-chart-linear3)');
      _curve(this.data1, arealine2, this.c2, 'url(#line-chart-linear2)');
      return _curve(this.data0, arealine1, this.c1, 'url(#line-chart-linear1)');
    };

    LineChart.prototype.draw_axis = function() {
      var axisx, axisy;
      axisx = this.svg.append('g').attr('class', 'axis axis-x').attr('transform', "translate(" + 30 + ", " + (10 + this.h) + ")");
      axisy = this.svg.append('g').attr('class', 'axis axis-y').attr('transform', "translate(" + 30 + ", " + 10 + ")");
      axisx.call(d3.axisBottom(this.xscale).tickValues([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]).tickFormat(function(d, idx) {
        return (idx + 1) + "月";
      }));
      return axisy.call(d3.axisLeft(this.yscale).tickValues([0, 10, 20, 30, 40, 50, 60, 70])).selectAll('.tick line').attr('x1', this.w);
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
      this.c1 = 'rgb(137, 189, 27)';
      this.c2 = 'rgb(6, 129, 200)';
      this.c3 = 'rgb(217, 6, 8)';
      this.svg = this.draw_svg();
      return this.draw_texts();
    };

    LineChartTitle.prototype.draw_texts = function() {
      var size, texts;
      texts = this.svg.append('g').style('transform', 'translate(0px, 0px)');
      size = 20;
      texts.append('text').attr('x', 10).attr('y', this.height / 2).attr('dy', '.33em').text('辣椒采购价格同比（单位：万元 / 吨）').style('font-size', size + 'px').style('fill', '#ffffff');
      texts.append('rect').attr('x', 250 - 160).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c1);
      texts.append('text').attr('x', 290 - 160).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('现价').style('font-size', size + 'px').style('fill', '#ffffff');
      texts.append('rect').attr('x', 390 - 180).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c2);
      texts.append('text').attr('x', 430 - 180).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('上一年同期价').style('font-size', size + 'px').style('fill', '#ffffff');
      texts.append('rect').attr('x', 390).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c3);
      return texts.append('text').attr('x', 430).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('政府指导价').style('font-size', size + 'px').style('fill', '#ffffff');
    };

    return LineChartTitle;

  })(Graph);

  BaseTile.register('line-chart-title', LineChartTitle);

}).call(this);

(function() {
  var OneArea, products, products_colors,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  products = ['lajiao', 'shengjiang', 'dadou'];

  products_colors = ['#f33', '#ff3', '#3f3'];

  OneArea = (function(superClass) {
    extend(OneArea, superClass);

    function OneArea() {
      return OneArea.__super__.constructor.apply(this, arguments);
    }

    OneArea.prototype.draw = function() {
      this.svg = this.draw_svg();
      this.idx = -1;
      this._draw();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          return _this._draw();
        };
      })(this));
    };

    OneArea.prototype._draw = function() {
      this.idx += 1;
      if (this.idx === 3) {
        this.idx = 0;
      }
      this.current_product = products[this.idx];
      this.current_product_color = products_colors[this.idx];
      this.draw_icon();
      return this.draw_texts();
    };

    OneArea.prototype.draw_icon = function() {
      var flag;
      this.svg.select('g.flag').remove();
      flag = this.svg.append('g').attr('class', 'flag');
      flag.append('circle').attr('r', this.height / 4).attr('cx', 80).attr('cy', this.height / 2).attr('fill', this.current_product_color).style('opacity', '0.5');
      return flag.append('image').attr('xlink:href', "img/icon-" + this.current_product + ".png").attr('height', this.height / 6 * 2).attr('width', this.height / 6 * 2).attr('x', 80 - this.height / 6).attr('y', this.height / 2 - this.height / 6);
    };

    OneArea.prototype.draw_texts = function() {
      var texts;
      this.svg.select('g.texts').remove();
      texts = this.svg.append('g').attr('class', 'texts').style('transform', 'translate(160px, 48px)');
      this.draw_text(texts, '即时采购价', 4.122, 0, true);
      this.draw_text(texts, '去年同期价', 4.782, 40);
      return this.draw_text(texts, '当前指导价', 4.339, 80);
    };

    OneArea.prototype.draw_text = function(texts, label, number, y, flag) {
      var size, tn, tp;
      if (flag == null) {
        flag = false;
      }
      size = 20;
      texts.append('text').attr('x', 0).attr('y', size / 2 + 10 + y).attr('dy', '.33em').text(label).style('font-size', size + 'px').style('fill', '#ffffff');
      tn = texts.append('text').attr('x', 110).attr('y', size / 2 + 10 + y).attr('dy', '.33em').text(number).style('font-size', size + 'px').style('fill', '#ffde00');
      jQuery({
        n: 0
      }).animate({
        n: number
      }, {
        step: function(now) {
          return tn.text(~~(now * 1000) / 1000);
        }
      });
      texts.append('text').attr('x', 170).attr('y', size / 2 + 10 + y).attr('dy', '.33em').text("万元 / 吨").style('font-size', size + 'px').style('fill', '#ffffff');
      if (flag) {
        tp = texts.append('text').attr('x', 270).attr('y', size / 2 + 10 + y).attr('dy', '.33em').text("2.34‰").style('font-size', size + 'px').style('fill', '#ffffff');
        jQuery({
          n: 0
        }).animate({
          n: 2.34
        }, {
          step: function(now) {
            return tp.text((~~(now * 100) / 100) + "‰");
          }
        });
        return texts.append('image').attr('x', 330).attr('y', size / 2 + 10 - size / 2 + y).attr('xlink:href', 'img/downicon1.png').attr('height', size).attr('width', size);
      }
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
      this.TEXT_SIZE = 50;
      this.svg = this.draw_svg();
      this.draw_title();
      return this.draw_points();
    };

    PageTitle.prototype.draw_title = function() {
      var title;
      return title = this.svg.append('text').attr('x', 70 + 30).attr('y', 10 + this.TEXT_SIZE / 2).attr('dy', '.33em').text('原材料产地监控').style('font-size', this.TEXT_SIZE + 'px').style('fill', '#aebbcb');
    };

    PageTitle.prototype.draw_points = function() {
      var points;
      return points = this.svg.append('image').attr('xlink:href', 'img/title-points.png').attr('width', this.TEXT_SIZE).attr('height', this.TEXT_SIZE).attr('x', 10).attr('y', 10).style('opacity', '0.5');
    };

    return PageTitle;

  })(Graph);

  BaseTile.register('title', PageTitle);

}).call(this);

(function() {
  var CityAnimate, PathMap, data, products,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  data = [
    {
      lat: 103,
      long: 30,
      d: 30,
      type: 'lajiao'
    }, {
      lat: 110,
      long: 29,
      d: 20,
      type: 'lajiao'
    }, {
      lat: 106.9,
      long: 27.7,
      d: 25,
      type: 'lajiao'
    }, {
      lat: 104,
      long: 26,
      d: 20,
      type: 'lajiao'
    }, {
      lat: 106,
      long: 23,
      d: 20,
      type: 'lajiao'
    }, {
      lat: 114.3,
      long: 28.7,
      d: 20,
      type: 'shengjiang'
    }, {
      lat: 106.3,
      long: 29.6,
      d: 17,
      type: 'shengjiang'
    }, {
      lat: 103.7,
      long: 26.8,
      d: 23,
      type: 'shengjiang'
    }, {
      lat: 108.6,
      long: 25.5,
      d: 24,
      type: 'shengjiang'
    }, {
      lat: 113.7,
      long: 34.6,
      d: 30,
      type: 'dadou'
    }, {
      lat: 105.1,
      long: 28.7,
      d: 25,
      type: 'dadou'
    }, {
      lat: 103.7,
      long: 26.8,
      d: 24,
      type: 'dadou'
    }, {
      lat: 111.8,
      long: 24.4,
      d: 20,
      type: 'dadou'
    }, {
      lat: 100.2,
      long: 23.1,
      d: 19,
      type: 'dadou'
    }
  ];

  products = ['lajiao', 'shengjiang', 'dadou'];

  PathMap = (function(superClass) {
    extend(PathMap, superClass);

    function PathMap() {
      return PathMap.__super__.constructor.apply(this, arguments);
    }

    PathMap.prototype.draw = function() {
      this.MAP_STROKE_COLOR = '#021225';
      this.MAP_FILL_COLOR = '#323c48';
      this.svg = this.draw_svg();
      return this.load_data();
    };

    PathMap.prototype.load_data = function() {
      return d3.json('data/china.json?1', (function(_this) {
        return function(error, _data) {
          _this.features = _data.features;
          _this.init();
          _this.idx = 0;
          _this.current_product = products[0];
          _this.draw_map();
          return jQuery(document).on('data-map:next-draw', function() {
            return _this.draw_next();
          });
        };
      })(this));
    };

    PathMap.prototype.draw_next = function() {
      this.idx += 1;
      if (this.idx === 3) {
        this.idx = 0;
      }
      this.current_product = products[this.idx];
      this._draw_texts();
      return this._draw_circle();
    };

    PathMap.prototype.init = function() {
      this.projection = d3.geoMercator().center([105, 28]).scale(this.width * 2.0).translate([this.width / 2, this.height / 2]);
      this.path = d3.geoPath(this.projection);
      this.layer_map = this.svg.append('g');
      this.layer_circles = this.svg.append('g');
      return this.layer_icon = this.svg.append('g');
    };

    PathMap.prototype.draw_map = function() {
      this._draw_map();
      this._draw_texts();
      this._draw_circle();
      return this._draw_warning();
    };

    PathMap.prototype._draw_texts = function() {
      var _text;
      if (this.texts != null) {
        this.texts.remove();
      }
      this.texts = this.layer_map.append('g');
      _text = (function(_this) {
        return function(color, text, y, opacity) {
          var panel, size;
          panel = _this.texts.append('g').style('transform', "translate(50px, " + (_this.height - 150 + y) + "px)").style('opacity', opacity);
          size = 24;
          panel.append('circle').attr('cx', 8).attr('cy', 8).attr('r', 16).attr('fill', color);
          return panel.append('text').attr('x', 36).attr('y', size / 2 - 4).attr('dy', '.33em').text(text).style('font-size', size + 'px').style('fill', '#ffffff');
        };
      })(this);
      _text('#f33', '辣椒原产地', 0, this.current_product === 'lajiao' ? 1 : 0.3);
      _text('#ff3', '生姜原产地', 50, this.current_product === 'shengjiang' ? 1 : 0.3);
      return _text('#3f3', '大豆原产地', 100, this.current_product === 'dadou' ? 1 : 0.3);
    };

    PathMap.prototype._draw_map = function() {
      if (this.areas != null) {
        this.areas.remove();
      }
      return this.areas = this.layer_map.selectAll('.country').data(this.features).enter().append('path').attr('class', 'country').attr('d', this.path).style('stroke', this.MAP_STROKE_COLOR).style('stroke-width', 1).style('fill', this.MAP_FILL_COLOR);
    };

    PathMap.prototype._draw_circle = function() {
      var d, i, len, points, ref, results, x, y;
      if (this.points != null) {
        this.points.remove();
      }
      points = this.points = this.layer_map.append('g');
      results = [];
      for (i = 0, len = data.length; i < len; i++) {
        d = data[i];
        ref = this.projection([d.lat, d.long]), x = ref[0], y = ref[1];
        results.push(points.append('circle').attr('class', 'chandi').attr('cx', x).attr('cy', y).attr('r', d.d).attr('fill', (function(_this) {
          return function() {
            if (d.type === 'lajiao') {
              return 'rgba(255, 51, 51, 0.7)';
            }
            if (d.type === 'shengjiang') {
              return 'rgba(255, 255, 51, 0.7)';
            }
            if (d.type === 'dadou') {
              return 'rgba(51, 255, 51, 0.7)';
            }
          };
        })(this)).style('opacity', (function(_this) {
          return function() {
            if (d.type === _this.current_product) {
              return 1;
            } else {
              return 0.05;
            }
          };
        })(this)));
      }
      return results;
    };

    PathMap.prototype._draw_warning = function() {
      var ref, ref1, x, y;
      console.log('warning');
      ref = this.projection([113.7, 34.6]), x = ref[0], y = ref[1];
      new CityAnimate(this, x, y, '#ffffff', 8, 'img/dafeng.png', '郑州：近期大风').run();
      ref1 = this.projection([106.9, 27.7]), x = ref1[0], y = ref1[1];
      return new CityAnimate(this, x, y, '#ffffff', 8, 'img/dayu.png', '遵义：近期大雨').run();
    };

    return PathMap;

  })(Graph);

  CityAnimate = (function() {
    function CityAnimate(map, x1, y1, color1, width, img, text1) {
      this.map = map;
      this.x = x1;
      this.y = y1;
      this.color = color1;
      this.width = width;
      this.img = img;
      this.text = text1;
      this.layer_icon = this.map.layer_icon;
      this.layer_circles = this.map.layer_circles;
    }

    CityAnimate.prototype.run = function() {
      var size, w;
      w = 60;
      this.layer_icon.append('image').attr('xlink:href', this.img).attr('x', this.x).attr('y', this.y).style('transform', "translate(-" + (w / 2) + "px, -" + (w / 2) + "px)").attr('width', w).attr('height', w);
      size = 20;
      this.layer_icon.append('text').attr('x', this.x + 50).attr('y', this.y).attr('dy', '.33em').text(this.text).style('font-size', size + 'px').style('fill', '#f66');
      return this.wave();
    };

    CityAnimate.prototype.wave = function() {
      this.circle_wave(0);
      return this.timer = setInterval((function(_this) {
        return function() {
          return _this.circle_wave(0);
        };
      })(this), 500);
    };

    CityAnimate.prototype.stop = function() {
      return clearInterval(this.timer);
    };

    CityAnimate.prototype.circle_wave = function(delay) {
      var circle;
      circle = this.layer_circles.insert('circle', '.map-point').attr('cx', this.x).attr('cy', this.y).attr('stroke', this.color).attr('stroke-width', this.width).attr('fill', 'transparent');
      return jQuery({
        r: 10,
        o: 1,
        w: this.width
      }).delay(delay).animate({
        r: 100,
        o: 0.6,
        w: 0
      }, {
        step: function(now, fx) {
          if (fx.prop === 'r') {
            circle.attr('r', now);
          }
          if (fx.prop === 'o') {
            circle.style('opacity', now);
          }
          if (fx.prop === 'w') {
            return circle.attr('stroke-width', now);
          }
        },
        duration: 2000,
        easing: 'easeOutQuad',
        done: function() {
          return circle.remove();
        }
      });
    };

    return CityAnimate;

  })();

  BaseTile.register('path-map', PathMap);

}).call(this);

(function() {
  jQuery(function() {
    BaseTile.paper_init();
    return setInterval(function() {
      return jQuery(document).trigger('data-map:next-draw');
    }, 5000);
  });

}).call(this);
