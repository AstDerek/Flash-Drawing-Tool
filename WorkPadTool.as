function addComponent (kind:String,path:String) {
  var depth:Number = _root.WorkPad.getNextHighestDepth();
  var listener:Object;
  
  switch (kind) {
    case "text":
      _root.WorkPad.createTextField('_'+depth,depth,0,0,100,30);
      _root.initFontSurface(_root.WorkPad['_'+depth]);
      break;
    case "draw":
    default:
      _root.WorkPad.createEmptyMovieClip('_'+depth,depth);
      _root.initDrawSurface(_root.WorkPad['_'+depth]);
      break;
    case "image":
      if (!path)
        return;
      
      _root.WorkPad.createEmptyMovieClip('_'+depth,depth);
      _root.WorkPad['_'+depth].loader = new MovieClipLoader();
      
      listener = new Object();
      listener.onLoadStart = function (target:MovieClip) {
        _root.Tabs[target._name]._alpha = 50;
      };
      listener.onLoadComplete = function (target:MovieClip) {
        _root.Tabs[target._name]._alpha = 100;
        _root.Tabs[target._name].caption = "image";
        target.path = _root.Tabs[target._name].path;
      };
      listener.onLoadError = function (target:MovieClip) {
        _root.Tabs[target._name]._alpha = 50;
        _root.Tabs[target._name].caption = "image [load error]";
      };
      listener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
        _root.Tabs[target._name].caption = "image "+Math.round((100*bytesLoaded)/bytesTotal)+"% loaded";
      };
      
      _root.WorkPad['_'+depth].listener = listener;
      _root.WorkPad['_'+depth].loader.addListener(_root.WorkPad['_'+depth].listener);
      _root.WorkPad['_'+depth].loader.loadClip(path,_root.WorkPad['_'+depth]);
      break;
  }
  
  _root.Tabs.attachMovie('tab','_'+depth,depth);
  _root.Tabs['_'+depth]._y = Math.floor(depth*_root.Tabs['_'+depth]._height);
  _root.Tabs['_'+depth].caption = kind;
  
  if (kind == "image")
    _root.Tabs['_'+depth].path = path;
  
  _root.ActiveLayer = _root.WorkPad['_'+depth];
  return _root.WorkPad['_'+depth];
}

function removeComponent (depth) {
  var name:String = '_' + depth;
  var n:Number;
  
  if (_root.WorkPad[name] instanceof TextField) {
    _root.WorkPad[name].removeTextField();
  }
  else if (_root.WorkPad[name].loader) {
    _root.WorkPad[name].loader.unloadClip(_root.WorkPad[name]);
    removeMovieClip(_root.WorkPad[name]);
  }
  else {
    removeMovieClip(_root.WorkPad[name]);
  }
  
  _root.Tabs[_root.ActiveLayer._name].play();
  removeMovieClip(_root.Tabs[name]);
  _root.ActiveLayer = false;
  _root.ActiveTool = false;
  _root.ToolPad['resizer']._visible = false;
  _root.ToolPad['rotator']._visible = false;
	_root.Tools['TransformTool']['resizeActive']._visible = false;
	_root.Tools['TransformTool']['rescaleActive']._visible = false;
	_root.Tools['TransformTool']['moveActive']._visible = false;
	_root.Tools['TransformTool']['rotateActive']._visible = false;
  _root.moveStop();
  
  for (n=depth+1;n<_root.WorkPad.getNextHighestDepth();n++) {
    _root.WorkPad['_'+n].swapDepths(n-1);
    _root.WorkPad['_'+n]._name = '_' + (n-1);
    
    _root.Tabs['_'+n].swapDepths(n-1);
    _root.Tabs['_'+n]._y = Math.floor((n-1)*_root.Tabs['_'+n]._height);
    _root.Tabs['_'+n]._name = '_' + (n-1);
  }
}

var resizeSketch:Function = function (width:Number,height:Number) {
  _root.Mask._width = width;
  _root.Mask._height = height;
  
  _root.Mask._x = _root.Background._x + (_root.Background._width - width)/2;
  _root.Mask._y = _root.Background._y + (_root.Background._height - height)/2;
  _root.WorkPad._x = _root.Mask._x;
  _root.WorkPad._y = _root.Mask._y;
  _root.ToolPad._x = _root.Mask._x;
  _root.ToolPad._y = _root.Mask._y;
}

