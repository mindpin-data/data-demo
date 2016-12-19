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
  var DrawTitle;

  window.COLOR_IN = 'rgba(149, 222, 255, 0.9)';

  window.COLOR_OUT = 'rgba(65, 196, 255, 0.9)';

  window.COLOR_BALANCE = 'rgba(231, 255, 149, 0.9)';

  window.COLOR_BALANCE_OVERLOAD = 'rgba(243, 157, 119, 0.9)';

  window.COLOR_BALANCE_DEEP = 'rgba(138, 152, 89, 0.9)';

  window.BG_COLOR = '#17243C';

  window.GOOD_COLOR = '#97FF41';

  window.BAD_COLOR = '#FF7C41';

  window.DrawTitle = DrawTitle = (function() {
    function DrawTitle() {}

    DrawTitle.prototype.draw_svg = function() {
      this.width = this.$elm.width();
      this.height = this.$elm.height();
      return this.svg = d3.select(this.$elm[0]).append('svg').attr('width', this.width).attr('height', this.height);
    };

    DrawTitle.prototype.draw_title = function(text) {
      var title;
      if (text == null) {
        text = this.$elm.data('title');
      }
      this.title_height = 40;
      title = this.svg.append('g').attr('class', 'title');
      return title.append('text').attr('dx', this.width / 2).attr('dy', this.title_height / 2 + 16 / 2 - 2).attr('text-anchor', 'middle').text(text);
    };

    DrawTitle.prototype.draw_gpanel = function() {
      this.gheight = this.height - this.title_height;
      this.gwidth = this.width;
      return this.gpanel = this.svg.append('g').attr('transform', "translate(0, " + this.title_height + ")");
    };

    DrawTitle.prototype.rotate_pie = function(path) {
      var n, repeat, rotate;
      rotate = 0;
      n = 0;
      repeat = function() {
        rotate += 36;
        return path.each(function() {
          return n += 1;
        }).transition().duration(1000).ease(d3.easeLinear).attr('transform', "rotate(" + rotate + ")").on('end', function() {
          n -= 1;
          if (n === 0) {
            return repeat();
          }
        });
      };
      return repeat();
    };

    return DrawTitle;

  })();

}).call(this);

