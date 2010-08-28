//Move function
var moveStart:Function = function () {
  _root.ToolPad.onMouseDown = movePress;
  _root.ToolPad.onMouseUp = moveRelease;
  _root.ToolPad['mover'].onEnterFrame = function () {
    this._x = this._parent._xmouse;
    this._y = this._parent._ymouse;
  }
}

//onMouseDown
var movePress:Function = function () {
  startDrag(_root.ActiveLayer);
}

//onMouseUp
var moveRelease:Function = function () {
  stopDrag();
}

var moveStop:Function = function () {
  stopDrag();
  _root.ToolPad.onMouseDown = {};
  _root.ToolPad.onMouseUp = {};
  _root.ToolPad['mover'].onEnterFrame = {};
}

var moveToggle:Function = function () {
  if (_root.ActiveTool == "move")
    moveStop();
  else
    moveStart();
}

function moveCurrentItem (x:Number, y:Number) {
  if (!_root.ActiveLayer)
    return;
  
  _root.ActiveLayer._x = x;
  _root.ActiveLayer._y = y;
}