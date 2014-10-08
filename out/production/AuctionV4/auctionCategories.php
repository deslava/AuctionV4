<?php

include 'serverConfig.php';

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");
clearstatcache();

$con = mysql_connect($db_host, $db_user, $db_pwd);

if (!$con) {
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>Error</xml>";

    die($xml_output);
}


mysql_select_db($db_name) or die("Unable to select database");


$compareVar = $_POST['searchVar'];
$tableUpdate = $_POST['table1'];


if ($tableUpdate == "Load") {
    $query = "(SELECT category FROM auction_category)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<auctionCategories>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);
        $xml_output .= "\t\t<auctionCategory " . "name=" . "\"" . $row['category'] . "\"" . ">" . $row['category'] . "</auctionCategory>\n";

    }

    $xml_output .= "\t</auctionCategories>\n";
    echo $xml_output;
}

if ($tableUpdate == "Add") {

    $query = "(SELECT * FROM auction_category WHERE category='$compareVar')";
    $result = mysql_fetch_array(mysql_query($query));

    if (!$result) {
        mysql_query("INSERT INTO auction_category (category) VALUES ('$compareVar')");
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