(function() {
  var AmountBar,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.AmountBar = AmountBar = (function(superClass) {
    extend(AmountBar, superClass);

    function AmountBar($elm, data1) {
      this.$elm = $elm;
      this.data = data1;
      this.axisx_size = 30;
      this.axisy_size = 60;
    }

    AmountBar.prototype.draw = function() {
      this.draw_svg();
      this.draw_title();
      this.draw_gpanel();
      this._g();
      return this.draw_in_out_amount_bar();
    };

    AmountBar.prototype._g = function() {
      this.panel = this.gpanel.append('g').attr('transform', "translate(" + this.axisy_size + ", 0)");
      this.axisx = this.gpanel.append('g').attr('class', 'axis axis-x').attr('transform', "translate(" + this.axisy_size + ", " + (this.gheight - this.axisx_size) + ")");
      this.axisy1 = this.gpanel.append('g').attr('class', 'axis axis-y').attr('transform', "translate(" + this.axisy_size + ", 0)");
      this.axisy2 = this.gpanel.append('g').attr('class', 'axis axis-y').attr('transform', "translate(" + this.axisy_size + ", " + ((this.gheight - this.axisx_size) / 2) + ")");
      return this.line = this.gpanel.append('g').attr('transform', "translate(" + this.axisy_size + ", 0)");
    };

    AmountBar.prototype.draw_in_out_amount_bar = function() {
      var bar_width, data, height, in_amount_bar, line1, line2, out_amount_bar, width, xscale, yscale1, yscale2;
      data = this.data.map(function(d) {
        return Object.assign({
          predictive_in_amount: d3.randomUniform(d.in_amount - 50, d.in_amount + 50)(),
          predictive_out_amount: d3.randomUniform(d.out_amount - 50, d.out_amount + 50)()
        }, d);
      });
      width = this.gwidth - this.axisy_size;
      height = this.gheight - this.axisx_size;
      yscale1 = d3.scaleLinear().domain([0, 400]).range([height / 2, 0]);
      yscale2 = d3.scaleLinear().domain([0, 400]).range([0, height / 2]);
      xscale = d3.scaleBand().domain(data.map(function(d) {
        return d.date;
      })).range([0, width]).paddingInner(0.3333).paddingOuter(0.3333);
      bar_width = xscale.bandwidth();
      in_amount_bar = this.panel.selectAll('.in-amount-bar').data(data).enter().append('rect').attr('class', 'in-amount-bar').attr('width', bar_width).attr('fill', COLOR_IN).attr('height', function(d) {
        return height / 2 - yscale1(d.in_amount);
      }).attr('transform', function(d) {
        return "translate(" + (xscale(d.date)) + ", " + (yscale1(d.in_amount)) + ")";
      });
      out_amount_bar = this.panel.selectAll('.out-amount-bar').data(data).enter().append('rect').attr('class', 'out-amount-bar').attr('width', bar_width).attr('height', function(d) {
        return yscale2(d.out_amount);
      }).attr('fill', COLOR_OUT).attr('transform', function(d) {
        return "translate(" + (xscale(d.date)) + ", " + (height / 2) + ")";
      });
      this.axisx.call(d3.axisBottom(xscale));
      this.axisy1.call(d3.axisLeft(yscale1).ticks(4));
      this.axisy2.call(d3.axisLeft(yscale2).ticks(4));
      line1 = d3.line().x(function(d) {
        return xscale(d.date) + bar_width / 2;
      }).y(function(d) {
        return yscale1(d.predictive_in_amount);
      });
      this.line.append('path').datum(data).attr('class', 'pre-line').attr('d', line1);
      line2 = d3.line().x(function(d) {
        return xscale(d.date) + bar_width / 2;
      }).y(function(d) {
        return yscale2(d.predictive_out_amount);
      });
      return this.line.append('path').datum(data).attr('class', 'pre-line').attr('d', line2).attr('transform', function(d) {
        return "translate(0, " + (height / 2) + ")";
      });
    };

    return AmountBar;

  })(DrawTitle);

}).call(this);

