<?php

include 'serverConfig.php';

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");

$con = mysql_connect($db_host, $db_user, $db_pwd);

if (!$con) {
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>Error</xml>";
    die($xml_output);
}

mysql_select_db($db_name) or die("Unable to select database");


$auctionId = $_POST['auctionId'];
$sellerId = $_POST['sellerId'];
$sellerName = $_POST['sellerName'];
$sellerPass = $_POST['sellerPass'];
$sellerEmail = $_POST['sellerEmail'];
$sellerType = $_POST['sellerType'];
$sellerItemsSelling = $_POST['itemsSelling'];
$sellerPath = $_POST['path'];
$sellerXML = $_POST['sellerXML'];

$fileXML = $_POST['fileXML'];


$compareVar = $_POST['searchVar'];
$tableUpdate = $_POST['table1'];

$avail_num = 0;
$last = 0;
$counter = 0;

if ($tableUpdate == "Load") {

    $query = "(SELECT * FROM ids_seller WHERE auction_id ='$compareVar')";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<Sellers>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<Seller>\n";
        $xml_output .= "\t\t<dropDown" . " id=" . "\"" . $row['user_id'] . "\"" . ">" . $row['user_id'] . " - " . $row['email'] . " - " . $row['name'] . "</dropDown>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<userId>" . $row['user_id'] . "</userId>\n";
        $xml_output .= "\t\t<email>" . $row['email'] . "</email>\n";
        $xml_output .= "\t\t<userType>" . $row['user_type'] . "</userType>\n";
        $xml_output .= "\t\t<userName>" . $row['name'] . "</userName>\n";
        $xml_output .= "\t\t<items>" . $row['items_selling'] . "</items>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t</Seller>\n";

    }

    $xml_output .= "\t</Sellers>\n";

    echo $xml_output;

}


if ($tableUpdate == "Add") {

    $query = "SELECT * FROM ids_seller WHERE  email='$sellerEmail' AND auction_id = '$auctionId'";
    $result = mysql_fetch_array(mysql_query($query));

    if (!$result) {

        $strSQL = "SELECT user_id FROM ids_seller WHERE auction_id='$auctionId' ORDER BY user_id ASC";
        $result = mysql_query($strSQL);

        for ($x = 0; $x < mysql_num_rows($result); $x++) {
            $row = mysql_fetch_assoc($result);
            If ($counter > 0) {
                If ($row['user_id'] != $last + 1) {
                    $avail_num = $last + 1;
                    break;
                }
            }
            $last = $row['user_id'];
            $counter++;
        }
        If (!$avail_num) {
            $avail_num = $last + 1;
        } // in case there are no gaps !!

        $sellerId = $avail_num;

        $sellerXML = $sellerPath . $sellerId . ".xml";

        $query = ("INSERT INTO ids_seller (auction_id, user_id, user_password, email, user_type, name, items_selling, path, info_xml) VALUES ('$auctionId' , '$sellerId', '$sellerPass', '$sellerEmail', '$sellerType', '$sellerName', '$sellerItemsSelling', '$sellerPath', '$sellerXML' )");
        $result = mysql_query($query);


        $query = "(SELECT * FROM ids_seller WHERE auction_id ='$auctionId' && user_id = '$sellerId' )";
        $result = mysql_query($query);
        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<Sellers>\n";

        for ($x = 0; $x < mysql_num_rows($result); $x++) {
            $row = mysql_fetch_assoc($result);

            $xml_output .= "\t<Seller" . " status=" . "\"" . "File Saved" . "\"" . ">\n";
            $xml_output .= "\t\t<dropDown" . " id=" . "\"" . $row['user_id'] . "\"" . ">" . $row['user_id'] . " - " . $row['email'] . " - " . $row['name'] . "</dropDown>\n";
            $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
            $xml_output .= "\t\t<userId>" . $row['user_id'] . "</userId>\n";
            $xml_output .= "\t\t<email>" . $row['email'] . "</email>\n";
            $xml_output .= "\t\t<userType>" . $row['user_type'] . "</userType>\n";
            $xml_output .= "\t\t<userName>" . $row['name'] . "</userName>\n";
            $xml_output .= "\t\t<items>" . $row['items_selling'] . "</items>\n";
            $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
            $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
            $xml_output .= "\t</Seller>\n";

        }

        $xml_output .= "\t</Sellers>\n";

        echo $xml_output;

    } else {

        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>error</xml>";

        echo $xml_output;
    }
}

if ($tableUpdate == "Save") {

    $fileXML = str_replace("\n", "\r\n", $fileXML);
    $fileXML = str_replace("\r\r\n", "\r\n", $fileXML);
    $fileXML = stripslashes($fileXML);

    $fh = fopen($sellerXML, 'w') or die("can't open file");
    fwrite($fh, $fileXML);
    fclose($fh);
    chmod($sellerXML, 0755);

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml " . "url=" . "\"" . $sellerXML . "\"" . ">" . "Seller Saved" . "</xml>\n";

    echo $xml_output;
}

if ($tableUpdate == "Update") {

    $query = ("UPDATE ids_seller SET auction_id = '$auctionId',  user_id = '$sellerId', user_password = '$sellerPass' , email = '$sellerEmail' , user_type = '$sellerType', name = '$sellerName', items_selling = '$sellerItemsSelling', path = '$sellerPath', info_xml = '$sellerXML'  WHERE auction_id = '$auctionId' AND user_id = '$sellerId'");
    $result = mysql_query($query);


    $query = "(SELECT * FROM ids_seller WHERE auction_id ='$auctionId' && user_id = '$sellerId' )";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<Sellers>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $xml_output .= "\t<Seller" . " status=" . "\"" . "File Saved" . "\"" . ">\n";
        $xml_output .= "\t\t<dropDown" . " id=" . "\"" . $row['user_id'] . "\"" . ">" . $row['user_id'] . " - " . $row['email'] . " - " . $row['name'] . "</dropDown>\n";
        $xml_output .= "\t\t<auctionId>" . $row['auction_id'] . "</auctionId>\n";
        $xml_output .= "\t\t<userId>" . $row['user_id'] . "</userId>\n";
        $xml_output .= "\t\t<email>" . $row['email'] . "</email>\n";
        $xml_output .= "\t\t<userType>" . $row['user_type'] . "</userType>\n";
        $xml_output .= "\t\t<userName>" . $row['name'] . "</userName>\n";
        $xml_output .= "\t\t<items>" . $row['items_selling'] . "</items>\n";
        $xml_output .= "\t\t<path>" . $row['path'] . "</path>\n";
        $xml_output .= "\t\t<info_xml>" . $row['info_xml'] . "</info_xml>\n";
        $xml_output .= "\t</Seller>\n";

    }

    $xml_output .= "\t</Sellers>\n";

    echo $xml_output;

}


mysql_close($con);

?>