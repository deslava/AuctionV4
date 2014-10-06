<?php

include 'serverConfig.php';

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");
clearstatcache();

$con = mysql_connect($db_host, $db_user, $db_pwd);
mysql_select_db($db_name) or die("Unable to select database");


$compareVar = $_POST['searchVar'];
$tableUpdate = $_POST['table1'];


if ($tableUpdate == "Load") {
    $query = "(SELECT category FROM items_category)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<itemsCategories>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);
        $xml_output .= "\t\t<itemCategory " . "name=" . "\"" . $row['category'] . "\"" . ">" . $row['category'] . "</itemCategory>\n";

    }

    $xml_output .= "\t</itemsCategories>\n";
    echo $xml_output;

}

if ($tableUpdate == "Add") {

    $query = "(SELECT * FROM items_category WHERE category='$compareVar')";
    $result = mysql_fetch_array(mysql_query($query));

    if (!$result) {
        mysql_query("INSERT INTO items_category (category) VALUES ('$compareVar')");
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>ok</xml>";
        echo $xml_output;
    } else {
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>Error</xml>";
        echo $xml_output;
    }

}


?>