(function() {
  var AmountBar2,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.AmountBar2 = AmountBar2 = (function(superClass) {
    extend(AmountBar2, superClass);

    function AmountBar2($elm, data1) {
      this.$elm = $elm;
      this.data = data1;
      this.axisx_size = 30;
      this.axisy_size = 60;
    }

    AmountBar2.prototype.draw = function() {
      this.draw_svg();
      this.draw_title();
      this.draw_gpanel();
      this._g();
      return this.draw_amount_bar();
    };

    AmountBar2.prototype._g = function() {
      this.panel = this.gpanel.append('g').attr('transform', "translate(" + this.axisy_size + ", 0)");
      this.axisx = this.gpanel.append('g').attr('class', 'axis axis-x').attr('transform', "translate(" + this.axisy_size + ", " + (this.gheight - this.axisx_size) + ")");
      return this.axisy = this.gpanel.append('g').attr('class', 'axis axis-y').attr('transform', "translate(" + this.axisy_size + ", 0)");
    };

    AmountBar2.prototype.draw_amount_bar = function() {
      var amount_bar, bar_width, data, height, line1, line2, width, xscale, yscale;
      data = this.data.map(function(d) {
        return Object.assign({
          upper_limit: d3.randomUniform(d.balance_amount - 20, d.balance_amount + 100)(),
          lower_limit: d3.randomUniform(d.balance_amount - 100, d.balance_amount - 50)()
        }, d);
      });
      width = this.gwidth - this.axisy_size;
      height = this.gheight - this.axisx_size;
      yscale = d3.scaleLinear().domain([0, 400]).range([height, 0]);
      xscale = d3.scaleBand().domain(data.map(function(d) {
        return d.date;
      })).range([0, width]).paddingInner(0.3333).paddingOuter(0.3333);
      bar_width = xscale.bandwidth();
      amount_bar = this.panel.selectAll('.in-amount-bar').data(data).enter().append('rect').attr('class', 'in-amount-bar').attr('width', bar_width).attr('fill', function(d) {
        if (d.balance_amount > d.upper_limit || d.balance_amount < d.lower_limit) {
          return COLOR_BALANCE_OVERLOAD;
        }
        return COLOR_BALANCE;
      }).attr('height', function(d) {
        return height - yscale(d.balance_amount);
      }).attr('transform', function(d) {
        return "translate(" + (xscale(d.date)) + ", " + (yscale(d.balance_amount)) + ")";
      });
      this.axisx.call(d3.axisBottom(xscale));
      this.axisy.call(d3.axisLeft(yscale).ticks(4));
      line1 = d3.line().x(function(d) {
        return xscale(d.date) + bar_width / 2;
      }).y(function(d) {
        return yscale(d.upper_limit);
      });
      this.panel.append('path').datum(data).attr('class', 'pre-line').attr('d', line1);
      line2 = d3.line().x(function(d) {
        return xscale(d.date) + bar_width / 2;
      }).y(function(d) {
        return yscale(d.lower_limit);
      });
      return this.panel.append('path').datum(data).attr('class', 'pre-line').attr('d', line2);
    };

    return AmountBar2;

  })(DrawTitle);

}).call(this);

(function() {
  var AmountPie,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.AmountPie = AmountPie = (function(superClass) {
    extend(AmountPie, superClass);

    function AmountPie($elm, data1) {
      this.$elm = $elm;
      this.data = data1;
      this.pie_data = [
        {
          label: '入库',
          amount: d3.sum(this.data.map(function(d) {
            return d.in_amount;
          })),
          color: COLOR_IN
        }, {
          label: '出库',
          amount: d3.sum(this.data.map(function(d) {
            return d.out_amount;
          })),
          color: COLOR_OUT
        }
      ];
      this.bar_width = 100;
      this.text_width = 80;
      this.bar_top_off = 40;
    }

    AmountPie.prototype.draw = function() {
      var x;
      this.draw_svg();
      this.draw_title();
      this.draw_gpanel();
      x = this.gwidth - (this.gwidth - this.bar_width - this.text_width) / 2;
      this.arc_panel = this.gpanel.append('g').attr('class', 'pie').attr('transform', "translate(" + x + ", " + (this.gheight / 2) + ")");
      this.bar_panel = this.gpanel.append('g').attr('transform', "translate(" + this.text_width + ", " + this.bar_top_off + ")");
      this.axis_panel = this.gpanel.append('g').attr('class', 'axis').attr('transform', "translate(" + this.text_width + ", " + this.bar_top_off + ")");
      this.draw_pie();
      return this.draw_bar();
    };

    AmountPie.prototype.draw_pie = function() {
      var arc, g, height, inner_radius, max_amount, min, path, pie, radius, scale, width;
      width = this.gwidth - this.bar_width - this.text_width;
      height = this.gheight;
      min = Math.min(width, height) / 2;
      radius = min * 0.8;
      inner_radius = radius * 0.4;
      pie = d3.pie().value(1);
      max_amount = d3.max(this.pie_data.map(function(d) {
        return d.amount;
      }));
      scale = d3.scaleSqrt().domain([0, max_amount]).range([inner_radius, radius]);
      g = this.arc_panel.selectAll('.arc').data(pie(this.pie_data)).enter().append('g').attr('class', 'arc');
      arc = d3.arc().outerRadius(function(d) {
        return scale(d.data.amount);
      }).innerRadius(inner_radius);
      path = g.append('path').attr('d', arc).attr('fill', function(d) {
        return d.data.color;
      }).attr('stroke', BG_COLOR).attr('stroke-width', 1);
      return this.rotate_pie(path);
    };

    AmountPie.prototype.draw_bar = function() {
      var bar_width, data, height, max, width, xscale, yscale;
      width = this.bar_width;
      height = this.pie_data.length * 32;
      data = this.pie_data;
      max = d3.max(data.map(function(d) {
        return d.amount;
      }));
      xscale = d3.scaleLinear().domain([0, max]).range([0, width]);
      yscale = d3.scaleBand().domain(data.map(function(d) {
        return d.label;
      })).range([0, height]).paddingInner(0.2).paddingOuter(0.2);
      bar_width = yscale.bandwidth();
      this.bar_panel.selectAll('.bar').data(data).enter().append('rect').attr('class', 'bar').attr('height', bar_width).attr('width', function(d) {
        return xscale(d.amount);
      }).attr('fill', function(d) {
        return d.color;
      }).attr('transform', function(d) {
        return "translate(0, " + (yscale(d.label)) + ")";
      });
      return this.axis_panel.call(d3.axisLeft(yscale));
    };

    return AmountPie;

  })(DrawTitle);

}).call(this);

