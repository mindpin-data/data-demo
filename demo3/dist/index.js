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
      this.draw_lines();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          return _this.draw_lines();
        };
      })(this));
    };

    LineChart.prototype.draw_lines = function() {
      var _draw, line1;
      if (this.panel != null) {
        this.panel.remove();
      }
      this.panel = this.svg.append('g').attr('transform', "translate(150, 10)");
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
      _draw = (function(_this) {
        return function(data, color, dasharray) {
          var _data, curve;
          _data = data.map(function(x) {
            return 0;
          });
          curve = _this.panel.append('path').datum(_data).attr('class', 'pre-line').attr('d', line1).style('stroke', color).style('fill', 'transparent').style('stroke-width', 2).style('stroke-dasharray', dasharray).style('stroke-linecap', 'round');
          curve.datum(data).transition().duration(1000).attr('d', line1);
          return _data.forEach(function(d, idx) {
            var c;
            c = _this.panel.append('circle').attr('cx', _this.xscale(idx)).attr('cy', _this.yscale(d)).attr('r', 4).attr('fill', color);
            return c.transition().duration(1000).attr('cy', _this.yscale(data[idx]));
          });
        };
      })(this);
      _draw(this.data2, this.c3);
      _draw(this.data1, this.c2, '5 5');
      return _draw(this.data0, this.c1);
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
      this.number_color = '#ffde00';
      this.draw_texts();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          return _this.draw_texts();
        };
      })(this));
    };

    LineChartTitle.prototype.draw_texts = function() {
      var size, t1, t2, texts;
      if (this.texts != null) {
        this.texts.remove();
      }
      texts = this.texts = this.svg.append('g').style('transform', 'translate(1100px, 0px)');
      size = 40;
      texts.append('text').attr('x', -1050).attr('y', this.height / 2).attr('dy', '.33em').text('产品总体销量').style('font-size', size + "px").style('fill', '#ffffff');
      t1 = texts.append('text').attr('x', -1050 + 270).attr('y', this.height / 2).attr('dy', '.33em').text(889718890).style('font-size', (size * 1.5) + "px").style('fill', this.number_color);
      jQuery({
        n: 0
      }).animate({
        n: 889718890
      }, {
        step: function(now) {
          return t1.text(~~now);
        }
      });
      texts.append('text').attr('x', -1050 + 600).attr('y', this.height / 2).attr('dy', '.33em').text('产品出口销量').style('font-size', size + "px").style('fill', '#ffffff');
      t2 = texts.append('text').attr('x', -1050 + 600 + 270).attr('y', this.height / 2).attr('dy', '.33em').text(142210067).style('font-size', (size * 1.5) + "px").style('fill', this.number_color);
      jQuery({
        n: 0
      }).animate({
        n: 142210067
      }, {
        step: function(now) {
          return t2.text(~~now);
        }
      });
      size = 20;
      texts.append('rect').attr('x', 250).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c1);
      texts.append('text').attr('x', 290).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('实际销量').style('font-size', size + "px").style('fill', '#ffffff');
      texts.append('rect').attr('x', 390).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c2);
      texts.append('text').attr('x', 430).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('预测销量').style('font-size', size + "px").style('fill', '#ffffff');
      texts.append('rect').attr('x', 530).attr('y', this.height / 2 - 7 + 30).attr('width', 30).attr('height', 15).style('fill', this.c3);
      return texts.append('text').attr('x', 570).attr('y', this.height / 2 + 30).attr('dy', '.33em').text('上年同比销量').style('font-size', size + "px").style('fill', '#ffffff');
    };

    return LineChartTitle;

  })(Graph);

  BaseTile.register('line-chart-title', LineChartTitle);

}).call(this);

