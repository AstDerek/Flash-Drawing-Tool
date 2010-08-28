<?php //version 1.604
############################################################
##                        WARNING!                        ##
##                                                        ##
## This script is copyrighted to ButterFlyMarketing.com   ##
## Duplication, selling, or transferring of this script   ##
## is a violation of the copyright and purchase agreement.##
## Alteration of this script in any way voids any         ##
## responsibility ButterFlyMarketing.com has towards the  ##
## functioning of the script. Altering the script in an   ##
## attempt to unlock other functions of the program that  ##
## have not been purchased is a violation of the purchase ##
## agreement and forbidden by ButterFlyMarketing.com.     ##
## By modifying/running this script you agree to the terms##
## and conditions of ButterFlyMarketing.com located at    ##
## http://www.butterflymarketing.com/terms.php            ##
############################################################

ini_set("memory_limit","128M");

include("../inc.top.php");
$q2=new CDB;
$q3=new CDB;
$q4=new CDB;
function do_check($name)
{
	global $t, $q;
	if ($q->f($name)==1)
	$t->set_var($name,"checked");
	else
	$t->set_var($name,"");
}
get_logged_info();
$q2=new CDB;
$query="SELECT id FROM menus WHERE link='member.area.profile.php'";
$q2->query($query);
$q2->next_record();
$query="SELECT membership_id FROM menu_permissions WHERE menu_item='".$q2->f("id")."'";
$q2->query($query);
while ($q2->next_record()) {
	$permissions[]=$q2->f("membership_id");
}
if (count($permissions)>0) {
	$error='<center><font color="red"><b>You do not have access to this area!<br><br>Upgrade your membership level!</b></font></center>';
	foreach ($permissions as $value) {
		if ($value==$q->f("membership_id")) {
			$error='';
			break;
		}
	}
	if ($error!="") {
		die("$error");
	}
}
$member_id=$q->f("id");
$membership_id=$q->f("membership_id");

$add_watermark = ($membership_id < 2);
$watermark = "biz_logo.png";

/**
 * PNG ALPHA CHANNEL SUPPORT for imagecopymerge();
 * This is a function like imagecopymerge but it handle alpha channel well!!!
 **/

// A fix to get a function like imagecopymerge WITH ALPHA SUPPORT
// Main script by aiden dot mail at freemail dot hu
// Transformed to imagecopymerge_alpha() by rodrigo dot polo at gmail dot com
function imagecopymerge_alpha ($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $src_w, $src_h, $pct)
{
	if (!isset($pct))
		return false;
	
	$pct /= 100;
	
	// Get image width and height
	$w = imagesx($src_im);
	$h = imagesy($src_im);
	
	// Turn alpha blending off
	imagealphablending($src_im,false);
	
	// Find the most opaque pixel in the image (the one with the smallest alpha value)
	$minalpha = 127;
	
	for ($x=0;$x<$w;$x++)
	{
		for ($y=0;$y<$h;$y++)
		{
			$alpha = (imagecolorat($src_im,$x,$y) >> 24) & 0xFF;
			
			if ($alpha < $minalpha)
				$minalpha = $alpha;
		}
	}
	
	//loop through image pixels and modify alpha for each
	for ($x=0;$x<$w;$x++)
	{
		for ($y=0;$y<$h;$y++)
		{
			//get current alpha value (represents the TANSPARENCY!)
			$colorxy = imagecolorat($src_im,$x,$y);
			$alpha = ($colorxy >> 24) & 0xFF;
			
			//calculate new alpha
			if ($minalpha !== 127)
				$alpha = 127 + 127*$pct*($alpha - 127)/(127 - $minalpha);
			else
				$alpha += 127*$pct;
			
			//get the color index with new alpha
			$alphacolorxy = imagecolorallocatealpha($src_im,($colorxy >> 16) & 0xFF,($colorxy >> 8) & 0xFF,$colorxy & 0xFF,$alpha);
			
			//set pixel with the new color + opacity
			if (!imagesetpixel($src_im,$x,$y,$alphacolorxy))
				return false;
		}
	}
	
	// The image copy
	imagecopy($dst_im,$src_im,$dst_x,$dst_y,$src_x,$src_y,$src_w,$src_h);
}