(function() {
  var BalanceAmountPie,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.BalanceAmountPie = BalanceAmountPie = (function(superClass) {
    extend(BalanceAmountPie, superClass);

    function BalanceAmountPie($elm, data1) {
      this.$elm = $elm;
      this.data = data1;
      this.bar_width = 120;
      this.text_width = 80;
      this.bar_top_off = 40;
    }

    BalanceAmountPie.prototype.draw = function() {
      var x;
      this.draw_svg();
      this.draw_title();
      this.draw_gpanel();
      x = this.gwidth - (this.gwidth - this.bar_width - this.text_width) / 2;
      this.arc_panel = this.gpanel.append('g').attr('class', 'pie').attr('transform', "translate(" + x + ", " + (this.gheight / 2) + ")");
      this.bar_panel = this.gpanel.append('g').attr('transform', "translate(" + this.text_width + ", " + this.bar_top_off + ")");
      this.axis_panel = this.gpanel.append('g').attr('class', 'axis').attr('transform', "translate(" + this.text_width + ", " + this.bar_top_off + ")");
      this.draw_pie();
      return this.draw_bar();
    };

    BalanceAmountPie.prototype.draw_pie = function() {
      var arc, color, g, height, inner_radius, max_amount, min, path, pie, radius, scale, width;
      width = this.gwidth - this.bar_width - this.text_width;
      height = this.gheight;
      min = Math.min(width, height) / 2;
      radius = min * 0.8;
      inner_radius = radius * 0.4;
      pie = d3.pie().value(1);
      max_amount = d3.max(this.data.map(function(d) {
        return d.balance_amount;
      }));
      scale = d3.scaleSqrt().domain([0, max_amount]).range([inner_radius, radius]);
      g = this.arc_panel.selectAll('.arc').data(pie(this.data)).enter().append('g').attr('class', 'arc');
      arc = d3.arc().outerRadius(function(d) {
        return scale(d.data.balance_amount);
      }).innerRadius(inner_radius);
      color = d3.scaleLinear().domain([0, this.data.length - 1]).range([COLOR_BALANCE, COLOR_BALANCE_DEEP]);
      path = g.append('path').attr('d', arc).attr('fill', function(d, idx) {
        return color(idx);
      }).attr('stroke', BG_COLOR).attr('stroke-width', 1);
      return this.rotate_pie(path);
    };

    BalanceAmountPie.prototype.draw_bar = function() {
      var bar_width, color, data, height, max, width, xscale, yscale;
      width = this.bar_width;
      height = this.data.length * 32;
      data = this.data;
      max = d3.max(data.map(function(d) {
        return d.balance_amount;
      }));
      xscale = d3.scaleLinear().domain([0, max]).range([0, width]);
      yscale = d3.scaleBand().domain(data.map(function(d) {
        return d.name;
      })).range([0, height]).paddingInner(0.2).paddingOuter(0.2);
      bar_width = yscale.bandwidth();
      color = d3.scaleLinear().domain([0, this.data.length - 1]).range([COLOR_BALANCE, COLOR_BALANCE_DEEP]);
      this.bar_panel.selectAll('.bar').data(data).enter().append('rect').attr('class', 'bar').attr('height', bar_width).attr('width', function(d) {
        return xscale(d.balance_amount);
      }).attr('fill', function(d, idx) {
        return color(idx);
      }).attr('transform', function(d) {
        return "translate(0, " + (yscale(d.name)) + ")";
      });
      return this.axis_panel.call(d3.axisLeft(yscale));
    };

    return BalanceAmountPie;

  })(DrawTitle);

}).call(this);

