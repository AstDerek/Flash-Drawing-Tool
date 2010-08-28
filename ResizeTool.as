// Resize functions
var resizeStart:Function = function () {
  startDrag(this);
  this.onEnterFrame = _root.resize;
}

var resize:Function = function () {
  var width:Number = this._x - _root.ActiveLayer._x;
  var height:Number = this._y - _root.ActiveLayer._y;
  var nwidth:Number;
  var nheight:Number;
  var xdiff:Number;
  var ydiff:Number;
  var rad:Number = -(_root.ActiveLayer._rotation*Math.PI)/180;
  
  nwidth = width*Math.cos(rad) - height*Math.sin(rad);
  nheight = width*Math.sin(rad) + height*Math.cos(rad);
  
  if (_root.ActiveTool == "resize") {
    _root.ActiveLayer._width = nwidth;
    _root.ActiveLayer._height = nheight;
  }
  else {
    _root.ActiveLayer._xscale = 100;
    _root.ActiveLayer._yscale = 100;
    width = _root.ActiveLayer._width;
    height = _root.ActiveLayer._height;
    _root.ActiveLayer._xscale = (100*nwidth)/width;
    _root.ActiveLayer._yscale = (100*nheight)/height;
  }
  
  this.square._width = nwidth;
  this.square._height = nheight;
  
  this._rotation = _root.ActiveLayer._rotation;
}

var resizeStop:Function = function () {
  stopDrag();
  this.onEnterFrame = {};
}

// Resize functions
var rescale:Function = function () {
  var width:Number = this._x - _root.ActiveLayer._x;
  var height:Number = this._y - _root.ActiveLayer._y;
  var nwidth:Number;
  var nheight:Number;
  var xdiff:Number;
  var ydiff:Number;
  var rad:Number = -(_root.ActiveLayer._rotation*Math.PI)/180;
  
  nwidth = width*Math.cos(rad) - height*Math.sin(rad);
  nheight = width*Math.sin(rad) + height*Math.cos(rad);
  
  _root.ActiveLayer._xscale = (100*nwidth)/width;
  _root.ActiveLayer._yscale = (100*nheight)/height;
  
  this.square._width = nwidth;
  this.square._height = nheight;
  
  this._rotation = _root.ActiveLayer._rotation;
}

var moveToCorner:Function = function () {
  var rot:Number = _root.ActiveLayer._rotation;
  var rad:Number = (rot*Math.PI)/180;
  
  _root.ActiveLayer._rotation = 0;
  
  var width:Number = _root.ActiveLayer._width;
  var height:Number = _root.ActiveLayer._height;
  var nwidth:Number;
  var nheight:Number;
  
  
  nwidth = width*Math.cos(rad) - height*Math.sin(rad);
  nheight = width*Math.sin(rad) + height*Math.cos(rad);
  
  this._x = _root.ActiveLayer._x + nwidth;
  this._y = _root.ActiveLayer._y + nheight;
  
  this.square._width = _root.ActiveLayer._width;
  this.square._height = _root.ActiveLayer._height;
  
  _root.ActiveLayer._rotation = rot;
  this._rotation = _root.ActiveLayer._rotation;
}

function rescaleCurrentItem (xscale:Number,yscale:Number) {
  if (!_root.ActiveLayer)
    return;
  
  _root.ActiveLayer._xscale = xscale;
  _root.ActiveLayer._yscale = yscale;
}