function add_image (&$main_image,$item,$background=false)
{
	global $white;
	
	if (!preg_match("@\.(gd|gd2|jpg|jpeg|jfif|gif|png|bmp|xbm|xpm)$@i",$item['source'],$ext))
		return;
	
	$new_image = false;
	
	switch (strtolower($ext))
	{
		case "gd":
			$new_image = imagecreatefromgd($item['source']);
			break;
		case "gd2":
			$new_image = imagecreatefromgd2($item['source']);
			break;
		case "jpg":
		case "jpeg":
			$new_image = imagecreatefromjpeg($item['source']);
			break;
		case "gif":
			$new_image = imagecreatefromgif($item['source']);
			break;
		case "png":
			$new_image = imagecreatefrompng($item['source']);
			break;
		case "bmp":
			$new_image = imagecreatefromwbmp($item['source']);
			break;
		case "xbm":
			$new_image = imagecreatefromxbm($item['source']);
			break;
		case "xpm":
			$new_image = imagecreatefromxpm($item['source']);
			break;
		default:
			$file = fopen($item['source'],"rb");
			if (!$file)
				break;
			
			$data = "";
			while (!feof($file))
				$data .= fread($file,8192);
			
			fclose($file);
			
			if ($data)
			{
				$new_image = imagecreatefromstring($data);
				unset($data);
			}
	}
	
	if (($new_image) && ($item['rotation']%360))
	{
		$tmp_image = imagerotate($new_image,360-$item['rotation'],-1);
		
		if ($tmp_image)
		{
			imagedestroy($new_image);
			$new_image = $tmp_image;
		}
		else
		{
			$width = imagesx($new_image);
			$height = imagesy($new_image);
			$tmp_image = imagecreatetruecolor($width,$height);
			
			if ($tmp_image)
			{
				imagecopy($tmp_image,$new_image,0,0,0,0,$width,$height);
				imagedestroy($new_image);
				$new_image = imagerotate($tmp_image,360-$item['rotation'],-1);
				imagedestroy($tmp_image);
			}
			else
				imagedestroy($new_image);
		}
	}
	
	if ($new_image)
	{
		imagealphablending($new_image,true);
		imagesavealpha($new_image,true);
		
		$nwidth = imagesx($new_image);
		$nheight = imagesy($new_image);
		
		if ($background)
		{
			$width = imagesx($main_image);
			$height = imagesy($main_image);
			
			imagecopyresampled($main_image,$new_image,0,0,0,0,$width,$height,$nwidth,$nheight);
		}
		else
		{
			if (($item['xscale'] != 100) || ($item['yscale'] != 100))
			{
				imagecopyresampled($main_image,$new_image,$item['x']-$nwidth*$item['xscale']/200,$item['y']-$nheight*$item['yscale']/200,0,0,$nwidth*$item['xscale']/100,$nheight*$item['yscale']/100,$nwidth,$nheight);
			}
			else
				imagecopy($main_image,$new_image,$item['x']-$nwidth/2,$item['y']-$nheight/2,0,0,$nwidth,$nheight);
		}
		
		imagedestroy($new_image);
	}
}

function add_trace (&$main_image,$item,$line)
{
	$paths = explode(";",$item['source']);
	
	foreach ($paths as &$path)
	{
		$path = explode(",",$path);
		
		if (count($path) < 2)
			continue;
		
		foreach ($path as &$coord)
		{
			$coord = explode(".",$coord);
			
			if (!isset($xmin) || ($coord[0] < $xmin))
				$xmin = $coord[0];
			
			if (!isset($ymin) || ($coord[1] < $ymin))
				$ymin = $coord[1];
			
			if (!isset($xmax) || ($coord[0] > $xmax))
				$xmax = $coord[0];
			
			if (!isset($ymax) || ($coord[1] > $ymax))
				$ymax = $coord[1];
		}
	}
	
	$nwidth = abs($xmax - $xmin) + 1;
	$nheight = abs($ymax - $ymin) + 1;
	
	if (!$nwidth || !$nheight)
		return;
	
	$new_image = imagecreatetruecolor($nwidth,$nheight);
	$trans = imagecolorallocatealpha($new_image,0xff,0xff,0xff,127);
	imagefill($new_image,0,0,$trans);
	imagesetthickness($new_image,2);
	
	foreach ($paths as $npath)
	{
		for ($n=1;$n<count($npath);$n++)
		{
			echo $npath[$n-1][0].",".$npath[$n-1][1].";".$npath[$n][0].",".$npath[$n][1]."\n";
			imageline($new_image,$npath[$n-1][0],$npath[$n-1][1],$npath[$n][0],$npath[$n][1],$line);
		}
	}
	
	imagepng($new_image,"trazo.png",9);
	
	if ($item['rotation']%360)
	{
		$tmp_image = imagerotate($new_image,360-$item['rotation'],-1);
		
		if (!$tmp_image)
		{
			imagedestroy($new_image);
			return;
		}
		else
		{
			imagedestroy($new_image);
			$new_image = $tmp_image;
		}
	}
	
	imagealphablending($new_image,true);
	imagesavealpha($new_image,true);
	
	if (($item['xscale'] != 100) || ($item['yscale'] != 100))
		imagecopyresampled($main_image,$new_image,$item['x']-$nwidth*$item['xscale']/200,$item['y']-$nheight*$item['yscale']/200,0,0,$nwidth*$item['xscale']/100,$nheight*$item['yscale']/100,$nwidth,$nheight);
	else
		imagecopy($main_image,$new_image,$item['x']-$nwidth/2,$item['y']-$nheight/2,0,0,$nwidth,$nheight);
	
	imagedestroy($new_image);
}