(function() {
  var ChinaMap,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.ChinaMap = ChinaMap = (function(superClass) {
    extend(ChinaMap, superClass);

    function ChinaMap($elm, georoot) {
      this.$elm = $elm;
      this.georoot = georoot;
      this.bar_width = 125;
      this.text_width = 100;
      this.bar_top_off = 40;
      this.bar_label_height = 16;
      this.duration = 6000;
      this.amount_rand = d3.randomUniform(100, 200);
      this.order_rand = d3.randomUniform(50, 300);
    }

    ChinaMap.prototype.draw = function() {
      this.draw_svg();
      this.draw_title();
      this.draw_gpanel();
      this._d();
      return setInterval((function(_this) {
        return function() {
          return _this._d();
        };
      })(this), this.duration);
    };

    ChinaMap.prototype._d = function() {
      if (this.bar_panel) {
        this.bar_panel.remove();
      }
      this.bar_panel = this.gpanel.append('g').attr('transform', "translate(" + this.text_width + ", " + this.bar_top_off + ")");
      if (this.axis_panel) {
        this.axis_panel.remove();
      }
      this.axis_panel = this.gpanel.append('g').attr('class', 'axis').attr('transform', "translate(" + this.text_width + ", " + (this.bar_top_off + this.bar_label_height) + ")");
      if (this.china) {
        this.china.remove();
      }
      this.china = d3.select(this.$elm[0]).append('svg').attr('class', 'china-map').attr('width', this.gwidth - this.bar_width - this.text_width).attr('height', this.gheight);
      this.rand_data();
      this.draw_bar();
      return this.draw_map();
    };

    ChinaMap.prototype.rand_data = function() {
      this.data = this.georoot.features.map((function(_this) {
        return function(d) {
          var amount, lack, order;
          amount = _this.amount_rand();
          order = _this.order_rand();
          lack = order - amount;
          return Object.assign({
            amount: amount,
            order: order,
            lack: lack
          }, d);
        };
      })(this));
      this.data = this.data.sort(function(a, b) {
        return b.lack - a.lack;
      });
      this.lack_max = d3.max(this.data.map(function(d) {
        return d.lack;
      }));
      return this.color_gen = d3.scaleLinear().domain([0, this.lack_max]).range([GOOD_COLOR, BAD_COLOR]);
    };

    ChinaMap.prototype.draw_bar = function() {
      var bar_width, data, height, width, xscale, yscale;
      width = this.bar_width;
      data = this.data.filter(function(d) {
        return d.lack > 0;
      });
      data = data.slice(0, 11);
      height = data.length * 32;
      xscale = d3.scaleLinear().domain([0, this.lack_max]).range([0, width]);
      yscale = d3.scaleBand().domain(data.map(function(d) {
        return d.properties.name;
      })).range([0, height]).paddingInner(0.2).paddingOuter(0.2);
      bar_width = yscale.bandwidth();
      this.bar_panel.append('text').style('fill', 'white').text('缺货预警');
      this.bar_panel.selectAll('.bar').data(data).enter().append('rect').attr('class', 'bar').attr('height', bar_width).attr('width', function(d) {
        return 0;
      }).attr('fill', (function(_this) {
        return function(d) {
          return _this.color_gen(d.lack);
        };
      })(this)).attr('transform', (function(_this) {
        return function(d) {
          return "translate(0, " + (yscale(d.properties.name) + _this.bar_label_height) + ")";
        };
      })(this)).transition().duration(this.duration / 2).attr('width', function(d) {
        return xscale(d.lack);
      });
      return this.axis_panel.call(d3.axisLeft(yscale));
    };

    ChinaMap.prototype.draw_map = function() {
      var data, data1, height, path, points, projection, provinces, scale, width;
      width = this.gwidth - this.bar_width - this.text_width;
      height = this.gheight;
      data = this.data.map(function(d, idx) {
        d.lack1 = 0;
        if (idx < 10) {
          d.lack1 = d.lack;
        }
        return d;
      });
      projection = d3.geoMercator().center([104, 38]).scale(width * 0.9).translate([width / 2, height / 2]);
      path = d3.geoPath(projection);
      scale = d3.scaleSqrt().domain([0, this.lack_max]).range([0, 30]);
      provinces = this.china.selectAll('.province').data(data).enter().append('path').attr('class', 'province').style('fill', (function(_this) {
        return function(d) {
          return 'transparent';
        };
      })(this)).style('stroke', COLOR_IN).style('stroke-width', 3).attr('d', path);
      data1 = data.filter(function(x) {
        return x.lack1 > 0;
      });
      data1 = data1.map(function(d) {
        d.centroid = path.centroid(d);
        return d;
      });
      return points = this.china.selectAll('.point').data(data1).enter().append('circle').attr('class', 'point').style('fill', BAD_COLOR).style('opacity', '0.7').attr('cx', function(d) {
        return d.centroid[0];
      }).attr('cy', function(d) {
        return d.centroid[1];
      }).attr('r', 0).transition().duration(this.duration / 2).attr('r', function(d) {
        return scale(d.lack1);
      });
    };

    return ChinaMap;

  })(DrawTitle);

}).call(this);