(function() {
  var CityAnimate, PathMap, cn_cities, floop, max_number, plane_path, rand_item_of, world_cities,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  plane_path = 'm25.21488,3.93375c-0.44355,0 -0.84275,0.18332 -1.17933,0.51592c-0.33397,0.33267 -0.61055,0.80884 -0.84275,1.40377c-0.45922,1.18911 -0.74362,2.85964 -0.89755,4.86085c-0.15655,1.99729 -0.18263,4.32223 -0.11741,6.81118c-5.51835,2.26427 -16.7116,6.93857 -17.60916,7.98223c-1.19759,1.38937 -0.81143,2.98095 -0.32874,4.03902l18.39971,-3.74549c0.38616,4.88048 0.94192,9.7138 1.42461,13.50099c-1.80032,0.52703 -5.1609,1.56679 -5.85232,2.21255c-0.95496,0.88711 -0.95496,3.75718 -0.95496,3.75718l7.53,-0.61316c0.17743,1.23545 0.28701,1.95767 0.28701,1.95767l0.01304,0.06557l0.06002,0l0.13829,0l0.0574,0l0.01043,-0.06557c0,0 0.11218,-0.72222 0.28961,-1.95767l7.53164,0.61316c0,0 0,-2.87006 -0.95496,-3.75718c-0.69044,-0.64577 -4.05363,-1.68813 -5.85133,-2.21516c0.48009,-3.77545 1.03061,-8.58921 1.42198,-13.45404l18.18207,3.70115c0.48009,-1.05806 0.86881,-2.64965 -0.32617,-4.03902c-0.88969,-1.03062 -11.81147,-5.60054 -17.39409,-7.89352c0.06524,-2.52287 0.04175,-4.88024 -0.1148,-6.89989l0,-0.00476c-0.15655,-1.99844 -0.44094,-3.6683 -0.90277,-4.8561c-0.22699,-0.59493 -0.50356,-1.07111 -0.83754,-1.40377c-0.33658,-0.3326 -0.73578,-0.51592 -1.18194,-0.51592l0,0l-0.00001,0l0,0z';

  plane_path = "M25 0 L50 50 L0 50 z";

  cn_cities = [
    {
      name: '北京　',
      number: 7355291,
      lat: 116.4,
      long: 39.9
    }, {
      name: '天津　',
      number: 3963604,
      lat: 117.2,
      long: 39.1
    }, {
      name: '河北　',
      number: 20813492,
      lat: 114.3,
      long: 38.0
    }, {
      name: '山西　',
      number: 10654162,
      lat: 112.3,
      long: 37.6
    }, {
      name: '内蒙古',
      number: 8470472,
      lat: 111.4,
      long: 40.5
    }, {
      name: '辽宁　',
      number: 15334912,
      lat: 123.3,
      long: 41.5
    }, {
      name: '吉林　',
      number: 9162183,
      lat: 125.2,
      long: 43.5
    }, {
      name: '黑龙江',
      number: 13192935,
      lat: 126.4,
      long: 45.4
    }, {
      name: '上海　',
      number: 8893483,
      lat: 121.2,
      long: 31.1
    }, {
      name: '江苏　',
      number: 25635291,
      lat: 118.5,
      long: 32.0
    }, {
      name: '浙江　',
      number: 20060115,
      lat: 120.2,
      long: 30.2
    }, {
      name: '安徽　',
      number: 19322432,
      lat: 117.2,
      long: 31.5
    }, {
      name: '福建　',
      number: 11971873,
      lat: 119.2,
      long: 26.0
    }, {
      name: '江西　',
      number: 11847841,
      lat: 115.6,
      long: 28.4
    }, {
      name: '山东　',
      number: 30794664,
      lat: 117.0,
      long: 36.4
    }, {
      name: '河南　',
      number: 26404973,
      lat: 113.4,
      long: 34.5
    }, {
      name: '湖北　',
      number: 17253385,
      lat: 114.2,
      long: 30.3
    }, {
      name: '湖南　',
      number: 19029894,
      lat: 112.6,
      long: 28.1
    }, {
      name: '广东　',
      number: 32222752,
      lat: 113.2,
      long: 23.1
    }, {
      name: '广西　',
      number: 13467663,
      lat: 108.2,
      long: 22.4
    }, {
      name: '海南　',
      number: 2451819,
      lat: 110.2,
      long: 20.0
    }, {
      name: '重庆　',
      number: 10272559,
      lat: 106.4,
      long: 29.5
    }, {
      name: '四川　',
      number: 26383458,
      lat: 104.0,
      long: 30.4
    }, {
      name: '贵州　',
      number: 10745630,
      lat: 106.4,
      long: 26.3
    }, {
      name: '云南　',
      number: 12695396,
      lat: 102.4,
      long: 25.0
    }, {
      name: '西藏　',
      number: 689521,
      lat: 91.1,
      long: 29.4
    }, {
      name: '陕西　',
      number: 11084516,
      lat: 108.6,
      long: 34.2
    }, {
      name: '甘肃　',
      number: 7113833,
      lat: 103.5,
      long: 36.0
    }, {
      name: '青海　',
      number: 1586635,
      lat: 101.5,
      long: 36.3
    }, {
      name: '宁夏　',
      number: 1945064,
      lat: 106.2,
      long: 38.3
    }, {
      name: '新疆　',
      number: 6902850,
      lat: 87.4,
      long: 43.5
    }, {
      name: '台湾　',
      number: 8222222,
      lat: 121.3,
      long: 25.0
    }
  ];

  world_cities = [
    {
      name: '莫斯科',
      number: 17355291,
      lat: 37.4,
      long: 55.5
    }, {
      name: '柏林　',
      number: 17355291,
      lat: 13.3,
      long: 52.3
    }, {
      name: '伦敦　',
      number: 17355291,
      lat: 0.1,
      long: 51.3
    }, {
      name: '巴黎　',
      number: 17355291,
      lat: 2.2,
      long: 48.5
    }, {
      name: '罗马　',
      number: 17355291,
      lat: 12.3,
      long: 41.5
    }, {
      name: '华盛顿',
      number: 17355291,
      lat: -77.0,
      long: 38.5
    }, {
      name: '首尔　',
      number: 17355291,
      lat: 126.1,
      long: 37.3
    }, {
      name: '东京　',
      number: 17355291,
      lat: 139.5,
      long: 35.4
    }, {
      name: '洛杉矶',
      number: 17355291,
      lat: -118.2,
      long: 34.5
    }, {
      name: '新加坡',
      number: 17355291,
      lat: 103.5,
      long: 1.2
    }, {
      name: '雅加达　　',
      number: 17355291,
      lat: 106.5,
      long: -6.1
    }, {
      name: '里约热内卢',
      number: 17355291,
      lat: -43.2,
      long: -22.5
    }, {
      name: '圣地亚哥　',
      number: 17355291,
      lat: -70.4,
      long: -33.3
    }, {
      name: '悉尼　　　',
      number: 17355291,
      lat: 151.1,
      long: -33.3
    }, {
      name: '奥克兰　　',
      number: 17355291,
      lat: 174.5,
      long: -36.5
    }, {
      name: '墨尔本　　',
      number: 17355291,
      lat: 144.6,
      long: -37.5
    }, {
      name: '新德里　　',
      number: 17355291,
      lat: 77.2,
      long: 28.5
    }, {
      name: '开普敦　　',
      number: 17355291,
      lat: 19.0,
      long: -34.0
    }
  ];

  max_number = 0;

  cn_cities.forEach(function(x) {
    return max_number = Math.max(x.number, max_number);
  });

  floop = function(func, duration) {
    func();
    return setInterval(function() {
      return func();
    }, duration);
  };

  rand_item_of = function(arr) {
    return arr[Math.floor(arr.length * Math.random())];
  };

  PathMap = (function(superClass) {
    extend(PathMap, superClass);

    function PathMap() {
      return PathMap.__super__.constructor.apply(this, arguments);
    }

    PathMap.prototype.draw = function() {
      this.MAP_STROKE_COLOR = '#021225';
      this.MAP_FILL_COLOR = '#323c48';
      this.svg = this.draw_svg();
      this.load_data();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          return _this.next_draw();
        };
      })(this));
    };

    PathMap.prototype.next_draw = function() {
      return this.random_city();
    };

    PathMap.prototype.load_data = function() {
      return d3.json('data/world-countries.json?1', (function(_this) {
        return function(error, _data) {
          _this.features = _data.features;
          _this.draw_map();
          _this.draw_heatmap();
          _this.svg1 = _this.draw_svg().style('position', 'absolute').style('left', '0').style('top', '0');
          return _this.random_city();
        };
      })(this));
    };

    PathMap.prototype.draw_map = function() {
      this.map_scale = 0.16;
      this.projection = d3.geoEquirectangular().center([8, 13]).scale(this.width * this.map_scale).translate([this.width / 2, this.height / 2]);
      this.path = d3.geoPath(this.projection);
      this.g_map = this.svg.append('g');
      return this._draw_map();
    };

    PathMap.prototype._draw_map = function() {
      var countries;
      this.g_map.selectAll('.country').remove();
      return countries = this.g_map.selectAll('.country').data(this.features).enter().append('path').attr('class', 'country').attr('d', this.path).style('stroke', this.MAP_STROKE_COLOR).style('stroke-width', 1).style('fill', this.MAP_FILL_COLOR);
    };

    PathMap.prototype.draw_circles = function() {
      var cities;
      cities = [].concat(cn_cities).concat(world_cities);
      return cities.forEach((function(_this) {
        return function(p) {
          var circle, oscale, ref, x, y;
          ref = _this.projection([p.lat, p.long]), x = ref[0], y = ref[1];
          oscale = d3.scaleLinear().domain([0, max_number]).range([0, 1]);
          return circle = _this.g_map.append('circle').attr('cx', x).attr('cy', y).attr('r', 8).attr('fill', '#34cee9').style('opacity', oscale(p.number));
        };
      })(this));
    };

    PathMap.prototype.draw_heatmap = function() {
      var cities, data, heatmapInstance, points;
      heatmapInstance = h337.create({
        container: jQuery('#heatmap')[0],
        radius: 8,
        gradient: {
          '0.0': '#34cee9',
          '0.3': '#34cee9',
          '1.0': 'white'
        }
      });
      cities = [].concat(cn_cities).concat(world_cities);
      points = cities.map((function(_this) {
        return function(c) {
          var ref, x, y;
          ref = _this.projection([c.lat, c.long]), x = ref[0], y = ref[1];
          return {
            x: ~~x,
            y: ~~y,
            value: c.number
          };
        };
      })(this));
      data = {
        max: max_number,
        data: points
      };
      console.log(points);
      return heatmapInstance.setData(data);
    };

    PathMap.prototype.random_city = function() {
      this._r(cn_cities, '#cff1ae');
      this._r(cn_cities, '#cff1ae');
      this._r(world_cities, '#f1c4ae');
      this._r(world_cities, '#f1c4ae');
      return setTimeout((function(_this) {
        return function() {
          _this._r(cn_cities, '#cff1ae');
          _this._r(cn_cities, '#cff1ae');
          _this._r(world_cities, '#f1c4ae');
          return _this._r(world_cities, '#f1c4ae');
        };
      })(this), 2500);
    };

    PathMap.prototype._r = function(arr, color) {
      var p, ref, x, y;
      p = rand_item_of(arr);
      ref = this.projection([p.lat, p.long]), x = ref[0], y = ref[1];
      return new CityAnimate(this, x, y, color, 4).run();
    };

    return PathMap;

  })(Graph);

  CityAnimate = (function() {
    function CityAnimate(map, x1, y1, color1, width) {
      this.map = map;
      this.x = x1;
      this.y = y1;
      this.color = color1;
      this.width = width;
      this.g_map = this.map.svg1;
    }

    CityAnimate.prototype.run = function() {
      return this.flight_animate();
    };

    CityAnimate.prototype.flight_animate = function() {
      var ref;
      ref = this.map.projection([106.4, 26.3]), this.gyx = ref[0], this.gyy = ref[1];
      this.draw_plane();
      this.draw_route();
      return this.fly();
    };

    CityAnimate.prototype.draw_plane = function() {
      return this.plane = this.g_map.append('path').attr('class', 'plane').attr('d', plane_path).attr('fill', 'white');
    };

    CityAnimate.prototype.draw_route = function() {
      return this.route = this.g_map.append('path').attr('d', "M" + this.gyx + " " + this.gyy + " L" + this.x + " " + this.y).style('stroke', 'transparent');
    };

    CityAnimate.prototype.fly = function() {
      var count, dx, dy, l, path, r, scale, xoff, yoff;
      path = this.route.node();
      l = path.getTotalLength();
      dx = this.x - this.gyx;
      dy = this.y - this.gyy;
      r = 90 - Math.atan2(-dy, dx) * 180 / Math.PI;
      scale = 0.3;
      xoff = 50 * scale * 0.5;
      yoff = 50 * scale * 0.5;
      count = 0;
      return jQuery({
        t: 0
      }).animate({
        t: 1
      }, {
        step: (function(_this) {
          return function(now, fx) {
            var p;
            p = path.getPointAtLength(now * l);
            count += 1;
            if (count % 4 === 0) {
              _this.route_circle_wave(p.x, p.y);
            }
            return _this.plane.attr('transform', "translate(" + (p.x - xoff) + ", " + (p.y - yoff) + ") rotate(" + r + ", " + xoff + ", " + yoff + ") scale(" + scale + ")");
          };
        })(this),
        duration: Math.sqrt(l) * 150,
        easing: 'linear',
        done: (function(_this) {
          return function() {
            _this.route.remove();
            _this.three_circles_wave();
            return jQuery({
              o: 1
            }).animate({
              o: 0
            }, {
              step: function(now, fx) {
                return _this.plane.style('opacity', now);
              },
              duration: 1000,
              done: function() {
                return _this.plane.remove();
              }
            });
          };
        })(this)
      });
    };

    CityAnimate.prototype.route_circle_wave = function(x, y) {
      var circle;
      circle = this.g_map.insert('circle', '.plane').attr('cx', x).attr('cy', y).attr('stroke', this.color).attr('stroke-width', this.width).attr('fill', this.color);
      return jQuery({
        r: 0,
        o: 0.9
      }).delay(100).animate({
        r: 5,
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

    CityAnimate.prototype.three_circles_wave = function() {
      this.circle_wave(0);
      this.circle_wave(500);
      return this.circle_wave(1000);
    };

    CityAnimate.prototype.circle_wave = function(delay) {
      var circle;
      circle = this.g_map.append('circle').attr('cx', this.x).attr('cy', this.y).attr('stroke', this.color).attr('stroke-width', this.width).attr('fill', 'transparent');
      return jQuery({
        r: 5,
        o: 1
      }).delay(delay).animate({
        r: 50,
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
    BaseTile.paper_init();
    return setInterval(function() {
      return jQuery(document).trigger('data-map:next-draw');
    }, 5000);
  });

}).call(this);