function add_watermark (&$main_image,$filename,$alpha=25)
{
	$watermark = imagecreatefrompng($filename);

	if ($watermark)
	{
		$mwidth = imagesx($main_image);
		$mheight = imagesy($main_image);
		
		$wwidth = imagesx($watermark);
		$wheight = imagesy($watermark);
		
		imagecopymerge_alpha($watermark,$watermark,0,0,0,0,$wwidth,$wheight,$alpha);
		imagecopyresampled($main_image,$watermark,0,0,0,0,$mwidth,$mheight,$wwidth,$wheight);
		
		imagedestroy($watermark);
	}
}

header("Content-Type: text/plain");
$xml = stripslashes(trim($_POST['composition']));
@file_put_contents("saved.xml",$xml);

if (!$xml)
	exit("saved=false");

$xml = preg_replace("@[\n\r]+@"," ",$xml);

if (!preg_match_all("@<(.*?)>@",$xml,$nodes))
	exit("saved=false");

$nodes = $nodes[1];

if (!preg_match("@^\?xml .*\?$@i",$nodes[0]))
	exit("saved=false");

if (!preg_match("@^root( .*)?@",$nodes[1]) || ($nodes[count($nodes) - 1] != "/root"))
	exit("saved=false");


$background = array();

preg_match("@ background=\"(.*?)\"@i",$nodes[1],$match);
$background['source'] = urldecode($match[1]);

preg_match("@ width=\"(.*?)\"@i",$nodes[1],$match);
$background['width'] = intval($match[1]);

preg_match("@ height=\"(.*?)\"@i",$nodes[1],$match);
$background['height'] = intval($match[1]);


if (($background['width'] > 800) || ($background['width'] < 1))
	$background['width'] = 800;

if (($background['height'] > 600) || ($background['height'] < 1))
	$background['height'] = 600;

if (!is_file($background['source']))
	$background['source'] = false;

$items = array();

for ($n=2;$n<count($nodes)-1;$n++)
{
	if (!preg_match("@^item @i",$nodes[$n]))
		continue;
	
	if (!preg_match("@ (img|trace|text)=\"(.*?)\"@i",$nodes[$n],$matches))
		continue;
	
	$item = array("type"=>$matches[1],"source"=>htmlspecialchars_decode($matches[2]));
	
	//if (($item['type'] == "img") && !is_file($item['source']))
	//	continue;
	
	preg_match("@ posX=\"(.*?)\"@i",$nodes[$n],$matches);
	$item['x'] = intval($matches[1]);
	
	preg_match("@ posY=\"(.*?)\"@i",$nodes[$n],$matches);
	$item['y'] = intval($matches[1]);
	
	preg_match("@ scaleX=\"(.*?)\"@i",$nodes[$n],$matches);
	$item['xscale'] = intval($matches[1]);
	
	preg_match("@ scaleY=\"(.*?)\"@i",$nodes[$n],$matches);
	$item['yscale'] = intval($matches[1]);
	
	preg_match("@ rotation=\"(.*?)\"@i",$nodes[$n],$matches);
	$item['rotation'] = intval($matches[1]);
	
	$items[] = $item;
}


$main_image = imagecreatetruecolor($background['width'],$background['height']);
$white = imagecolorallocate($main_image,0xff,0xff,0xff);
$black = imagecolorallocate($main_image,0x00,0x00,0x00);
imagefill($main_image,0,0,$white);

if ($background['source'])
	add_image($main_image,$background,true);

foreach ($items as $item)
{
	if ($item['type'] == "img")
		add_image($main_image,$item);
	elseif ($item['type'] == "trace")
		add_trace($main_image,$item,$black);
	elseif ($item['type'] == "text")
	{
		$size = imagettfbbox(15,360-$item['rotation'],"batik.ttf",$item['source']);
		$width = ($size[2] - $size[0])/2;
		$height = ($size[7] - $size[1])/2;
		imagettftext($main_image,15,360-$item['rotation'],$item['x']-$width,$item['y']-$height,$black,"batik.ttf",$item['source']);
	}
}

if ($add_watermark)
	add_watermark($main_image,$watermark);

//imagettftext($main_image,30,0,50,50,$white,"batik.ttf","[mD]...");
//imagettftext($main_image,30,0,50,100,$white,"batik.ttf","(c) ByteBiz.ca");

imagepng($main_image,"saved.png",9);

header("Content-Type: text/plain");
echo "saved=true&image=saved.png";