(function() {
  var TS, TotalStat, TotalStat1, TotalStat2,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  TS = (function(superClass) {
    extend(TS, superClass);

    function TS($elm) {
      this.$elm = $elm;
    }

    TS.prototype._draw = function(id) {
      var diameter, min;
      this.draw_svg();
      this.draw_title();
      this.draw_gpanel();
      min = d3.min([this.gwidth, this.gheight]);
      diameter = min * 0.7;
      return d3.select(this.$elm[0]).append('svg').attr('id', id).attr('width', diameter).attr('height', diameter).style('position', 'absolute').style('left', ((this.gwidth - diameter) / 2) + "px").style('bottom', ((this.gheight - diameter) / 2 + 10) + "px");
    };

    return TS;

  })(DrawTitle);

  window.TotalStat = TotalStat = (function(superClass) {
    extend(TotalStat, superClass);

    function TotalStat() {
      return TotalStat.__super__.constructor.apply(this, arguments);
    }

    TotalStat.prototype.draw = function() {
      var config, gauge;
      this._draw('fillgauge1');
      config = liquidFillGaugeDefaultSettings();
      config.circleColor = '#CDFF41';
      config.waveColor = '#E3FF95';
      config.textColor = "#FFFFFF";
      config.waveTextColor = BG_COLOR;
      config.circleThickness = 0.2;
      config.waveAnimateTime = 1000;
      config.waveCount = 3;
      config.waveHeight = 0.1;
      gauge = loadLiquidFillGauge("fillgauge1", 15, config);
      return setInterval(function() {
        return gauge.update(Math.round(d3.randomUniform(5, 20)()));
      }, 5000);
    };

    return TotalStat;

  })(TS);

  window.TotalStat1 = TotalStat1 = (function(superClass) {
    extend(TotalStat1, superClass);

    function TotalStat1() {
      return TotalStat1.__super__.constructor.apply(this, arguments);
    }

    TotalStat1.prototype.draw = function() {
      var config, gauge;
      this._draw('fillgauge2');
      config = liquidFillGaugeDefaultSettings();
      config.circleColor = '#FFC141';
      config.waveColor = '#FFDD95';
      config.textColor = "#FFFFFF";
      config.waveTextColor = BG_COLOR;
      config.circleThickness = 0.2;
      config.waveAnimateTime = 1000;
      config.waveCount = 3;
      config.waveHeight = 0.1;
      gauge = loadLiquidFillGauge("fillgauge2", 30, config);
      return setInterval(function() {
        return gauge.update(Math.round(d3.randomUniform(10, 35)()));
      }, 5000);
    };

    return TotalStat1;

  })(TS);

  window.TotalStat2 = TotalStat2 = (function(superClass) {
    extend(TotalStat2, superClass);

    function TotalStat2() {
      return TotalStat2.__super__.constructor.apply(this, arguments);
    }

    TotalStat2.prototype.draw = function() {
      var config, gauge;
      this._draw('fillgauge3');
      config = liquidFillGaugeDefaultSettings();
      config.circleColor = COLOR_OUT;
      config.waveColor = COLOR_IN;
      config.textColor = "#FFFFFF";
      config.waveTextColor = BG_COLOR;
      config.circleThickness = 0.2;
      config.waveAnimateTime = 1000;
      config.waveCount = 3;
      config.waveHeight = 0.1;
      gauge = loadLiquidFillGauge("fillgauge3", 87, config);
      return setInterval(function() {
        return gauge.update(Math.round(d3.randomUniform(70, 90)()));
      }, 5000);
    };

    return TotalStat2;

  })(TS);

}).call(this);

