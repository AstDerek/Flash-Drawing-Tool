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

header("Content-Type: text/plain");
echo 100*strlen($_POST['composition'])/strlen(decode_lzw($_POST['composition']))."\n";
echo $_POST['composition']."\n";
echo decode_lzw($_POST['composition']);