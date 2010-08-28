// Rotate functions
var rotateStart:Function = function () {
  startDrag(this);
  this.onEnterFrame = _root.rotate;
}

var rotate:Function = function () {
  var rot:Number = _root.ActiveLayer._rotation;
  _root.ActiveLayer._rotation = 0;
  var origin:Number = Math.atan2(_root.ActiveLayer._height,_root.ActiveLayer._width);
  var rad:Number = Math.atan2(this._y-_root.ActiveLayer._y,this._x-_root.ActiveLayer._x);
  
  _root.ActiveLayer._rotation = ((rad-origin)*180)/Math.PI;
  this._rotation = _root.ActiveLayer._rotation;
}

var rotateStop:Function = function () {
  stopDrag();
  this.onEnterFrame = {};
  this.moveToCorner();
}

function rotateCurrentItem (angle:Number) {
  if (!_root.ActiveLayer)
    return;
  
  _root.ActiveLayer._rotation = angle;
}