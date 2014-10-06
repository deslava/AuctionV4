<?php

include 'serverConfig.php';

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");
clearstatcache();

$con = mysql_connect($db_host, $db_user, $db_pwd);
mysql_select_db($db_name) or die("Unable to select database");

$auction_id = $_POST['auctionID'];
$tableUpdate = $_POST['table1'];

if ($tableUpdate == "buyerInvoice") {
    $query = "SELECT COUNT(bidder_id), bidder_id, SUM(start_bid) FROM auction_items  WHERE auction_id = '$auction_id' && bidder_type = 'Bidder' && start_bid > max_bid   GROUP BY bidder_id";

    $result = mysql_query($query);

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemsNumber>" . $row['COUNT(bidder_id)'] . "</itemsNumber>\n";
        $xml_output .= "\t\t<buyerId>" . $row['bidder_id'] . "</buyerId>\n";
        $xml_output .= "\t\t<itemsTotal>" . $row['SUM(start_bid)'] . "</itemsTotal>\n";
        $xml_output .= "\t\t<itemName></itemName>\n";
        $xml_output .= "\t\t<tax></tax>\n";
        $xml_output .= "\t\t<completeTotal></completeTotal>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}

if ($tableUpdate == "sellerInvoice") {
    $query = "SELECT COUNT(seller_id) as seller_count, seller_id, SUM(start_bid) as final_bid FROM auction_items  WHERE auction_id = '$auction_id' && bidder_type = 'Bidder' && start_bid > max_bid GROUP BY seller_id Union All Select COUNT(seller_id) as seller_count, seller_id, '0' as final_bid FROM auction_items  WHERE auction_id = '$auction_id' && bidder_type = 'Bidder' && start_bid < max_bid && max_bid != '0' GROUP BY seller_id";
    $result = mysql_query($query);

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemsNumber>" . $row['seller_count'] . "</itemsNumber>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemsTotal>" . $row['final_bid'] . "</itemsTotal>\n";
        $xml_output .= "\t\t<itemName></itemName>\n";
        $xml_output .= "\t\t<tax></tax>\n";
        $xml_output .= "\t\t<completeTotal></completeTotal>\n";
        $xml_output .= "\t</item>\n";
    }
    $xml_output .= "\t</items>\n";

    echo $xml_output;

}

mysql_close($con);
?>