var generateXML:Function = function (show:Boolean) {
  var xml:String = new String;
  
  xml = "<?xml version=\"1.0\"?>\n<root width=\""+_root.Mask._width+"\" height=\""+_root.Mask._height+"\">";
  
  for (var n in _root.WorkPad) {
    for (var c in _root.WorkPad[n]) {
      trace(c+':'+_root.WorkPad[n][c]);
    }
    
    if (_root.WorkPad[n] instanceof TextField) {
      var style = _root.WorkPad[n].getTextFormat();
      
      xml += "\n\t<text font=\"" + style.font +
        "\" size=\"" + style.size +
        "\" color=\"" + _root.dechex(style.color) +
        "\" width=\"" + _root.WorkPad[n]._width +
        "\" height=\"" + _root.WorkPad[n]._height +
        "\" xscale=\"" + _root.WorkPad[n]._xscale +
        "\" yscale=\"" + _root.WorkPad[n]._yscale +
        "\" rotation=\""+_root.WorkPad[n]._rotation +
        "\" x=\""+_root.WorkPad[n]._x +
        "\" y=\""+_root.WorkPad[n]._y +
        "\">";
      
      xml += _root.WorkPad[n].text.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;")+"</text>";
    }
    else if (_root.WorkPad[n].path) {
      xml += "\n\t<image path=\"" + _root.WorkPad[n].path +
        "\" width=\"" + _root.WorkPad[n]._width +
        "\" height=\"" + _root.WorkPad[n]._height +
        "\" xscale=\"" + _root.WorkPad[n]._xscale +
        "\" yscale=\"" + _root.WorkPad[n]._yscale +
        "\" rotation=\"" + _root.WorkPad[n]._rotation +
        "\" x=\"" + _root.WorkPad[n]._x +
        "\" y=\"" + _root.WorkPad[n]._y + "\" />";
    }
    else if (_root.WorkPad[n].polygons) {
      xml += "\n\t<draw" +
        " width=\"" + _root.WorkPad[n]._width +
        "\" height=\"" + _root.WorkPad[n]._height +
        "\" xscale=\"" + _root.WorkPad[n]._xscale +
        "\" yscale=\"" + _root.WorkPad[n]._yscale +
        "\" rotation=\"" + _root.WorkPad[n]._rotation +
        "\" x=\"" + _root.WorkPad[n]._x +
        "\" y=\"" + _root.WorkPad[n]._y + "\">";
      
      var draw:String = "";
      
      for (var p in _root.WorkPad[n].polygons)
      {
        var current:String = "";
        var polygon = _root.WorkPad[n].polygons[p];
        
        current += "\n\t\t<polygon size=\"" + polygon.width +
          "\" color=\"" + _root.dechex(polygon.color) + "\">";
        
        polygon = polygon.polygon;
        
        for (var q in polygon)
          current += polygon[q].x + "," + polygon[q].y + ",";
        
        draw = current + "</polygon>" + draw;
      }
      
      xml += draw + "\n\t</draw>";
    }
  }
  
  xml += "\n</root>";
  return xml;
}

var dechex:Function = function (dec:Number) {
  var hex:String = "";
  var f:Number;
  
  while (dec)
  {
    f = dec & 0xf;
    dec = dec >> 4;
    
    switch (f) {
      case 10:
        hex = "a"+hex;
        break;
      case 11:
        hex = "b"+hex;
        break;
      case 12:
        hex = "c"+hex;
        break;
      case 13:
        hex = "d"+hex;
        break;
      case 14:
        hex = "e"+hex;
        break;
      case 15:
        hex = "f"+hex;
        break;
      default:
        hex = f+hex;
    }
  }
  
  while (hex.length < 6)
    hex = "0" + hex;
  
  hex = "0x"+hex;
  return hex;
}

function removeCurrentLayer () {
  if (!_root.ActiveLayer)
    return;
  
  _root.removeComponent(_root.ActiveLayer.getDepth());
}

function setActiveLayer (depth) {
  _root.ActiveLayer = _root.WorkPad["_"+depth];
}