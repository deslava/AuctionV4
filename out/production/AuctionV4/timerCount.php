<?php
date_default_timezone_set("America/Chicago");

$date = date("r", time());

$xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
$xml_output .= "\t<xml>" . $date . "</xml>\n";

echo $xml_output;
?>