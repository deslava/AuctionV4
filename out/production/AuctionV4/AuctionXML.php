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

if (!$con) {
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>Error</xml>";
    die($xml_output);
}

mysql_select_db($db_name) or die("Unable to select database");

$auctionId = $_POST['auctionId'];
$auctionName = $_POST['auctionName'];
$auctionCategory = $_POST['auctionCategory'];
$userId = $_POST['userId'];
$auctionView = $_POST['auctionView'];
$auctionStatus = $_POST['auctionStatus'];
$auctionEndTime = $_POST['endTime'];
$auctionIsoTime = $_POST['isoTime'];
$auctionState = $_POST['auctionState'];
$auctionXML = $_POST['auctionXML'];
$target_path = $_POST['path'];


$data1 = $_POST['data1'];
$data2 = $_POST['data2'];

$fileXML = $_POST['fileXML'];

$compareVar = $_POST['searchVar'];
$tableUpdate = $_POST['table1'];

$avail_num = 0;
$last = 0;
$counter = 0;


if ($tableUpdate == "Add") {

    $strSQL = "SELECT auction_id FROM auction_lists ORDER BY auction_id ASC";
    $result = mysql_query($strSQL);

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);
        If ($counter >= 0) {
            If ($row['auction_id'] != $last + 1) {
                $avail_num = $last + 1;
                break;
            }
        }
        $last = $row['auction_id'];
        $counter++;
    }
    If (!$avail_num) {
        $avail_num = $last + 1;
    } // in case there are no gaps !!
    $auctionId = $avail_num;


    $target_path = "auctions/";
    $target_path = $target_path . $auctionId . "/";
    $auctionXML = $target_path . "auction.xml";
    $target_path2 = $target_path . "items/";
    $target_path3 = $target_path . "sellers/";
    $auctionItems = "";

    $query = ("INSERT INTO auction_lists (auction_id, auction_name, category, satallite_id, auction_status, auction_close_time, auction_close_isotime , auction_state, auction_xml, items_xml , path, auction_ip_count ) VALUES ('$auctionId', '$auctionName', '$auctionCategory', '$userId', '$auctionStatus', '$auctionEndTime', '$auctionIsoTime', '$auctionState', '$auctionXML', '$auctionItems', '$target_path', '0')");
    $result = mysql_query($query);


    if (!file_exists($target_path2)) {
        $oldumask = umask(0);
        $rs = mkdir($target_path2, 0755, true);
        umask($oldumask);
    }

    if (!file_exists($target_path3)) {
        $oldumask = umask(0);
        $rs = mkdir($target_path3, 0755, true);
        umask($oldumask);
    }

    $query = "(SELECT * FROM auction_lists WHERE auction_id ='$auctionId' ORDER BY auction_id ASC)";
    $result = mysql_query($query);

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<auctions>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<auctionDB" . " status=" . "\"" . "File Saved" . "\"" . ">\n";
        $xml_output .= "\t\t<id>" . $row['auction_id'] . "</id>\n";
        $xml_output .= "\t\t<name>" . $row['auction_name'] . "</name>\n";
        $xml_output .= "\t\t<auctionCategory>" . $row['category'] . "</auctionCategory>\n";
        $xml_output .= "\t\t<ipCount>" . $row['auction_ip_count'] . "</ipCount>\n";
        $xml_output .= "\t\t<sataliteID>" . $row['satallite_id'] . "</sataliteID>\n";
        $xml_output .= "\t\t<auctionState>" . $row['auction_state'] . "</auctionState>\n";
        $xml_output .= "\t\t<auctionXML>" . $row['auction_xml'] . "</auctionXML>\n";
        $xml_output .= "\t\t<itemsXML>" . $row['items_xml'] . "</itemsXML>\n";
        $xml_output .= "\t\t<auctionView>" . $row['auction_view'] . "</auctionView>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<status>" . $row['auction_status'] . "</status>\n";
        $xml_output .= "\t\t<isoTime>" . $row['auction_close_isotime'] . "</isoTime>\n";
        $xml_output .= "\t</auctionDB>\n";

    }

    $xml_output .= "\t</auctions>\n";
    echo $xml_output;

}

