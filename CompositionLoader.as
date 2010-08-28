/*

Structure of the app:

- ActiveLayer
- ActiveTool
- ActiveMenu

- WorkPad
  + Background
  + _N

- Tabs
  + _N

- Tools
  + Drawing
  + Transform
  + Font

*/

var ActiveLayer;
var ActiveTool;
var ActiveMenu;

var fontName:String = "Arial";
var fontColor:Number = 0;
var fontSize:Number = 8;

var lineWidth:Number = 1;
var lineColor:Number = 0;
var lineAlpha:Number = 100;

import flash.display.BitmapData;
import flash.geom.Rectangle;