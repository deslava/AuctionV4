<?php

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");

$fileXML = $_POST['fileXML'];
$fileName = $_POST['fileName'];
$target_path = $_POST['path'];


$fileXML = str_replace("\n", "\r\n", $fileXML);
$fileXML = str_replace("\r\r\n", "\r\n", $fileXML);
$fileXML = stripslashes($fileXML);

if (!file_exists($target_path)) {
    $oldumask = umask(0);
    $rs = mkdir($target_path, 0755, true);
    umask($oldumask);
}

$target_path = $target_path . $fileName;

$fh = fopen($target_path, 'w') or die("can't open file");
fwrite($fh, $fileXML);
fclose($fh);

$xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
$xml_output .= "\t<xml>ok</xml>\n";

echo $xml_output;


?>