(function() {
  var fn1, fn2, fn3, fn4;

  jQuery(function() {
    var h, w;
    w = jQuery('.paper').width() / 24;
    h = jQuery('.paper').height() / 24;
    jQuery('.g').each(function(idx, g) {
      var $g, pos;
      $g = jQuery(g);
      if (pos = $g.data('pos')) {
        return $g.css({
          left: pos[0] * w,
          top: pos[1] * h,
          width: pos[2] * w,
          height: pos[3] * h
        });
      }
    });
    fn1();
    fn2();
    fn3();
    return fn4();
  });

  fn1 = function() {
    return d3.json('data/StockRecord.json?1', function(error, _data) {
      var data, now;
      now = new Date().getTime();
      data = _data.map(function(d, idx) {
        var date;
        date = new Date(now + idx * 86400000);
        return Object.assign({
          date: format_date(date, "MM-dd")
        }, d);
      });
      new AmountBar(jQuery('.g7'), data).draw();
      new AmountBar2(jQuery('.g3'), data).draw();
      return new AmountPie(jQuery('.g6'), data).draw();
    });
  };

  fn2 = function() {
    return d3.json('data/MaterialBalanceAmount.json?1', function(error, _data) {
      var data;
      data = _data.sort(function(a, b) {
        return b.balance_amount - a.balance_amount;
      });
      return new BalanceAmountPie(jQuery('.g5'), data).draw();
    });
  };

  fn3 = function() {
    return d3.json('data/china.json?1', function(error, root) {
      var georoot;
      georoot = root;
      return new ChinaMap(jQuery('.g8'), georoot).draw();
    });
  };

  fn4 = function() {
    new TotalStat(jQuery('.g11')).draw();
    new TotalStat1(jQuery('.g12')).draw();
    return new TotalStat2(jQuery('.g13')).draw();
  };

}).call(this);
