d3.custom = {};

d3.custom.barChart = function module(options) {

  options = options || {};

  var marginDefault = { top: 10, right: 40, bottom: 55, left: 80, padding: 10 };
  var margin  = options.margin || marginDefault,
  width       = options.width || 960,
  height      = options.height || 500,
  gap         = options.gap || 0,
  ease        = options.ease || 'cubic-in-out',
  ylabel      = options.ylabel,
  textPadding = 13,
  format      = d3.format('.0f');

  var svg, duration = 500;
  var dispatch      = d3.dispatch('customHover');

  function exports(selection) {
    selection.each(function(data) {

      var chartW = width - margin.left - margin.right,
          chartH = height - margin.top - margin.bottom;

      var x1 = d3.scale.ordinal()
        .domain(data.map(function(d, i) { return d.x; }))
        .rangeRoundBands([0, chartW], .1);

      var y1 = d3.scale.linear()
        .domain([0, d3.max(data, function(d, i) { return d.y; })])
        .range([chartH, 0]);

      var xAxis = d3.svg.axis()
        .scale(x1)
        .orient('bottom');

      var yAxis = d3.svg.axis()
        .scale(y1)
        .tickFormat(function(d) { return '£' + format(d); })
        .tickSize(-chartW)
        .orient('left');

      var barW = chartW / data.length;

      if (!svg) {
        svg = d3.select(this)
          .append('svg')
          .classed('chart', 1);
        var container  = svg.append('g').classed('container-group', 1);
        var chartGroup = container.append('g').classed('chart-group', 1);
        chartGroup.append('g').classed('x-axis-group axis', 1);
        chartGroup.append('g').classed('y-axis-group axis', 1);
        // svg.append('text')
        //   .classed('chart-title', 1)
        //   .style('font-size', '22px')
        //   .text('Title');
        svg.append('text')
          .classed('x-axis-title', 1)
          .attr('text-anchor', 'middle')
          .text('Month of ' + moment().utc().format("MMMM"));
        svg.append('text')
          .classed('y-axis-title', 1)
          .attr('text-anchor', 'end')
          .attr('transform', 'rotate(-90)')
          .text(ylabel);
      }

      svg.transition().duration(duration).attr({width: width, height: height});
      svg.select('.container-group')
        .attr({transform: 'translate(' + margin.left + ',' + margin.top + ')'});

      svg.select('.chart-title').transition()
        .duration(duration)
        .ease(ease)
        .attr('x', chartW / 2)
        .attr('y', 0 - (margin.top / 2));

      svg.select('.x-axis-title').transition()
        .duration(duration)
        .ease(ease)
        .attr('x', (chartW) / 2)
        .attr('dx', margin.left)
        .attr('y', chartH + margin.bottom)
        .attr('dy', -2);

      svg.select('.y-axis-title').transition()
        .duration(duration)
        .ease(ease)
        .attr('x', -(chartH + margin.top - margin.bottom) / 2)
        .attr('y', 12)
        .attr('dy', '.8em');

      var gapSize = x1.rangeBand() / 100 * gap;
      var barW    = x1.rangeBand() - gapSize;

      var bars = svg.select('.chart-group')
        .selectAll('.bar')
        .data(data);

      var barLabels = svg.select('.chart-group')
        .selectAll('.bar-label')
        .data(data);

      bars.enter().append('rect')
      .classed('bar', 1)
      .attr({
        x: chartW,
        width: barW,
        y: chartH,
        height: 0
      })
      .on('mouseover', dispatch.customHover);

      bars.transition()
        .duration(duration)
        .ease(ease)
        .attr({
          width: barW,
          x: function(d, i) { return x1(d.x) + gapSize / 2 - .5; },
          y: function(d, i) { return y1(d.y) + .5; },
          height: function(d, i) { return chartH - y1(d.y); }
        });

      barLabels.enter().append('text')
        .classed('bar-label', 1)
        .attr({
          x: function(d) { return x1(d.x) + barW / 2 - .5; },
          y: function(d) { return y1(d.y) - .5; },
          dx: '.35em',
          dy: 15,
          'text-anchor': 'middle'
        })
        .text(function(d) {
          if (chartH - y1(d.y) > 30) return '£' + format(d.y);
        });

      barLabels.transition()
        .duration(duration)
        .ease(ease)
        .attr({
          x: function(d) { return x1(d.x) + barW / 2 - .5; },
          y: function(d) { return y1(d.y) + 3.5; },
          dx: '-0.05em',
          dy: function(d) { return barW / 5.1; }
        })
        .style('font-size', (barW / 6) + 'px')
        .text(function(d) {
          if (chartH - y1(d.y) > 30) return '£' + format(d.y);
        });

      bars.exit().transition().style({opacity: 0}).remove();
      barLabels.exit().transition().style({opacity: 0}).remove();
      duration = 500;

      svg.select('.chart-group').select('.x-axis-group.axis')
        .transition()
        .duration(duration)
        .ease(ease)
        .attr({transform: 'translate(0,' + (chartH) + ')'})
        .call(xAxis);

      svg.select('.chart-group').select('.y-axis-group.axis')
        .text("Revenue")
        .transition()
        .duration(duration)
        .ease(ease)
        .call(yAxis);
    });
  }

  exports.width = function(x) {
    if (!arguments.length) return width;
    width = parseInt(x);
    return this;
  };

  exports.height = function(x) {
    if (!arguments.length) return height;
    height = parseInt(x);
    duration = 0;
    return this;
  };

  exports.gap = function(x) {
    if (!arguments.length) return gap;
    gap = x;
    return this;
  };

  exports.ease = function(x) {
    if (!arguments.length) return ease;
    ease = x;
    return this;
  };

  d3.rebind(exports, dispatch, 'on');
  return exports;
};