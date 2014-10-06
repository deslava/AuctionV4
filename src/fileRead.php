<?php
date_default_timezone_set("America/Chicago");

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");
clearstatcache();

$fileName = $_POST['fileName'];

$fh = fopen($fileName, 'r') or die("can't open file");
$data = fread($fh, filesize($fileName));
fclose($fh);

echo $data;

?>