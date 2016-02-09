"use strict";

function dateConvert(date) {
  return date.replace(/[TZ]/g, " ").trimRight();
}

var ZoomInProgress = false;

class PlotList {
  constructor() {
    this._plots = {};
  }

  timeSeries(divName) {
    var plot = new TimeSeriesPlot(divName);
    this._plots[divName] = plot;
    return plot;
  }

  allExcept(divName) {
    var set = [];
    for (var id in this._plots) {
      if (id != divName) {
        set.push(this._plots[id]);
      }
    }
    return set;
  }
}

class TimeSeriesPlot {
  constructor(divName) {
    this._divName = divName;
    this._divObj = document.getElementById(divName)
    this._series = {};
    this._yaxes = [];
    this._axisCount = 1;
  }

  registerPlot(key, data) {
    this._series[key] = data;
    this._series[key].x = [];
    this._series[key].y = [];
    return this._series[key];
  }

  contains(key) {
    return key in this._series;
  }

  addPoint(key, x, y) {
    this._series[key].x.push(x);
    this._series[key].y.push(y);
  }

  get array() {
    var ret = [];
    for (var key in this._series) {
      ret.push(this._series[key]);
    }
    return ret;
  }

  loadResponse(obj) {
    for (var key in obj) {
      var observation = obj[key];
      var dateString = dateConvert(obj[key]['date']);

      for (var stat in observation) {
        if (this.contains(stat)) {
          this.addPoint(stat, dateString, observation[stat]);
        }
      }
    }
  }

  createYAxis() {
    var axis = new Axis(this, this._axisCount);
    this._axisCount += 1;
    this._yaxes.push(axis);
    return axis;
  }

  plot(layout) {
    if (layout === undefined) {
      layout = {};
    }
    var divObj = this._divObj;

    for(var i in this._yaxes) {
      var axis = this._yaxes[i];
      layout[axis.layoutYAxisName] = axis.layout;
    }

    console.log(this.array, layout);
    return Plotly.plot(divObj, this.array, layout );
  }
}

class Axis {
  constructor(parentPlot, id) {
    this._parentPlot = parentPlot;
    this._axisId = id;
  }

  get layoutYAxisName() {
    if (this._axisId > 1)
      return 'yaxis'+this._axisId;
    return 'yaxis';
  }

  get dataYAxisName() {
    if (this._axisId > 1) {
      return "y"+this._axisId;
    }
    return "y";
  }

  get axisId() {
    return this._axisId;
  }

  get layout() {
    var count = this._parentPlot._yaxes.length;
    var fraction = (1/count);
    return {
      "anchor": "x",
      "domain": [ fraction * (count-this._axisId), fraction * (count-this._axisId+1) ],
      "zeroline": false
    };
  }

  registerPlot(key, data) {
    data['xaxis'] = "x";
    data['yaxis'] = this.dataYAxisName;
    return this._parentPlot.registerPlot(key, data);
  }

}
