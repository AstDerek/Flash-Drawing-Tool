TextField.prototype.hitTest = MovieClip.prototype.hitTest;


// Font Functions
var writeStart:Function = function () {
  if (_root.ActiveTool)
    return;
  
  if (_root.ActiveLayer != this)
    return;
  
  this.type = "input";
  this.border = true;
  this.selectable = true;
}

var writeStop:Function = function () {
  this.type = "dynamic";
  this.border = false;
  this.selectable = false;
}

var setFontName:Function = function (fontName:String) {
  var format:TextFormat = new TextFormat();
  format.font = fontName;
  this.setTextFormat(format);
}

var setFontColor:Function = function (fontColor:Number) {
  var format:TextFormat = new TextFormat();
  format.color = fontColor;
  this.setTextFormat(format);
}

var setFontSize:Function = function (fontSize:Number) {
  var format:TextFormat = new TextFormat();
  format.size = fontSize;
  this.setTextFormat(format);
}

var initFontSurface:Function = function (surface:MovieClip) {
  surface.writeStart = _root.writeStart;
  surface.writeStop = _root.writeStop;
  surface.setFontName = _root.setFontName;
  surface.setFontColor = _root.setFontColor;
  surface.setFontSize = _root.setFontSize;
  surface.text = "new text";
  //surface.type = "input";
  //surface.border = true;
  surface.type = "dynamic";
  surface.selectable = false;
  surface.border = false;
  surface.multiline = true;
  surface.wordWrap = true;
  surface.embedFonts = true;
  
  surface.setFontName(_root.fontName);
  surface.setFontSize(_root.fontSize);
  surface.setFontColor(_root.fontColor);
  
  surface.onMouseDown = function ()
  {
    if (!this.hitTest(_xmouse,_ymouse,false))
      this.writeStop();
    else
      this.writeStart();
  }

  Mouse.addListener(surface);
}