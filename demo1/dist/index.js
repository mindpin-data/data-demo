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
        flag = flags.append('image').attr('xlink:href', "img/" + f + ".png").attr('height', h - 30).attr('width', (h - 30) / 2 * 3).attr('x', 0).attr('y', h * idx + 30);
        offl = 90;
        amount = amounts[idx];
        bh = h - 40;
        bw = w * (amount / max);
        bar = flags.append('rect').attr('fill', 'url(#areas-bar-linear)').attr('width', bw).attr('height', bh).attr('x', offl).attr('y', h * idx + 30 + 5);
        th = 24;
        text = flags.append('text').attr('fill', '#011224').attr('x', offl + 5).attr('y', h * idx + 30 + 5 + bh / 2).attr('dy', '.33em').style('font-size', th + 'px').text(names[idx]);
        th1 = 30;
        results.push(text1 = flags.append('text').attr('fill', '#011224').attr('text-anchor', 'end').attr('x', offl + bw - 5).attr('y', h * idx + 30 + 5 + bh / 2).attr('dy', '.33em').style('font-size', th1 + 'px').style('font-weight', 'bold').text(amount));
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
      this.draw_lines();
      return this.time_loop();
    };

    LineChart.prototype.time_loop = function() {
      this.aidx = 0;
      return setInterval((function(_this) {
        return function() {
          _this.data0 = _this.data0.map(function(x) {
            var y;
            y = x + Math.random() * 10 - +Math.random() * 10;
            if (y < 0) {
              y = 0;
            }
            if (y > 180) {
              y = 180;
            }
            return y;
          });
          _this.data1 = _this.data1.map(function(x) {
            var y;
            y = x + Math.random() * 10 - +Math.random() * 10;
            if (y < 0) {
              y = 0;
            }
            if (y > 180) {
              y = 180;
            }
            return y;
          });
          return _this.draw_lines();
        };
      })(this), 5000);
    };

    LineChart.prototype.make_def = function(r, g, b, id) {
      var lg;
      lg = this.svg_defs.append('linearGradient').attr('id', id).attr('x1', '0%').attr('y1', '0%').attr('x2', '0%').attr('y2', '100%');
      lg.append('stop').attr('offset', '0%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.2)");
      return lg.append('stop').attr('offset', '100%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.0)");
    };

    LineChart.prototype.make_defs = function() {
      this.svg_defs = this.svg.append('defs');
      this.make_def(205, 255, 65, 'line-chart-linear1');
      return this.make_def(60, 180, 236, 'line-chart-linear2');
    };

    LineChart.prototype.draw_lines = function() {
      var arealine1, arealine2, d, i, idx, j, len, len1, line1, ref, ref1, results;
      if (this.panel == null) {
        this.panel = this.svg.append('g').attr('transform', "translate(40, 10)");
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
      this.panel.selectAll('path.pre-line').remove();
      this.panel.selectAll('circle').remove();
      this.panel.append('path').datum([0, 0].concat(this.data0)).attr('class', 'pre-line').attr('d', arealine1).style('fill', 'url(#line-chart-linear1)');
      this.panel.append('path').datum(this.data0).attr('class', 'pre-line').attr('d', line1).style('stroke', this.c1).style('fill', 'transparent').style('stroke-width', 2);
      ref = this.data0;
      for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
        d = ref[idx];
        this.panel.append('circle').attr('cx', this.xscale(idx)).attr('cy', this.yscale(d)).attr('r', 4).attr('fill', this.c1);
      }
      this.panel.append('path').datum([0, 0].concat(this.data1)).attr('class', 'pre-line').attr('d', arealine2).style('fill', 'url(#line-chart-linear2)');
      this.panel.append('path').datum(this.data1).attr('class', 'pre-line').attr('d', line1).style('stroke', this.c2).style('fill', 'transparent').style('stroke-width', 2);
      ref1 = this.data1;
      results = [];
      for (idx = j = 0, len1 = ref1.length; j < len1; idx = ++j) {
        d = ref1[idx];
        results.push(this.panel.append('circle').attr('cx', this.xscale(idx)).attr('cy', this.yscale(d)).attr('r', 4).attr('fill', this.c2));
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
      texts.append('text').attr('x', 10).attr('y', this.height / 2).attr('dy', '.33em').text('销量对比（单位：万）').style('font-size', size + 'px').style('fill', '#ffffff');
      texts.append('rect').attr('x', 250).attr('y', this.height / 2 - 7).attr('width', 30).attr('height', 15).style('fill', 'rgb(205, 255, 65)');
      texts.append('text').attr('x', 290).attr('y', this.height / 2).attr('dy', '.33em').text('当前销量').style('font-size', size + 'px').style('fill', '#ffffff');
      texts.append('rect').attr('x', 390).attr('y', this.height / 2 - 7).attr('width', 30).attr('height', 15).style('fill', 'rgb(60, 180, 236)');
      return texts.append('text').attr('x', 430).attr('y', this.height / 2).attr('dy', '.33em').text('历史销量').style('font-size', size + 'px').style('fill', '#ffffff');
    };

    return LineChartTitle;

  })(Graph);

  BaseTile.register('line-chart-title', LineChartTitle);

}).call(this);