////////////////////////////////////////////////////////////////////////////////////////

if ($tableUpdate == "Update") {

    $query = ("UPDATE auction_lists SET auction_name = '$auctionName',  category = '$auctionCategory', auction_status = '$auctionStatus' , auction_close_time = '$auctionEndTime', auction_close_isotime = '$auctionIsoTime',  auction_state = '$auctionState', auction_view = '$auctionView' WHERE auction_id = '$auctionId'");
    $result = mysql_query($query);


    $query = ("UPDATE auction_items SET close_time = '$auctionIsoTime' WHERE auction_id = '$auctionId'");
    $result = mysql_query($query);


    $query = "(SELECT * FROM auction_lists WHERE auction_id ='$auctionId' ORDER BY auction_id ASC)";
    $result = mysql_query($query);

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<auctions>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<auctionDB" . " status=" . "\"" . "Auction Saved" . "\"" . ">\n";
        $xml_output .= "\t\t<id>" . $row['auction_id'] . "</id>\n";
        $xml_output .= "\t\t<name>" . $row['auction_name'] . "</name>\n";
        $xml_output .= "\t\t<auctionCategory>" . $row['category'] . "</auctionCategory>\n";
        $xml_output .= "\t\t<ipCount>" . $row['auction_ip_count'] . "</ipCount>\n";
        $xml_output .= "\t\t<sataliteID>" . $row['satallite_id'] . "</sataliteID>\n";
        $xml_output .= "\t\t<auctionState>" . $row['auction_state'] . "</auctionState>\n";
        $xml_output .= "\t\t<auctionXML>" . $row['auction_xml'] . "</auctionXML>\n";
        $xml_output .= "\t\t<itemsXML>" . $row['items_xml'] . "</itemsXML>\n";
        $xml_output .= "\t\t<auctionView>" . $row['auction_view'] . "</auctionView>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<status>" . $row['auction_status'] . "</status>\n";
        $xml_output .= "\t\t<isoTime>" . $row['auction_close_isotime'] . "</isoTime>\n";
        $xml_output .= "\t</auctionDB>\n";

    }

    $xml_output .= "\t</auctions>\n";
    echo $xml_output;
}

////////////////////////////////////////////////////////////////////////////////////////

if ($tableUpdate == "Save") {

    $query = "(SELECT * FROM auction_lists)";
    $result = mysql_query($query);

    $fileXML = str_replace("\n", "\r\n", $fileXML);
    $fileXML = str_replace("\r\r\n", "\r\n", $fileXML);
    $fileXML = stripslashes($fileXML);

    $mode = 0755;
    if (!file_exists($target_path)) {
        $oldumask = umask(0);
        chmod($target_path, octdec($mode));
        $rs = mkdir($target_path, 0755, true);
        umask($oldumask);
    }

    $fh = fopen($auctionXML, 'w') or die("can't open file");
    fwrite($fh, $fileXML);
    fclose($fh);
    chmod($auctionXML, 0755);

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>Auction Saved</xml>\n";

    echo $xml_output;
}

////////////////////////////////////////////////////////////////////////////////////////

