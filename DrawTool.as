// Draw functions
var drawStart:Function = function () {
  delete(this.polygon);
  this.polygon = new Array();
  
  if (_root.ActiveTool)
    return;
  
  if (_root.ActiveLayer != this)
    return;
  
  if (!_root.Mask.hitTest(_xmouse,_ymouse,false))
    return;
  
  this.lineWidth = (_root.lineWidth > 0) ? _root.lineWidth : 1;
  this.lineColor = _root.lineColor;
  this.lineAlpha = (_root.lineAlpha > 0) ? _root.lineAlpha : 1;
  
  this.lineStyle(this.lineWidth,this.lineColor,this.lineAlpha,false,"normal","none");
  
  this.onEnterFrame = draw;
}

var draw:Function = function (_status:String) {
  var point:Object = {x:this._xmouse,y:this._ymouse};
  
  if (this.polygon.length)
  {
    var check = this.polygon[this.polygon.length-1];
    if ((check.x == point.x) && (check.y == point.y))
      return;
    
    this.lineTo(point.x,point.y);
  }
  else
    this.moveTo(point.x,point.y);
  
  this.polygon.push(point);
  
}

var drawStop:Function = function () {
  if (this.polygon.length > 1)
    this.polygons.push({width:this.lineWidth,color:this.lineColor,alpha:this.lineAlpha,polygon:this.polygon});
  
  delete(this.polygon);
  this.onEnterFrame = function () {};
}

var drawUndo:Function = function () { // UNDO CANNOT BE UNDONE!!
  this.polygons.pop();
  this.clear();
  var origin:Boolean;
  
  for (var n in this.polygons) {
    this.polygon = this.polygons[n].polygon;
    this.lineStyle(this.polygons[n].width,this.polygons[n].color,this.polygons[n].alpha,false,"normal","none");
    
    origin = false;
    
    for (var p in this.polygon)
    {
      if (origin)
        this.lineTo(this.polygon[p].x,this.polygon[p].y);
      else
      {
        this.moveTo(this.polygon[p].x,this.polygon[p].y);
        origin = true;
      }
    }
  }
}

var initDrawSurface:Function = function (surface:MovieClip) {
  surface.drawUndo = _root.drawUndo;
  surface.onMouseDown = _root.drawStart;
  surface.onMouseUp = _root.drawStop;
  
  surface.polygon = new Array();
  surface.polygons = new Array();
  
  surface.lineWidth = new Number();
  surface.lineColor = new Number();
  surface.lineAlpha = new Number();
}