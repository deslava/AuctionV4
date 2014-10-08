<?php

function rm_recursive($filepath)
{
    if (is_dir($filepath) && !is_link($filepath)) {
        if ($dh = opendir($filepath)) {
            while (($sf = readdir($dh)) !== false) {
                if ($sf == '.' || $sf == '..') {
                    continue;
                }
                if (!rm_recursive($filepath . '/' . $sf)) {
                    throw new Exception($filepath . '/' . $sf . ' could not be deleted.');
                }
            }
            closedir($dh);
        }
        return rmdir($filepath);
    }
    if (is_file($filepath)) {
        unlink($filepath);
    }
    return true;
}

include 'serverConfig.php';

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");
clearstatcache();

$con = mysql_connect($db_host, $db_user, $db_pwd);
mysql_select_db($db_name) or die("Unable to select database");


$seller_id = $_POST['sellerID'];
$auction_id = $_POST['auctionID'];
$user_Admintype = $_POST['userType'];
$target_path = $_POST['auction_path'];
$item_id = $_POST['itemID'];
$item_name = $_POST['item_name'];
$item_description = $_POST['item_description'];
$quantity = $_POST['quantity'];
$item_type = $_POST['item_type'];
$bid_increment = $_POST['bid_increment'];
$start_bid = $_POST['start_bid'];
$current_bid = $_POST['current_bid'];
$max_bid = $_POST['max_bid'];
$max_house_or_buynow = $_POST['max_house_or_buynow'];
$open_time = $_POST['open_time'];
$close_time = $_POST['close_time'];
$extend_time = $_POST['extend_time'];
$numitems_permin = $_POST['numitems_permin'];
$item_status = $_POST['item_status'];
$created_date = $_POST['created_date'];
$path = $_POST['path'];
$info_xml = $_POST['info_xml'];
$bidhistory_xml = $_POST['bidhistory_xml'];
$item_thumbnail = $_POST['thumbnail'];

$fileXML = $_POST['fileXML'];

$compareVar = $_POST['searchVar'];
$tableUpdate = $_POST['table1'];

$avail_num = 0;
$last = 0;
$counter = 0;
$minAdd = 0;
$minCal = 0;

$close_time_extend = 0;

if ($tableUpdate == "Add") {

    $strSQL = "SELECT item_id FROM auction_items WHERE auction_id='$auction_id' ORDER BY item_id ASC";
    $result = mysql_query($strSQL);

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);
        If ($counter >= 0) {
            If ($row['item_id'] != $last + 1) {
                $avail_num = $last + 1;
                break;
            }
        }
        $last = $row['item_id'];
        $counter++;
    }
    If (!$avail_num) {
        $avail_num = $last + 1;
    } // in case there are no gaps !!
    $item_id = $avail_num;


    $target_path = $target_path . "items/";
    $target_path = $target_path . $item_id . "/";
    $info_xml = $target_path . $item_id . ".xml";
    $auctionItems = "";

    if ($item_id == 1)
        $minAdd = 0;
    else {
        if ($numitems_permin != 0 || $numitems_permin == "") {
            $minAdd = (($item_id - 1) / $numitems_permin);
        }

    }
    $minAdd = floor($minAdd);


    $minCal = $minAdd * 1000 * 60 * $open_time;
    $close_time_extend = $minCal;


    $query = ("INSERT INTO auction_items (seller_id, auction_id, item_id, item_name, quantity, item_type, start_bid, bidder_type, current_bid, max_bid, max_house_or_buynow, item_status, path, info_xml, open_time, close_time, close_time_extend,  extend_time) VALUES ('$seller_id', '$auction_id', '$item_id', '$item_name', '$quantity', '$item_type', '$start_bid','$user_Admintype', '$start_bid', '$max_bid', '$max_house_or_buynow', '$item_status', '$target_path', '$info_xml', '$open_time', '$close_time', '$close_time_extend', '$extend_time')");
    $result = mysql_query($query);


    $oldumask = umask(0);
    $rs = mkdir($target_path, 0755, true);
    umask($oldumask);


    $query = "(SELECT * FROM auction_items WHERE item_id ='$item_id' AND auction_id='$auction_id' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;


}