if ($tableUpdate == "Load") {

    $query = "(SELECT * FROM auction_lists WHERE auction_id ='$compareVar' ORDER BY auction_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<auctions>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<auctionDB>\n";
        $xml_output .= "\t\t<id>" . $row['auction_id'] . "</id>\n";
        $xml_output .= "\t\t<name>" . $row['auction_name'] . "</name>\n";
        $xml_output .= "\t\t<auctionCategory>" . $row['category'] . "</auctionCategory>\n";
        $xml_output .= "\t\t<ipCount>" . $row['auction_ip_count'] . "</ipCount>\n";
        $xml_output .= "\t\t<sataliteID>" . $row['satallite_id'] . "</sataliteID>\n";
        $xml_output .= "\t\t<auctionState>" . $row['auction_state'] . "</auctionState>\n";
        $xml_output .= "\t\t<auctionXML>" . $row['auction_xml'] . "</auctionXML>\n";
        $xml_output .= "\t\t<itemsXML>" . $row['items_xml'] . "</itemsXML>\n";
        $xml_output .= "\t\t<auctionView>" . $row['auction_view'] . "</auctionView>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<status>" . $row['auction_status'] . "</status>\n";
        $xml_output .= "\t\t<isoTime>" . $row['auction_close_isotime'] . "</isoTime>\n";
        $xml_output .= "\t</auctionDB>\n";

    }

    $xml_output .= "\t</auctions>\n";

    echo $xml_output;

}


if ($tableUpdate == "LoadAll") {

    if ($compareVar == "") {
        $query = "(SELECT * FROM auction_lists ORDER BY auction_id ASC)";
    } else {
        $query = "(SELECT * FROM auction_lists WHERE satallite_id ='$compareVar' ORDER BY auction_id ASC)";
    }

    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<auctions>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<auctionDB>\n";
        $xml_output .= "\t\t<id>" . $row['auction_id'] . "</id>\n";
        $xml_output .= "\t\t<name>" . $row['auction_name'] . "</name>\n";
        $xml_output .= "\t\t<auctionCategory>" . $row['category'] . "</auctionCategory>\n";
        $xml_output .= "\t\t<ipCount>" . $row['auction_ip_count'] . "</ipCount>\n";
        $xml_output .= "\t\t<sataliteID>" . $row['satallite_id'] . "</sataliteID>\n";
        $xml_output .= "\t\t<auctionState>" . $row['auction_state'] . "</auctionState>\n";
        $xml_output .= "\t\t<auctionXML>" . $row['auction_xml'] . "</auctionXML>\n";
        $xml_output .= "\t\t<itemsXML>" . $row['items_xml'] . "</itemsXML>\n";
        $xml_output .= "\t\t<auctionView>" . $row['auction_view'] . "</auctionView>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<status>" . $row['auction_status'] . "</status>\n";
        $xml_output .= "\t\t<isoTime>" . $row['auction_close_isotime'] . "</isoTime>\n";
        $xml_output .= "\t</auctionDB>\n";

    }
    $xml_output .= "\t</auctions>\n";

    echo $xml_output;
}

if ($tableUpdate == "LoadActive") {


}


if ($tableUpdate == "Delete") {

    $query = ("DELETE FROM auction_lists WHERE auction_id = '$compareVar'");
    $result = mysql_query($query);


    $query = ("DELETE FROM auction_items WHERE auction_id = '$compareVar'");
    $result = mysql_query($query);


    $query = ("DELETE FROM ids_seller WHERE auction_id = '$compareVar'");
    $result = mysql_query($query);


    $query = ("DELETE FROM auction_private WHERE auction_id = '$compareVar'");
    $result = mysql_query($query);


    $query = ("DELETE FROM item_bidtracker WHERE auction_id = '$compareVar'");
    $result = mysql_query($query);


//		$mode = 0755;		   
//		if($target_path!="")   
//		{
//			$oldumask = umask(0); 
//			$path = $_SERVER['DOCUMENT_ROOT'];
//			$path = $path . "/" . $target_path;
//		 	chmod($path, octdec($mode)); 
//		 	rm_recursive($target_path );
//		 	umask($oldumask);
//		}

    if ($target_path != "") {
        $path = $_SERVER['DOCUMENT_ROOT'];
        $path = $path . "/" . $target_path;
        rm_recursive($target_path);
    }

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>Delete OK</xml>\n";

    echo $xml_output;

}


if ($tableUpdate == "activateAuction") {

    $query = ("UPDATE auction_lists SET auction_status = '$auctionStatus' WHERE auction_id = '$compareVar'");
    $result = mysql_query($query);

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>Auction Active</xml>\n";

    echo $xml_output;
}


?>