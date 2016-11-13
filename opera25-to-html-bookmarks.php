
<?php

# Tested on Ubuntu 14.04 with Opera Developer 25 Bookmarks file and imported successfully to Google Chrome. 
# Opera developer folder in Ubuntu 14.04: ~/.config/opera-developer. See Opera About dialog for other OSes.
# The JSON file that we have to parse is in /$OPERA_FOLDER/Bookmarks
# Usage: php opera25_to_html_bookmarks.php Bookmarks output_file.html

if( count($argv) != 3 ) echo "Usage: php opera25_to_html_bookmarks.php Bookmarks output_file.html\n\n";

function indent( $lvl )
{
	$str = "";
	for( $i = 0; $i < $lvl; $i++ )
	{
		$str .= "  ";
	}
	return $str;
}

function open_folder( $folder )
{
	return "<DT><H3>$folder</H3>\n<DL><p>\n";
}

function close_folder( )
{
	return "</DL><p>\n\n";
}

function write_url( $url, $name  )
{
	return "<DT><A HREF=\"$url\" LAST_CHARSET=\"UTF-8\">$name</A><DD>\n";
}

function parse_folder( $d, $n = 0, $ejem=true )
{
	$str = "";
	if (is_array($d)) {
		foreach( $d as $key => $value )
		{
			if( $value['type'] == 'folder' )
			{
				$str .= indent($n) . open_folder( $value["name"] );
				$str .= indent($n) . parse_folder( $value['children'], $n + 1 );
				$str .= indent($n) . close_folder();
			}
			if( $value['type'] == 'url' )
			{
				$str .= indent($n) . write_url( $value['url'], $value['name'] );
			}
		}
	}
	return $str;
}



$str = 	'<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">'.
		'<TITLE>Bookmarks</TITLE>'.
		'<H1>Bookmarks Menu</H1>';

$json = file_get_contents( $argv[1] );
$data = json_decode($json,true);
$thedata = $data['roots'];

$str .= "<DL><p>\n\n";
foreach( $thedata as $k => $v )
{
	if( isset($v["children"]) )
	{
		$str .= open_folder($k);
		$str .= parse_folder($v["children"]);
		$str .= close_folder();
	}
	else
	{
		$str .= parse_folder($v);
	}
}

file_put_contents( $argv[2], $str );

?>

