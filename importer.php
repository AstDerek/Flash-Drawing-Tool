<?php

function encode_lzw($str)
{
  $dico = array();

  for ($i = 0; $i < 256; $i++)
  {
    $dico[unichr($i)] = $i;
  }

  $res = "";
  $len = strlen($str);
  $nbChar = 256;
  $buffer = "";

  for ($i = 0; $i <= $len; $i++)
  {
    $current = $str[$i];
    if ($i < strlen($str) && $dico[$buffer . $current] !== null)
    {
      $buffer .= $current;
    }
    else
    {
      $res .= unichr($dico[$buffer]);
      $dico[$buffer . $current] = $nbChar;
      $nbChar++;
      $buffer = $current;
    }
  }

  return $res;
}

function decode_lzw($str)
{
  $dico = array();

  for ($i = 0; $i < 256; $i++)
  {
    $c = unichr($i);
    $dico[$i] = $c;
  }

  $nbChar = 256;
  $buffer = "";
  $chaine = "";
  $result = "";
  $strSplit = preg_split('//u', $str);
  array_pop($strSplit);
  array_shift($strSplit);

  $length = count($strSplit);

  for ($i = 0; $i < $length; $i++)
  {
    $code = uniord($strSplit[$i]);
    $current = $dico[$code];
    if ($buffer == "")
    {
      $buffer = $current;
      $result .= $current;
    }
    else
    {
      if ($code <= 255)
      {
        $result .= $current;
        $chaine = $buffer . $current;
        $dico[$nbChar] = $chaine;
        $nbChar++;
        $buffer = $current;
      }
      else
      {
        $chaine = $dico[$code];
        if ($chaine == "") $chaine = $buffer . $buffer[0];
        $result .= $chaine;
        $dico[$nbChar] = $buffer . $chaine[0];
        $nbChar++;
        $buffer = $chaine;
      }
    }
  }

  return $result;
}

function unichr($u)
{
  $str = html_entity_decode('&#'.$u.';',ENT_NOQUOTES,'UTF-8');
  return $str;
}

function uniord($u) {
  $k = mb_convert_encoding($u, 'UCS-2LE', 'UTF-8');
  $k1 = ord(substr($k, 0, 1));
  $k2 = ord(substr($k, 1, 1));
  return $k2 * 256 + $k1;
}

function toHex(&$value) {
  $value = pack("N",hexdec($value));
}

session_start();
if (!$_SESSION['part'] || $_REQUEST['reset']) {
  $_SESSION['part'] = array();
  echo "Reset";
}

if ($_REQUEST['composition']) {
  $rawdata = decode_lzw($_REQUEST['composition']);
  $rawdata = explode("x",trim($rawdata,"x"));
  
  file_put_contents("report.txt",count($rawdata));
  
  array_walk($rawdata,toHex);
  $rawdata = join("",$rawdata);
  
  $_SESSION['part'][$_REQUEST['part']] = $rawdata;
  $_SESSION['width'] = $_REQUEST['width'];
  $_SESSION['height'] = $_REQUEST['height'];
}
  
if (count($_SESSION['part']) < $_REQUEST['total'])
  return;

if (!$_REQUEST['send'])
  return;

$rawdata = join("",$_SESSION['part']);
$width = $_SESSION['width'];
$height = $_SESSION['height'];

$header = pack("n",0xfffe);
$header .= pack("n",$width);
$header .= pack("n",$height);
$header .= pack("c",1);
$header .= pack("N",0xffffffff);

$tmpfname = tempnam(".","IMAGE");
file_put_contents($tmpfname,$header.$rawdata);
$image = imagecreatefromgd($tmpfname);
unlink($tmpfname);

header("Content-Type: image/png");
imagepng($image,null,9);