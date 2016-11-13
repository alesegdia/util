<?php

# Utility to count bytes in a USB descriptor

$buffer = "";
while($f = fgets(STDIN))
{
	$buffer = $buffer . $f;
}

function valid_byte($str)
{
	$str = trim($str);
	$byte = preg_match('/^0x[0-9A-Fa-f]*$/', $str);
	$constant = preg_match('/^[A-Z_]+$/', $str);
	return ($byte || $constant);
}

function flatten($array)
{
	$iter = new RecursiveIteratorIterator(new RecursiveArrayIterator($array));
	$flat_arr = iterator_to_array($iter, false);
	return $flat_arr;
}

$data = split("\n", $buffer);
$data = flatten($data);
$data = array_map(function($str) { return split("//", $str); }, $data);
$data = array_map(function($arr) { return trim($arr[0]); }, $data);
$data = array_map(function($arr) { return split(",", $arr); }, $data);
$data = flatten($data);
$data = array_filter($data, "valid_byte");

print(count($data));

?>

