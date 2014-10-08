<?php
include 'serverConfig.php';

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");
clearstatcache();

$con = mysql_connect($db_host, $db_user, $db_pwd);
mysql_select_db($db_name) or die("Unable to select database");

$auction_id = $_POST ['auctionID'];
$item_id = $_POST ['itemID'];
$user_id = $_POST ['userID'];


$user_bid = 0;
$user_maxBid = 0;
$user_bidIncrement = 0;

$extend_time = 0;
$curr_time = 0; //current time of bid
$curr_time_extend = 0; //required for extend time if needed
$update_time = 0;

$user_Admintype = ""; //user type house or admin


$user_bid = $_POST ['userCurrBid'];
$user_maxBid = $_POST ['userMaxBid'];
$user_bidIncrement = $_POST ['userBidIncrement'];
$user_state = $_POST ['userState'];
$extend_time = $_POST['extendtime'];
$user_Admintype = $_POST['userType'];

$currHighestBid = 0;
$currHighestBidId = 0;
$currHighestBidIdState = "";
$currHighestBidIdType = "";

$currHighestMaxBid = 0;
$currHighestMaxBidId = 0;
$currHighestMaxBidIdState = "";
$currHighestMaxBidIdType = "";

$timeIncrease = 0;


$nextrequiredBid = 0;

$tempVariable = 0;

$compareVar = $_POST ['searchVar']; // what is the compare value we are looking for
$tableUpdate = $_POST ['table1']; // what function are we going to run

$rowCount = 0;

