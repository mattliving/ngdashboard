// Chart design based on the recommendations of Stephen Few. Implementation
// based on the work of Clint Ivy, Jamie Love, and Jason Davies.
// http://projects.instantcognition.com/protovis/bulletchart/
d3.custom.bulletChart = function(options) {

    options = options || {};

    var marginDefault = { top: 10, right: 40, bottom: 50, left: 40, padding: 10 };
    var margin = options.margin || marginDefault,
    width      = options.width || 960,
    height     = options.height || 500,
    ease       = options.ease || 'cubic-in-out',
    orient     = "left",
    reverse    = false,
    duration   = 500,
    ranges     = bulletRanges,
    markers    = bulletMarkers,
    measures   = bulletMeasures,
    tickFormat = null;

    var svg, bulletContainer, titleContainer;

    // For each small multiple…
    function bullet(g) {
        g.each(function(d, i) {

            margin.top    = 0;
            margin.bottom = height * 0.3;
            margin.left   = width * 0.03;
            margin.right  = width * 0.03;

            var chartW = width - margin.left - margin.right,
                chartH = height - margin.top - margin.bottom;

            if (!svg) {
                svg = d3.select(this).append("svg")
                    .classed("bullet", 1);
                bulletContainer = svg.append("g").classed("bullet-container", 1);

                titleContainer = svg.append("g")
                    .classed("title-container", 1)
                    .attr("transform", "translate(-6," + chartH / 4 + ")");

                titleContainer.append("text")
                    .classed("title", 1)
                    .attr("text-anchor", "end")
                    .attr('transform', 'rotate(-90)')
                    .text(bulletTitle(d));

                titleContainer.append("text")
                    .classed("subtitle", 1)
                    .attr("text-anchor", "end")
                    .attr('transform', 'rotate(-90)')
                    .text(bulletSubTitle(d));
            }

            svg.transition().duration(duration).attr({width: width, height: height});
            svg.select('.bullet-container')
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

            svg.select('.title-container').transition()
                .duration(duration)
                .ease(ease)
                .attr("transform", "translate(-6," + chartH / 4 + ")");

            titleContainer.select(".title").transition()
                .text(bulletTitle(d))
                .duration(duration)
                .ease(ease)
                .attr('x', function() { return -(chartH) / 8; })
                .attr('y', 14)
                .attr('dy', '1em');

            titleContainer.select(".subtitle").transition()
                .text(bulletSubTitle(d))
                .duration(duration)
                .ease(ease)
                .attr('x', function() { return -(chartH) / 8 + 24; })
                .attr('y', 14)
                .attr('dy', '1.15em');

            var measureValues = {
                previous: d.previous,
                value: d.value
            }
            var rangez   = ranges.call(this, d, i).slice().sort(d3.descending),
                markerz  = markers.call(this, d, i).slice().sort(d3.descending),
                measurez = measures.call(this, d, i).slice().sort(d3.descending);

            // Compute the new x-scale.
            var x1 = d3.scale.linear()
                .domain([0, Math.max(rangez[0], markerz[0], measurez[0])])
                .range(reverse ? [chartW, 0] : [0, chartW]);

            // Retrieve the old x-scale, if this is an update.
            var x0 = this.__chart__ || d3.scale.linear()
                .domain([0, Infinity])
                .range(x1.range());

            // Stash the new scale.
            this.__chart__ = x1;

            // Derive width-scales from the x-scales.
            var w0 = bulletWidth(x0),
                w1 = bulletWidth(x1);

            // Update the range rects.
            var range = bulletContainer.selectAll("rect.range")
                .data(rangez);

            range.enter().append("rect")
                .attr("class", function(d, i) { return "range s" + i; })
                .attr("width", w0)
                .attr("height", chartH)
                .attr("x", reverse ? x0 : 0)
            .transition()
                .duration(duration)
                .attr("width", w1)
                .attr("x", reverse ? x1 : 0);

            range.transition()
                .duration(duration)
                .attr("x", reverse ? x1 : 0)
                .attr("width", w1)
                .attr("height", chartH);

            // Update the measure rects.
            var measure = bulletContainer.selectAll("rect.measure")
                .data(measurez);

            measure.enter().append("rect")
                .attr("class", function(d, i) {
                    if (d === measureValues.previous) {
                        // console.log(d, measureValues.previous);
                        return "measure previous s" + i;
                    }
                    else {
                        // console.log(d, measureValues.value);
                        return "measure value s" + i;
                    }
                })
                .attr("width", w0)
                .attr("height", chartH / 3)
                .attr("x", reverse ? x0 : 0)
                .attr("y", chartH / 3)
            .transition()
                .duration(duration)
                .attr("width", w1)
                .attr("x", reverse ? x1 : 0);

            measure.transition()
                .duration(duration)
                .attr("width", w1)
                .attr("height", chartH / 3)
                .attr("x", reverse ? x1 : 0)
                .attr("y", chartH / 3);

            // Update the marker lines.
            var marker = bulletContainer.selectAll("line.marker")
                .data(markerz);

            marker.enter().append("line")
                .attr("class", "marker")
                .attr("x1", x0)
                .attr("x2", x0)
                .attr("y1", chartH / 6)
                .attr("y2", chartH * 5 / 6)
            .transition()
                .duration(duration)
                .attr("x1", x1)
                .attr("x2", x1);

            marker.transition()
                .duration(duration)
                .attr("x1", x1)
                .attr("x2", x1)
                .attr("y1", chartH / 6)
                .attr("y2", chartH * 5 / 6);

            // Compute the tick format.
            var format = tickFormat || x1.tickFormat(8);

            // Update the tick groups.
            var tick = bulletContainer.selectAll("g.tick")
                .data(x1.ticks(8), function(d) {
                    return this.textContent || format(d);
                });

            // Initialize the ticks with the old scale, x0.
            var tickEnter = tick.enter().append("g")
                .attr("class", "tick")
                .attr("transform", bulletTranslate(x0))
                .style("opacity", 1e-6);

            tickEnter.append("line")
                .attr("y1", chartH)
                .attr("y2", chartH * 7 / 6);

            tickEnter.append("text")
                .attr("text-anchor", "middle")
                .attr("dy", "1em")
                .attr("y", chartH * 7 / 6)
                .text(format);

            // Transition the entering ticks to the new scale, x1.
            tickEnter.transition()
                .duration(duration)
                .attr("transform", bulletTranslate(x1))
                .style("opacity", 1);

            // Transition the updating ticks to the new scale, x1.
            var tickUpdate = tick.transition()
                .duration(duration)
                .attr("transform", bulletTranslate(x1))
                .style("opacity", 1);

            tickUpdate.select("line")
                .attr("y1", chartH)
                .attr("y2", chartH * 7 / 6);

            tickUpdate.select("text")
                .attr("y", chartH * 7 / 6);

            // Transition the exiting ticks to the new scale, x1.
            tick.exit().transition()
                .duration(duration)
                .attr("transform", bulletTranslate(x1))
                .style("opacity", 1e-6)
                .remove();
        });
        d3.timer.flush();
    }

    // left, right, top, bottom
    bullet.orient = function(x) {
        if (!arguments.length) return orient;
        orient  = x;
        reverse = orient == "right" || orient == "bottom";
        return this;
    };

    // ranges (bad, satisfactory, good)
    bullet.ranges = function(x) {
        if (!arguments.length) return ranges;
        ranges = x;
        return this;
    };

    // markers (previous, goal)
    bullet.markers = function(x) {
        if (!arguments.length) return markers;
        markers = x;
        return this;
    };

    // measures (actual, forecast)
    bullet.measures = function(x) {
        if (!arguments.length) return measures;
        measures = x;
        return this;
    };

    bullet.width = function(x) {
        if (!arguments.length) return width;
        width = parseInt(x);
        return this;
    };

    bullet.height = function(x) {
        if (!arguments.length) return height;
        height = parseInt(x);
        return this;
    };

    bullet.tickFormat = function(x) {
        if (!arguments.length) return tickFormat;
        tickFormat = x;
        return this;
    };

    bullet.duration = function(x) {
        if (!arguments.length) return duration;
        duration = x;
        return this;
    };

    return bullet;
};

function bulletTitle(d) {
    return (!_.isNull(d) && !_.isUndefined(d.title)) ? d.title : "";
}

function bulletSubTitle(d) {
    return (!_.isNull(d) && !_.isUndefined(d.subtitle)) ? ('(' + d.subtitle + ')') : "";
}

function bulletRanges(d) {
    return (!_.isNull(d) && !_.isUndefined(d.ranges)) ? d.ranges : [];
}

function bulletMarkers(d) {
    return (!_.isNull(d) && !_.isUndefined(d.markers)) ? d.markers : [];
}

function bulletMeasures(d) {
    return (!_.isNull(d) && !_.isUndefined(d.measures)) ? d.measures : [];
}

function bulletTranslate(x) {
    return function(d) {
        return "translate(" + x(d) + ",0)";
    };
}

function bulletWidth(x) {
    var x0 = x(0);
    return function(d) {
        return Math.abs(x(d) - x0);
    };
}