(function() {
  var OneArea, area_data, toggle_areas,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  toggle_areas = ['taiguo', 'yindu', 'yuenan', 'malai', 'yinni'];

  area_data = {
    taiguo: {
      d: 2817109,
      n: '泰国',
      p: 14.3
    },
    yinni: {
      d: 3876152,
      n: '印尼',
      p: 15.4
    },
    yuenan: {
      d: 5132828,
      n: '越南',
      p: 16.5
    },
    malai: {
      d: 4078910,
      n: '马来西亚',
      p: 17.6
    },
    yindu: {
      d: 6004324,
      n: '印度',
      p: 18.7
    }
  };

  OneArea = (function(superClass) {
    extend(OneArea, superClass);

    function OneArea() {
      return OneArea.__super__.constructor.apply(this, arguments);
    }

    OneArea.prototype.draw = function() {
      this.svg = this.draw_svg();
      this.current_area = 'taiguo';
      this.draw_flag();
      this.draw_texts();
      return this.time_loop();
    };

    OneArea.prototype.time_loop = function() {
      this.aidx = 0;
      return setInterval((function(_this) {
        return function() {
          _this.aidx += 1;
          if (_this.aidx === toggle_areas.length) {
            _this.aidx = 0;
          }
          _this.current_area = toggle_areas[_this.aidx];
          _this.draw_flag();
          return _this.draw_texts();
        };
      })(this), 5000);
    };

    OneArea.prototype.draw_flag = function() {
      var flag;
      this.svg.select('g.flag').remove();
      flag = this.svg.append('g').attr('class', 'flag');
      return flag.append('image').attr('xlink:href', "img/" + this.current_area + ".png").attr('height', this.height - 60).attr('width', (this.height - 60) / 2 * 3).attr('x', 0).attr('y', 30);
    };

    OneArea.prototype.draw_texts = function() {
      var size, size1, size2, texts;
      this.svg.select('g.texts').remove();
      texts = this.svg.append('g').attr('class', 'texts').style('transform', 'translate(260px, 0px)');
      size = 40;
      texts.append('text').attr('x', 0).attr('y', size / 2 + 10).attr('dy', '.33em').text(area_data[this.current_area].n + "销量").style('font-size', size + 'px').style('fill', '#ffffff');
      size1 = 50;
      texts.append('text').attr('x', 0).attr('y', size / 2 + size + 40).attr('dy', '.33em').text(area_data[this.current_area].d).style('font-size', size1 + 'px').style('fill', '#ffff05');
      size2 = 40;
      texts.append('text').attr('x', 0).attr('y', size / 2 + size + 34 + size1 + 30).attr('dy', '.33em').text("同比 " + area_data[this.current_area].p + "%").style('font-size', size2 + 'px').style('fill', '#ffffff');
      return texts.append('image').attr('x', 215).attr('y', size / 2 + size + 34 + size1 + 30 - size2 / 2).attr('xlink:href', 'img/upicon1.png').attr('height', size2).attr('width', size2);
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
      return title = this.svg.append('text').attr('x', 70 + 30).attr('y', 10 + this.TEXT_SIZE / 2).attr('dy', '.33em').text('一带一路国家销售情况监控').style('font-size', this.TEXT_SIZE + 'px').style('fill', '#aebbcb');
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
  var CityAnimate, PathMap, areas, cities_0, cities_1, toggle_areas,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  areas = ['KAZ', 'KGZ', 'TJK', 'IRN', 'TUR', 'RUS', 'DEU', 'NLD', 'VNM', 'MYS', 'IDN', 'LKA', 'IND', 'KEN', 'GRC', 'ITA', 'THA', 'SGP'];

  toggle_areas = ['THA', 'IND', 'VNM', 'MYS', 'IDN'];

  cities_0 = [
    {
      c: '西安',
      lat: 34.34,
      long: 108.94
    }, {
      c: '兰州',
      lat: 36.07,
      long: 103.84
    }, {
      c: '乌鲁木齐',
      lat: 43.83,
      long: 87.62
    }, {
      c: '霍尔果斯',
      lat: 44.21,
      long: 80.42
    }, {
      c: '阿拉木图',
      lat: 43.24,
      long: 76.91
    }, {
      c: '比什凯克',
      lat: 42.87,
      long: 74.59
    }, {
      c: '杜尚别',
      lat: 38.5,
      long: 68.9
    }, {
      c: '德黑兰',
      lat: 35.8,
      long: 51.0
    }, {
      c: '伊斯坦布尔',
      lat: 41.0,
      long: 28.9
    }, {
      c: '莫斯科',
      lat: 55.8,
      long: 37.6
    }, {
      c: '杜伊斯堡',
      lat: 51.5,
      long: 6.8
    }, {
      c: '鹿特丹',
      lat: 51.9,
      long: 4.5
    }
  ];

  cities_1 = [
    {
      c: '福州',
      lat: 26.0,
      long: 119.0
    }, {
      c: '泉州',
      lat: 24.9,
      long: 118.6
    }, {
      c: '广州',
      lat: 23.0,
      long: 113.0
    }, {
      c: '湛江',
      lat: 21.2,
      long: 110.3
    }, {
      c: '海口',
      lat: 20.02,
      long: 110.35
    }, {
      c: '北海',
      lat: 21.49,
      long: 109.12
    }, {
      c: '河内',
      lat: 21.0,
      long: 105.9
    }, {
      c: '吉隆坡',
      lat: 3.0,
      long: 101.8
    }, {
      c: '雅加达',
      lat: -6.0,
      long: 106.9
    }, {
      c: '科伦坡',
      lat: 6.9,
      long: 79.9
    }, {
      c: '加尔各答',
      lat: 22.5,
      long: 88.0
    }, {
      c: '内罗毕',
      lat: 1.3,
      long: 36.8
    }, {
      c: '雅典',
      lat: 38.0,
      long: 23.8
    }, {
      c: '威尼斯',
      lat: 45.5,
      long: 12.0
    }
  ];

  PathMap = (function(superClass) {
    extend(PathMap, superClass);

    function PathMap() {
      return PathMap.__super__.constructor.apply(this, arguments);
    }

    PathMap.prototype.draw = function() {};

    PathMap.prototype.draw = function() {
      this.MAP_STROKE_COLOR = '#021225';
      this.MAP_FILL_COLOR = '#323c48';
      this.MAP_FILL_COLOR_YDYL = '#455363';
      this.MAP_FILL_COLOR_CN = '#455363';
      this.svg = this.draw_svg();
      this.areas = areas;
      this.current_area = 'THA';
      this.main_area = 'CHN';
      return this.load_data();
    };

    PathMap.prototype.load_data = function() {
      return d3.json('data/world-countries.json?1', (function(_this) {
        return function(error, _data) {
          _this.features = _data.features;
          console.log(_this.features.map(function(x) {
            return x.id;
          }));
          _this.draw_map();
          _this.draw_cities();
          return _this.time_loop();
        };
      })(this));
    };

    PathMap.prototype.time_loop = function() {
      this.aidx = 0;
      return setInterval((function(_this) {
        return function() {
          _this.aidx += 1;
          if (_this.aidx === toggle_areas.length) {
            _this.aidx = 0;
          }
          _this.current_area = toggle_areas[_this.aidx];
          return _this._draw_map();
        };
      })(this), 5000);
    };

    PathMap.prototype.draw_map = function() {
      this.projection = d3.geoMercator().center([68, 30]).scale(this.width * 0.42).translate([this.width / 2, this.height / 2]);
      this.path = d3.geoPath(this.projection);
      this.g_map = this.svg.append('g');
      return this._draw_map();
    };

    PathMap.prototype._draw_map = function() {
      var countries, feature, ref, x, y;
      this.g_map.selectAll('.country').remove();
      countries = this.g_map.selectAll('.country').data(this.features).enter().append('path').attr('class', 'country').attr('d', this.path).style('stroke', this.MAP_STROKE_COLOR).style('stroke-width', 2).style('fill', (function(_this) {
        return function(d) {
          if (d.id === _this.main_area) {
            return _this.MAP_FILL_COLOR_CN;
          }
          if (d.id === _this.current_area) {
            return 'rgba(52, 206, 233, 0.7)';
          }
          if (_this.areas.indexOf(d.id) > -1) {
            return _this.MAP_FILL_COLOR_YDYL;
          }
          return _this.MAP_FILL_COLOR;
        };
      })(this));
      feature = this.features.filter((function(_this) {
        return function(x) {
          return x.id === _this.current_area;
        };
      })(this))[0];
      if (feature) {
        ref = this.path.centroid(feature), x = ref[0], y = ref[1];
        new CityAnimate(this, x, y, '#ff9999', 8).run();
        this.g_map.selectAll('image').remove();
        return this.g_map.append('image').attr('class', 'map-point').attr('xlink:href', 'img/mapicon1.png').attr('x', x).attr('y', y).style('transform', 'translate(-30px, -50px)').attr('width', 60).attr('height', 60);
      }
    };

    PathMap.prototype.draw_cities = function() {
      var city, i, j, len, len1, line1, points, ref, ref1;
      points = this.svg;
      for (i = 0, len = cities_0.length; i < len; i++) {
        city = cities_0[i];
        ref = this.projection([city.long, city.lat]), city.x = ref[0], city.y = ref[1];
        points.append('circle').attr('class', 'runnin').attr('cx', city.x).attr('cy', city.y).attr('r', 8).attr('fill', '#34cee9');
      }
      for (j = 0, len1 = cities_1.length; j < len1; j++) {
        city = cities_1[j];
        ref1 = this.projection([city.long, city.lat]), city.x = ref1[0], city.y = ref1[1];
        points.append('circle').attr('class', 'runnin').attr('cx', city.x).attr('cy', city.y).attr('r', 8).attr('fill', '#34cee9');
      }
      line1 = d3.line().x((function(_this) {
        return function(d) {
          return d.x;
        };
      })(this)).y((function(_this) {
        return function(d) {
          return d.y;
        };
      })(this)).curve(d3.curveCatmullRom.alpha(0.5));
      points.append('path').attr('class', 'running').datum(cities_0).attr('d', line1).style('stroke', 'rgb(205, 255, 65)').style('fill', 'transparent').style('stroke-width', 5).style('stroke-dasharray', '5 10').style('stroke-linecap', 'round');
      return points.append('path').attr('class', 'running').datum(cities_1).attr('d', line1).style('stroke', '#ff7c41').style('fill', 'transparent').style('stroke-width', 5).style('stroke-dasharray', '5 10').style('stroke-linecap', 'round');
    };

    return PathMap;

  })(Graph);

  CityAnimate = (function() {
    function CityAnimate(map, x1, y1, color, width, img) {
      this.map = map;
      this.x = x1;
      this.y = y1;
      this.color = color;
      this.width = width;
      this.img = img;
      this.g_map = this.map.g_map;
    }

    CityAnimate.prototype.run = function() {
      return this.wave();
    };

    CityAnimate.prototype.wave = function() {
      this.circle_wave(0);
      this.circle_wave(500);
      this.circle_wave(1000);
      this.circle_wave(1500);
      return this.circle_wave(2000);
    };

    CityAnimate.prototype.circle_wave = function(delay) {
      var circle;
      circle = this.g_map.insert('circle', '.map-point').attr('cx', this.x).attr('cy', this.y).attr('stroke', this.color).attr('stroke-width', this.width).attr('fill', 'transparent');
      return jQuery({
        r: 10,
        o: 1
      }).delay(delay).animate({
        r: 100,
        o: 0
      }, {
        step: function(now, fx) {
          if (fx.prop === 'r') {
            circle.attr('r', now);
          }
          if (fx.prop === 'o') {
            return circle.style('opacity', now);
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
    return BaseTile.paper_init();
  });

}).call(this);