if ($tableUpdate == "Load") {
    $query = "(SELECT * FROM auction_items WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}

if ($tableUpdate == "LoadAll") {
    $query = "(SELECT * FROM auction_items WHERE auction_id ='$compareVar' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";
    echo $xml_output;


}


if ($tableUpdate == "loadUnsold") {
    $query = "(SELECT * FROM auction_items WHERE  (start_bid < max_bid || bidder_type = 'House'|| bidder_type = 'Admin' || bidder_type = 'Satallite' || bidder_type = 'Seller') AND auction_id='$auction_id'  ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}

if ($tableUpdate == "loadReserve") {
    $query = "(SELECT * FROM auction_items WHERE  max_bid > 0 AND auction_id='$auction_id' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}

if ($tableUpdate == "loadSold") {
    $query = "(SELECT * FROM auction_items WHERE bidder_type = 'Bidder' AND start_bid >= max_bid AND auction_id='$auction_id' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}


if ($tableUpdate == "loadHouse") {
    $query = "(SELECT * FROM auction_items WHERE (bidder_type = 'House' || bidder_type = 'Admin' || bidder_type = 'Satallite' || bidder_type = 'Seller')  AND auction_id='$auction_id' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}


if ($tableUpdate == "LoadUserSelected") {
    $query = "(SELECT * FROM auction_items WHERE seller_id ='$compareVar' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";
    echo $xml_output;


}

if ($tableUpdate == "Update") {

    $query = "(SELECT * FROM auction_items WHERE auction_id ='$auction_id' && item_id ='$item_id' ORDER BY item_id ASC LIMIT 1)";
    $result = mysql_query($query);

    $row0 = mysql_fetch_assoc($result);
    $currBidder = $row0 ['bidder_id'];

    if ($currBidder == null || $currBidder == "") {
        $query = ("UPDATE auction_items SET seller_id = '$seller_id',  auction_id ='$auction_id', item_id = '$item_id' , item_name = '$item_name' ,  quantity = '$quantity', item_type = '$item_type', start_bid= '$start_bid', max_bid='$max_bid', max_house_or_buynow='$max_house_or_buynow' WHERE info_xml = '$info_xml'");
        $result = mysql_query($query);
    } else {
        $query = ("UPDATE auction_items SET seller_id = '$seller_id',  auction_id ='$auction_id', item_id = '$item_id' , item_name = '$item_name' ,  quantity = '$quantity', item_type = '$item_type', max_bid='$max_bid', max_house_or_buynow='$max_house_or_buynow' WHERE info_xml = '$info_xml'");
        $result = mysql_query($query);
    }
    $query = "(SELECT * FROM auction_items WHERE item_id ='$item_id' AND auction_id='$auction_id' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;


}


if ($tableUpdate == "loadBuyersList") {

    $query = "(SELECT * FROM auction_items WHERE auction_id ='$auction_id' && item_id ='$item_id' ORDER BY item_id ASC LIMIT 1)";
    $result = mysql_query($query);

    $row0 = mysql_fetch_assoc($result);
    $currBidder = $row0 ['bidder_id'];

    if ($currBidder == null || $currBidder == "") {
        $query = ("UPDATE auction_items SET seller_id = '$seller_id',  auction_id ='$auction_id', item_id = '$item_id' , item_name = '$item_name' ,  quantity = '$quantity', item_type = '$item_type', start_bid= '$start_bid', max_bid='$max_bid', max_house_or_buynow='$max_house_or_buynow' WHERE info_xml = '$info_xml'");
        $result = mysql_query($query);
    } else {
        $query = ("UPDATE auction_items SET seller_id = '$seller_id',  auction_id ='$auction_id', item_id = '$item_id' , item_name = '$item_name' ,  quantity = '$quantity', item_type = '$item_type', max_bid='$max_bid', max_house_or_buynow='$max_house_or_buynow' WHERE info_xml = '$info_xml'");
        $result = mysql_query($query);
    }
    $query = "(SELECT * FROM auction_items WHERE item_id ='$item_id' AND auction_id='$auction_id' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemId>" . $row['item_id'] . "</itemId>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<sellerId>" . $row['seller_id'] . "</sellerId>\n";
        $xml_output .= "\t\t<itemName>" . $row['item_name'] . "</itemName>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t\t<category>" . $row['item_type'] . "</category>\n";
        $xml_output .= "\t\t<start_bid>" . $row['start_bid'] . "</start_bid>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<currentBid>" . $row['current_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidType>" . $row['bidder_type'] . "</currBidType>\n";
        $xml_output .= "\t<image " . "file=" . "\"" . $row['thumb_image'] . "\"" . "/>";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;


}


if ($tableUpdate == "loadSoldByBuyer") {
    $query = "(SELECT DISTINCT bidder_id, sum(start_bid) as item_total, count(bidder_id) as item_count FROM auction_items WHERE bidder_type = 'Bidder' AND start_bid >= max_bid AND auction_id='$auction_id' group by bidder_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<buyerID>" . $row['bidder_id'] . "</buyerID>\n";
        $xml_output .= "\t\t<buyerItemTotal>" . $row['item_total'] . "</buyerItemTotal>\n";
        $xml_output .= "\t\t<buyerCount>" . $row['item_count'] . "</buyerCount>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}

if ($tableUpdate == "loadSoldBySeller") {
    $query = "(SELECT DISTINCT seller_id, sum(IF( (start_bid >= max_bid), start_bid, 0) ) as item_total, count(seller_id) as item_count FROM auction_items WHERE auction_id='$auction_id' group by seller_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<sellerID>" . $row['seller_id'] . "</sellerID>\n";
        $xml_output .= "\t\t<sellerItemTotal>" . $row['item_total'] . "</sellerItemTotal>\n";
        $xml_output .= "\t\t<sellerCount>" . $row['item_count'] . "</sellerCount>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}

if ($tableUpdate == "loadSoldByAuction") {
    $query = "(SELECT DISTINCT auction_id, sum(IF( (start_bid >= max_bid), start_bid, 0) ) as item_total, count(auction_id) as item_count FROM auction_items WHERE auction_id='$auction_id' group by auction_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<auctionID>" . $row['auction_id'] . "</auctionID>\n";
        $xml_output .= "\t\t<auctionItemTotal>" . $row['item_total'] . "</auctionItemTotal>\n";
        $xml_output .= "\t\t<auctionCount>" . $row['item_count'] . "</auctionCount>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output
        .= "\t</items>\n";

    echo $xml_output;

}

if ($tableUpdate == "Save") {

    $query = ("UPDATE auction_items SET thumb_image = '$item_thumbnail' WHERE info_xml = '$info_xml'");
    $result = mysql_query($query);

    $fileXML = str_replace("\n", "\r\n", $fileXML);
    $fileXML = str_replace("\r\r\n", "\r\n", $fileXML);
    $fileXML = stripslashes($fileXML);

    $fh = fopen($info_xml, 'w') or die("can't open file");
    fwrite($fh, $fileXML);
    fclose($fh);
    chmod($info_xml, 0755);

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>Item Saved</xml>\n";

    echo $xml_output;

}


if ($tableUpdate == "Delete") {


    $query = ("DELETE FROM auction_items WHERE item_id ='$item_id' AND auction_id='$auction_id'");
    $result = mysql_query($query);


    $query = ("DELETE FROM item_bidtracker WHERE item_id ='$item_id' AND auction_id='$auction_id'");
    $result = mysql_query($query);


    if ($target_path != "") {
        $path = $_SERVER['DOCUMENT_ROOT'];
        $path = $path . "/" . $target_path;
        chmod($path, 0755);
        rm_recursive($target_path);

    }


    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>delete ok</xml>";

    echo $xml_output;

}


mysql_close($con);
?>