if ($tableUpdate == "currentItemTopBid") {

    $query0 = "(SELECT * FROM auction_items WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY item_id DESC LIMIT 1)";
    $result0 = mysql_query($query0);

    $bidQuery = "(SELECT * FROM item_bidtracker WHERE item_id ='$item_id' AND auction_id='$auction_id' AND user_currbid !='' ORDER BY user_currbid ASC)";
    $resultQuery = mysql_query($bidQuery);
    $rowCount = mysql_num_rows($resultQuery);

    $query1 = "(SELECT * FROM item_bidtracker WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY user_maxbid DESC LIMIT 1)";
    $result1 = mysql_query($query1);
    $maxBidder1 = mysql_fetch_assoc($result1);

    $currHighestMaxBid = $maxBidder1 ['user_maxbid'];
    $currHighestMaxBidId = $maxBidder1 ['user_id'];
    $currHighestBidIdType = $maxBidder1['user_type'];


    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result0); $x++) {
        $row = mysql_fetch_assoc($result0);
        $curr_time = $row['close_time'];
        $curr_time_extend = $row['close_time_extend'];

        $curr_time = $curr_time + $curr_time_extend;

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<itemBidCount>" . $rowCount . "</itemBidCount>\n";
        $xml_output .= "\t\t<currentBid>" . $row['start_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidState>" . $row['bidder_state'] . "</currBidState>\n";
        $xml_output .= "\t\t<currBidMax>" . $currHighestMaxBid . "</currBidMax>\n";
        $xml_output .= "\t\t<currBidMaxUserID>" . $currHighestMaxBidId . "</currBidMaxUserID>\n";
        $xml_output .= "\t\t<currBidType>" . $currHighestBidIdType . "</currBidType>\n";
        $xml_output .= "\t\t<max_bid>" . $row['max_bid'] . "</max_bid>\n";
        $xml_output .= "\t\t<isoTime>" . $curr_time . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;


}

if ($tableUpdate == "bidHistory") {

    $bidQuery = "(SELECT * FROM item_bidtracker WHERE item_id ='$item_id' AND auction_id='$auction_id' AND user_currbid !='' ORDER BY user_currbid DESC)";
    $resultQuery = mysql_query($bidQuery);


    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($resultQuery); $x++) {
        $row = mysql_fetch_assoc($resultQuery);

        $xml_output .= "\t<item>\n";
        $xml_output .= "\t\t<userID>" . $row['user_id'] . "</userID>\n";
        $xml_output .= "\t\t<currentBid>" . $row['user_currbid'] . "</currentBid>\n";
        $xml_output .= "\t\t<currBidState>" . $row['bidder_state'] . "</currBidState>\n";
        $xml_output .= "\t\t<currBidTime>" . $row['time'] . "</currBidTime>\n";
        $xml_output .= "\t\t<currBidType>" . $row['user_type'] . "</currBidType>\n";
        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}
//regular Bid
if ($tableUpdate == "Bid") {

    //search for the last bid in the auction and item selected
    $query0 = "(SELECT * FROM auction_items WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY start_bid DESC  LIMIT 1)";
    $result0 = mysql_query($query0);
    $row0 = mysql_fetch_assoc($result0);
    $currDisplayedBid = $row0 ['start_bid']; //current last bid
    $curr_time = $row0['close_time']; // current time of bid
    $curr_time_extend = $row0['close_time_extend']; //is it in extended time?

    $update_time = $curr_time_extend + $extend_time;
    //calculate new extended time if needed
    if ($extend_time == 0) {
        $query = ("UPDATE auction_items SET close_time_extend = '$update_time' WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
        $result = mysql_query($query);
    } else {

        $query = ("UPDATE auction_items SET close_time_extend = '$update_time' WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
        $result = mysql_query($query);
    }

    //look in the bids table to find if there is a current maxbid
    $query1 = "(SELECT * FROM item_bidtracker WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY user_currbid DESC LIMIT 1)";
    $result1 = mysql_query($query1);
    $maxBidder1 = mysql_fetch_assoc($result1);
    $currHighestBid = $maxBidder1['user_currbid']; //current max bid if any
    $currHighestBidIdType = $maxBidder1['user_type'];


    if ($currHighestBid == null)
        $currHighestBid = 0;

//look in the bids table to find the last bid who that user is and what the max bid is if there is any
    $query2 = "(SELECT * FROM item_bidtracker WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY user_maxbid DESC LIMIT 1)";
    $result2 = mysql_query($query2);
    $maxBidder2 = mysql_fetch_assoc($result2);
    $currHighestMaxBid = $maxBidder2['user_maxbid'];
    $currHighestMaxBidId = $maxBidder2['user_id'];
    $currHighestMaxBidIdState = $maxBidder2['bidder_state'];
    $currHighestMaxBidIdType = $maxBidder2['user_type'];


    if ($currHighestMaxBid == null) {
        $currHighestMaxBid = 0;
    }

//Checks to see if CurrentHighBid is larger than CurrentHighMaxBid if Greater Insert Bid		
    if ($currHighestBid >= $currHighestMaxBid && $user_bid > $currDisplayedBid) {

        $query = ("UPDATE auction_items SET start_bid= '$user_bid', bidder_id = '$user_id', bidder_state ='$user_state', bid_increment = '$user_bidIncrement', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
        $result = mysql_query($query);
        mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$user_bid', '$user_state', '$user_Admintype' )");


    } //if There is a CurrentHighMaxbid larger than CurrentHighBid if greater Do a check on who is highBidder ID
    else if ($currHighestBid < $currHighestMaxBid && $user_bid > $currDisplayedBid) {

        if ($currHighestMaxBidId == $user_id) {
            //if the user max is equal, insert bid
            $query = ("UPDATE auction_items SET start_bid= '$user_bid', bidder_id = '$user_id', bidder_state ='$user_state', bid_increment = '$user_bidIncrement', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
            $result = mysql_query($query);
            mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$user_bid', '$user_state', '$user_Admintype' )");

        } // if( $currHighestMaxBidId == $user_id)

        else if ($currHighestMaxBidId != $user_id) {

            if ($currHighestMaxBid > $user_bid) {

                $query = ("UPDATE auction_items SET start_bid= '$user_bid', bidder_id = '$user_id', bidder_state ='$user_state', bid_increment = '$user_bidIncrement', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                $result = mysql_query($query);
                mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$user_bid', '$user_state', '$user_Admintype' )");

                $tempCalc = $user_bid + $user_bidIncrement;
                if ($tempCalc > $currHighestMaxBid) {
                    $tempCalc = $currHighestMaxBid;
                }

                $query = ("UPDATE auction_items SET start_bid= '$tempCalc', bidder_id = '$currHighestMaxBidId', bid_increment = '$user_bidIncrement',  bidder_state ='$currHighestMaxBidIdState', bidder_type = '$currHighestMaxBidIdType'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                $result = mysql_query($query);
                mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid,user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$currHighestMaxBidId', '$tempCalc', '$currHighestMaxBid', '$currHighestMaxBidIdState', '$currHighestMaxBidIdType' )");

            } //if($currHighestMaxBid > $user_bid)
            else if ($currHighestMaxBid == $user_bid) {
                //insert usersbid one under the maxbid
                $tempCalc = $currHighestMaxBid - $user_bidIncrement;

                $query = ("UPDATE auction_items SET start_bid= '$tempCalc', bidder_id = '$user_id', bidder_state ='$user_state', bid_increment = '$user_bidIncrement', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                $result = mysql_query($query);
                mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$tempCalc', '$user_state', '$user_Admintype' )");

                //insert max users final max bid
                $query = ("UPDATE auction_items SET start_bid= '$currHighestMaxBid', bidder_id = '$currHighestMaxBidId', bid_increment = '$user_bidIncrement',  bidder_state ='$currHighestMaxBidIdState', bidder_type = '$currHighestMaxBidIdType'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                $result = mysql_query($query);
                mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$currHighestMaxBidId', '$currHighestMaxBid', '$currHighestMaxBid', '$currHighestMaxBidIdState', '$currHighestMaxBidIdType' )");

            } //else if($currHighestMaxBid == $user_bid)
            else if ($currHighestMaxBid < $user_bid) {
                //insert the bid
                $query = ("UPDATE auction_items SET start_bid= '$user_bid', bidder_id = '$user_id', bidder_state ='$user_state', bid_increment = '$user_bidIncrement', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                $result = mysql_query($query);
                mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$user_bid', '$user_state', '$user_Admintype' )");

            }
            //else if($currHighestMaxBid < $user_bid)
        }
        // else if ($currHighestBid < $currHighestMaxBid && $user_bid > $currDisplayedBid)
    }
    //else if($currHighestBid < $currHighestMaxBid && $user_bid > $currDisplayedBid)


    //this gets the new latest bidder and maxbid and sends it back for use in the application.

    $query1 = "(SELECT * FROM item_bidtracker WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY user_maxbid DESC LIMIT 1)";
    $result1 = mysql_query($query1);
    $maxBidder1 = mysql_fetch_assoc($result1);

    $currHighestMaxBid = $maxBidder1 ['user_maxbid'];
    $currHighestMaxBidId = $maxBidder1 ['user_id'];
    $currHighestMaxBidIdType = $maxBidder1['user_type'];

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
        $xml_output .= "\t\t<currentBid>" . $row['start_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidMax>" . $currHighestMaxBid . "</currBidMax>\n";
        $xml_output .= "\t\t<currBidMaxUserID>" . $currHighestBidId . "</currBidMaxUserID>\n";
        $xml_output .= "\t\t<currBidMaxType>" . $currHighestBidIdType . "</currBidMaxType>\n";
        $xml_output .= "\t\t<isoTime>" . $row['close_time'] . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";

        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

} //MAX BID
else if ($tableUpdate == "MaxBid") {


    $query0 = "(SELECT * FROM auction_items WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY start_bid DESC  LIMIT 1)";
    $result0 = mysql_query($query0);
    $row0 = mysql_fetch_assoc($result0);
    $currDisplayedBid = $row0 ['start_bid'];
    $curr_time = $row0['close_time'];
    $curr_time_extend = $row0['close_time_extend'];

    $update_time = $curr_time_extend + $extend_time;

    if ($extend_time == 0) {
        $query = ("UPDATE auction_items SET close_time_extend = '$update_time' WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
        $result = mysql_query($query);
    } else {

        $query = ("UPDATE auction_items SET close_time_extend = '$update_time' WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
        $result = mysql_query($query);
    }

    $query1 = "(SELECT * FROM item_bidtracker WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY user_currbid DESC LIMIT 1)";
    $result1 = mysql_query($query1);
    $maxBidder1 = mysql_fetch_assoc($result1);
    $currHighestBid = $maxBidder1['user_currbid']; //500 $currHighestBid
    $currHighestBidId = $maxBidder1['user_id']; // 1002 $currHighestBidId
    $currHighestBidIdType = $maxBidder1['user_type'];

    if ($currHighestBid == null)
        $currHighestBid = 0;


    $query2 = "(SELECT * FROM item_bidtracker WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY user_maxbid DESC LIMIT 1)";
    $result2 = mysql_query($query2);
    $maxBidder2 = mysql_fetch_assoc($result2);
    $currHighestMaxBid = $maxBidder2['user_maxbid']; //500
    $currHighestMaxBidId = $maxBidder2['user_id']; //1002
    $currHighestMaxBidIdState = $maxBidder2['bidder_state'];
    $currHighestMaxBidIdType = $maxBidder2['user_type'];

    if ($currHighestMaxBid == null) {
        $currHighestMaxBid = 0;
        $currHighestMaxBidId = 0;
    }


    //300                500                300      105
    if ($user_maxBid > $currHighestBid && $user_maxBid > $currDisplayedBid) {
        //500             500
        if ($currHighestBid >= $currHighestMaxBid) { //1000         1002 FAIL
            if ($user_id == $currHighestBidId) {

                mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id, user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id' , '$user_maxBid', '$user_state', '$user_Admintype' )");
            } //1000         1002                  500
            else if ($user_id != $currHighestBidId || $currHighestBid == 0) {

                if ($currHighestBid == 0) {
                    $currHighestBid = $currDisplayedBid;
                }
                //   510             500            10
                $tempCalc = $currHighestBid + $user_bidIncrement;
                //510           300
                if ($tempCalc > $user_maxBid) {
                    $tempCalc = $user_maxBid;
                }

                $query = ("UPDATE auction_items SET start_bid= '$tempCalc', bidder_id = '$user_id', bid_increment = '$user_bidIncrement', bidder_state = '$user_state', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                $result = mysql_query($query);

                mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid,user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$tempCalc' , '$user_maxBid', '$user_state', '$user_Admintype' )");
            }
        } //
        else if ($currHighestBid < $currHighestMaxBid) {


            if ($user_id == $currHighestMaxBidId && $user_maxBid > $currHighestMaxBid) {
                mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id, user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id' , '$user_maxBid', '$user_state', '$user_Admintype' )");
            } else if ($user_id != $currHighestMaxBidId) {

                if ($user_maxBid > $currHighestMaxBid) {

                    $query = ("UPDATE auction_items SET start_bid= '$currHighestMaxBid', bidder_id = '$currHighestMaxBidId', bid_increment = '$user_bidIncrement',  bidder_state ='$currHighestMaxBidIdState', bidder_type = '$currHighestMaxBidIdType'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                    $result = mysql_query($query);
                    mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid,user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$currHighestMaxBidId', '$currHighestMaxBid', '$currHighestMaxBid', '$currHighestMaxBidIdState', '$currHighestMaxBidIdType' )");


                    $tempCalc = $currHighestMaxBid + $user_bidIncrement;

                    if ($tempCalc > $user_maxBid) {
                        $tempCalc = $user_maxBid;
                    }

                    $query = ("UPDATE auction_items SET start_bid= '$tempCalc', bidder_id = '$user_id', bid_increment = '$user_bidIncrement',  bidder_state ='$user_state', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                    $result = mysql_query($query);
                    mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid,user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$tempCalc', '$user_maxBid', '$user_state', '$user_Admintype' )");


                } else if ($user_maxBid < $currHighestMaxBid) {

                    $query = ("UPDATE auction_items SET start_bid= '$user_maxBid', bidder_id = '$user_id', bid_increment = '$user_bidIncrement',  bidder_state ='$user_state', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                    $result = mysql_query($query);
                    mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid,user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$user_maxBid', '$user_maxBid', '$user_state', '$user_Admintype' )");


                    $tempCalc = $user_maxBid + $user_bidIncrement;

                    if ($tempCalc > $currHighestMaxBid) {
                        $tempCalc = $currHighestMaxBid;
                    }

                    $query = ("UPDATE auction_items SET start_bid= '$tempCalc', bidder_id = '$currHighestMaxBidId', bid_increment = '$user_bidIncrement',  bidder_state ='$currHighestMaxBidIdState', bidder_type = '$currHighestMaxBidIdType'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                    $result = mysql_query($query);

                    mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid, user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$currHighestMaxBidId', '$tempCalc', '$currHighestMaxBid', '$currHighestMaxBidIdState', '$currHighestMaxBidIdType' )");


                } else if ($user_maxBid == $currHighestMaxBid) {
                    $tempCalc = $currHighestMaxBid - 1;

                    $query = ("UPDATE auction_items SET start_bid= '$tempCalc', bidder_id = '$user_id', bid_increment = '$user_bidIncrement',  bidder_state ='$user_state', bidder_type = '$user_Admintype'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                    $result = mysql_query($query);
                    mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid,user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$user_id', '$tempCalc', '$user_maxBid', '$user_state', '$user_Admintype' )");

                    $query = ("UPDATE auction_items SET start_bid= '$currHighestMaxBid', bidder_id = '$currHighestMaxBidId', bid_increment = '$user_bidIncrement',  bidder_state ='$currHighestMaxBidIdState', bidder_type = '$currHighestMaxBidIdType'  WHERE item_id ='$compareVar' AND auction_id='$auction_id'");
                    $result = mysql_query($query);
                    mysql_query("INSERT INTO item_bidtracker (auction_id,item_id,user_id,user_currbid,user_maxbid, bidder_state, user_type) VALUES ('$auction_id ', '$item_id', '$currHighestMaxBidId', '$currHighestMaxBid', '$currHighestMaxBid', '$currHighestMaxBidIdState', '$currHighestMaxBidIdType' )");

                }
            }
            //

        }

    }

    $query1 = "(SELECT * FROM item_bidtracker WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY user_maxbid DESC LIMIT 1)";
    $result1 = mysql_query($query1);
    $maxBidder1 = mysql_fetch_assoc($result1);

    $currHighestMaxBid = $maxBidder1 ['user_maxbid'];
    $currHighestMaxBidId = $maxBidder1 ['user_id'];
    $currHighestMaxBidIdType = $maxBidder1['user_type'];

    $query = "(SELECT * FROM auction_items WHERE item_id ='$compareVar' AND auction_id='$auction_id' ORDER BY item_id ASC)";
    $result = mysql_query($query);
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<items>\n";

    for ($x = 0; $x < mysql_num_rows($result); $x++) {
        $row = mysql_fetch_assoc($result);

        $curr_time = $row['close_time'];
        $curr_time_extend = $row['close_time_extend'];

        $curr_time = $curr_time + $curr_time_extend;

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
        $xml_output .= "\t\t<currentBid>" . $row['start_bid'] . "</currentBid>\n";
        $xml_output .= "\t\t<max_house_or_buynow>" . $row['max_bid'] . "</max_house_or_buynow>\n";
        $xml_output .= "\t\t<currBidWinner>" . $row['bidder_id'] . "</currBidWinner>\n";
        $xml_output .= "\t\t<currBidMax>" . $currHighestMaxBid . "</currBidMax>\n";
        $xml_output .= "\t\t<currBidMaxUserID>" . $currHighestMaxBidId . "</currBidMaxUserID>\n";
        $xml_output .= "\t\t<currBidMaxUserType>" . $currHighestMaxBidIdType . "</currBidMaxUserType>\n";
        $xml_output .= "\t\t<isoTime>" . $curr_time . "</isoTime>\n";
        $xml_output .= "\t\t<extendTime>" . $row['extend_time'] . "</extendTime>\n";

        $xml_output .= "\t</item>\n";

    }

    $xml_output .= "\t</items>\n";

    echo $xml_output;

}

?>