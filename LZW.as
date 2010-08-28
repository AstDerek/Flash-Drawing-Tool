// http://www.razorberry.com/blog/archives/2004/08/22/lzw-compression-methods-in-as2/
//
// A class for LZW compression modified from code posted at the following URL's
// http://www.shoe-box.org/blog/index.php/2004/05/05/13-CompressionLzw
// http://www.lalex.com/blog/comments/200405/164-compression-lzw-actionscript-2.html
// Use compress_fp6() instead of compress() if exporting to flash player 6

	// Change this variable to output an xml safe string
_global.xmlsafe = false;

var compress:Function = function (str:String):String
{
  var dico:Array = new Array();
  var skipnum:Number = xmlsafe?5:0;
  for (var i = 0; i < 256; i++)
  {
    dico[String.fromCharCode(i)] = i;
  }
  if (xmlsafe)
  {
    dico["<"] = 256;
    dico[">"] = 257;
    dico["&"] = 258;
    dico["\""] = 259;
    dico["'"] = 260;
  }
  var res:String = "";
  var txt2encode:String = str;
  var splitStr:Array = txt2encode.split("");
  var len:Number = splitStr.length;
  var nbChar:Number = 256+skipnum;
  var buffer:String = "";
  for (var i = 0; i <= len; i++)
  {
    var current = splitStr[i];
    if (dico[buffer + current] !== undefined)
    {
      buffer += current;
    }
    else
    {
      res += String.fromCharCode(dico[buffer]);
      dico[buffer + current] = nbChar;
      nbChar++;
      buffer = current;
    }
  }
  return res;
}

var decompress:Function = function (str:String):String
{
  var dico:Array = new Array();
  var skipnum:Number = xmlsafe?5:0;
  for (var i = 0; i < 256; i++)
  {
    var c:String = String.fromCharCode(i);
    dico[i] = c;
  }
  if (xmlsafe)
  {
    dico[256] = "<";
    dico[257] = ">";
    dico[258] = "&";
    dico[259] = "\"";
    dico[260] = "'";
  }
  var txt2encode:String = str;
  var splitStr:Array = txt2encode.split("");
  var length:Number = splitStr.length;
  var nbChar:Number = 256+skipnum;
  var buffer:String = "";
  var chaine:String = "";
  var result:String = "";
  for (var i = 0; i < length; i++)
  {
    var code:Number = txt2encode.charCodeAt(i);
    var current:String = dico[code];
    if (buffer == "")
    {
      buffer = current;
      result += current;
    }
    else
    {
      if (code <= 255+skipnum)
      {
        result += current;
        chaine = buffer + current;
        dico[nbChar] = chaine;
        nbChar++;
        buffer = current;
      }
      else
      {
        chaine = dico[code];
        if (chaine == undefined) chaine = buffer + buffer.slice(0,1);
        result += chaine;
        dico[nbChar] = buffer + chaine.slice(0, 1);
        nbChar++;
        buffer = chaine;
        
      }
    }
  }
  return result;
}

var compress_fp6:Function = function (str:String):String
{
  var dico:Array = new Array();
  var skipnum:Number = xmlsafe?5:0;
  for (var i = 0; i < 256; i++)
  {
    dico[String(i)] = i;
  }
  if (xmlsafe)
  {
    var let = String(new String("<").charCodeAt(0));
    var grt = String(new String(">").charCodeAt(0));
    var amp = String(new String("&").charCodeAt(0));
    var bsl = String(new String("\"").charCodeAt(0));
    var apo = String(new String("'").charCodeAt(0));
    dico[let] = 256;
    dico[grt] = 257;
    dico[amp] = 258;
    dico[bsl] = 259;
    dico[apo] = 260;
  }
  var res:String = "";
  var txt2encode:String = str;
  var splitStr:Array = txt2encode.split("");
  var len:Number = splitStr.length;
  var nbChar:Number = 256+skipnum;
  var buffer:Array = new Array();
  for (var i = 0; i <= len; i++)
  {
    var current = splitStr[i];
    if (buffer.length == 0)
    var xstr = String(current.charCodeAt(0));
    else
    var xstr = buffer.join("-") + "-" + String(current.charCodeAt(0));
    if (dico[xstr] !== undefined)
    {
      buffer.push(current.charCodeAt(0));
    }
    else
    {
      res += String.fromCharCode(dico[buffer.join("-")]);
      dico[xstr] = nbChar;
      nbChar++;
      delete buffer;
      buffer = new Array();
      buffer.push(current.charCodeAt(0));
    }
  }
  return res;
}

var toHex:Function = function (number:Number) {
	var inHex:String = "";
	var section = 0;
	
	for (var n=0;n<6;n++) {
		section = number & 0xf;
		number = Math.floor(number/0x10);
		
		switch (section) {
			case 0xf:
				inHex = "f"+inHex;
				break;
			case 0xe:
				inHex = "e"+inHex;
				break;
			case 0xd:
				inHex = "d"+inHex;
				break;
			case 0xc:
				inHex = "c"+inHex;
				break;
			case 0xb:
				inHex = "b"+inHex;
				break;
			case 0xa:
				inHex = "a"+inHex;
				break;
			default:
				inHex = section.toString()+inHex;
		}
	}
	
	return inHex;
}