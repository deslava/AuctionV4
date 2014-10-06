<?php

include 'serverConfig.php';
error_reporting(0);
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
    $query = "(SELECT category FROM fees_category)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<feesCategories>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);
        $xml_output .= "\t\t<feeCategory " . "name=" . "\"" . $row['category'] . "\"" . ">" . $row['category'] . "</feeCategory>\n";

    }

    $xml_output .= "\t</feesCategories>\n";
    echo $xml_output;

}

if ($tableUpdate == "Add") {

    $query = "(SELECT * FROM fees_category WHERE category='$compareVar')";
    $result = mysql_fetch_array(mysql_query($query));

    if (!$result) {
        mysql_query("INSERT INTO fees_category (category) VALUES ('$compareVar')");
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>ok</xml>";
        echo $xml_output;
    } else {
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>Error</xml>";
        echo $xml_output;
    }

}


if ($tableUpdate == "LoadAuctionFee") {
    $query = "(SELECT category FROM fees_auction)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<feesCategories>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);
        $xml_output .= "\t\t<feeCategory " . "name=" . "\"" . $row['category'] . "\"" . ">" . $row['category'] . "</feeCategory>\n";

    }

    $xml_output .= "\t</feesCategories>\n";
    echo $xml_output;

}

if ($tableUpdate == "AddAuctionFee") {

    $query = "(SELECT * FROM fees_auction WHERE category='$compareVar')";
    $result = mysql_fetch_array(mysql_query($query));

    if (!$result) {
        mysql_query("INSERT INTO fees_auction (category) VALUES ('$compareVar')");
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>ok</xml>";
        echo $xml_output;
    } else {
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>Error</xml>";
        echo $xml_output;
    }

}


if ($tableUpdate == "LoadSellerFee") {
    $query = "(SELECT category FROM fees_seller)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<feesCategories>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);
        $xml_output .= "\t\t<feeCategory " . "name=" . "\"" . $row['category'] . "\"" . ">" . $row['category'] . "</feeCategory>\n";

    }

    $xml_output .= "\t</feesCategories>\n";
    echo $xml_output;

}

if ($tableUpdate == "AddSellerFee") {

    $query = "(SELECT * FROM fees_seller WHERE category='$compareVar')";
    $result = mysql_fetch_array(mysql_query($query));

    if (!$result) {
        mysql_query("INSERT INTO fees_seller (category) VALUES ('$compareVar')");
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>ok</xml>";
        echo $xml_output;
    } else {
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>Error</xml>";
        echo $xml_output;
    }

}


if ($tableUpdate == "LoadItemFee") {
    $query = "(SELECT category FROM fees_item)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<feesCategories>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);
        $xml_output .= "\t\t<feeCategory " . "name=" . "\"" . $row['category'] . "\"" . ">" . $row['category'] . "</feeCategory>\n";

    }

    $xml_output .= "\t</feesCategories>\n";
    echo $xml_output;

}

if ($tableUpdate == "AddItemFee") {

    $query = "(SELECT * FROM fees_item WHERE category='$compareVar')";
    $result = mysql_fetch_array(mysql_query($query));

    if (!$result) {
        mysql_query("INSERT INTO fees_item (category) VALUES ('$compareVar')");
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>ok</xml>";
        echo $xml_output;
    } else {
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>Error</xml>";
        echo $xml_output;
    }

}


mysql_close($con);

?>