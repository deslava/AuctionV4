<?php
include 'serverConfig.php';
session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");


$con = mysql_connect($db_host, $db_user, $db_pwd);
mysql_select_db($db_name) or die("Unable to select database");


$userSearch = $_POST['userSearch'];
$userType = $_POST['userType'];
$compareVar = $_POST['searchVar'];


if ($userSearch == "AllUsers" && $userType == "Admin") {
    $query = "(SELECT * FROM users ORDER BY user_id ASC)";
    $result = mysql_query($query);

} else if ($userSearch == "userId" && $userType == "Admin") {
    $query = "(SELECT * FROM users WHERE user_id = '$compareVar' ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userEmail" && $userType == "Admin") {
    $query = "(SELECT * FROM users WHERE email = '$compareVar' ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userName" && $userType == "Admin") {
    $query = "(SELECT * FROM users WHERE name = '$compareVar' ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userType" && $userType == "Admin") {
    $query = "(SELECT * FROM users WHERE user_type = '$compareVar' ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userStatus" && $userType == "Admin") {
    $query = "(SELECT * FROM users WHERE user_status = '$compareVar' ORDER BY user_id ASC)";
    $result = mysql_query($query);
}

if ($userSearch == "AllUsers" && $userType == "Satellite") {
    $query = "(SELECT * FROM users WHERE user_type != 'Admin' && user_type != 'Satellite' ORDER BY user_id ASC)";
    $result = mysql_query($query);

} else if ($userSearch == "userId" && $userType == "Satellite") {
    $query = "(SELECT * FROM users WHERE user_id = '$compareVar' && user_type != 'Admin' && user_type != 'Satellite' ORDER BY user_id ASC )";
    $result = mysql_query($query);
} else if ($userSearch == "userEmail" && $userType == "Satellite") {
    $query = "(SELECT * FROM users WHERE email = '$compareVar' && user_type != 'Admin' && user_type != 'Satellite' ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userName" && $userType == "Satellite") {
    $query = "(SELECT * FROM users WHERE name = '$compareVar' && user_type != 'Admin' && user_type != 'Satellite' ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userType" && $userType == "Satellite") {
    $query = "(SELECT * FROM users WHERE user_type = '$compareVar' && user_type != 'Admin' && user_type != 'Satellite' ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userStatus" && $userType == "Satellite") {
    $query = "(SELECT * FROM users WHERE user_status = '$compareVar' && user_type != 'Admin' && user_type != 'Satellite' ORDER BY user_id ASC)";
    $result = mysql_query($query);
}


if ($userSearch == "HouseNumbers" && $userType == "Admin") {
    $query = "(SELECT * FROM users WHERE user_type = 'House' ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "HouseNumbers" && $userType == "Satellite") {
    $query = "(SELECT * FROM users WHERE user_type = 'House' && user_creator_id = '$compareVar' ORDER BY user_id ASC)";
    $result = mysql_query($query);
}

if ($userSearch == "AllUsers" && $userType == "privateBid") {
    $query = "(SELECT * FROM users WHERE user_type = 'Bidder' OR user_type = 'House'  ORDER BY user_id ASC)";
    $result = mysql_query($query);

} else if ($userSearch == "userId" && $userType == "privateBid") {
    $query = "(SELECT * FROM users WHERE user_id = '$compareVar' AND  (user_type = 'Bidder' OR user_type = 'House') ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userEmail" && $userType == "privateBid") {
    $query = "(SELECT * FROM users WHERE email = '$compareVar' AND  (user_type = 'Bidder' OR user_type = 'House') ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userName" && $userType == "privateBid") {
    $query = "(SELECT * FROM users WHERE name = '$compareVar' AND  (user_type = 'Bidder' OR user_type = 'House') ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userType" && $userType == "privateBid") {
    $query = "(SELECT * FROM users WHERE user_type = '$compareVar' AND  (user_type = 'Bidder' OR user_type = 'House') ORDER BY user_id ASC)";
    $result = mysql_query($query);
} else if ($userSearch == "userStatus" && $userType == "privateBid") {
    $query = "(SELECT * FROM users WHERE user_status = '$compareVar' AND  (user_type = 'Bidder' OR user_type = 'House') ORDER BY user_id ASC)";
    $result = mysql_query($query);
}


//start outputting the XML
$xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
$xml_output .= "\t<users>\n";

for ($x = 0; $x < mysql_num_rows($result); $x++) {
    $row = mysql_fetch_assoc($result);

    $xml_output .= "\t<user>\n";
    $xml_output .= "\t\t<userId>" . $row['user_id'] . "</userId>\n";
    $xml_output .= "\t\t<userPass>" . $row['user_password'] . "</userPass>\n";
    $xml_output .= "\t\t<userName>" . $row['name'] . "</userName>\n";
    $xml_output .= "\t\t<userEmail>" . $row['email'] . "</userEmail>\n";
    $xml_output .= "\t\t<userType>" . $row['user_type'] . "</userType>\n";
    $xml_output .= "\t\t<userStatus>" . $row['user_status'] . "</userStatus>\n";
    $xml_output .= "\t\t<userPath>" . $row['path'] . "</userPath>\n";
    $xml_output .= "\t\t<userState>" . $row['user_state'] . "</userState>\n";
    $xml_output .= "\t\t<userCreator>" . $row['user_creator'] . "</userCreator>\n";
    $xml_output .= "\t\t<userCreatorID>" . $row['user_creator_id'] . "</userCreatorID>\n";
    $xml_output .= "\t</user>\n";
}

$xml_output .= "\t</users>\n";

echo $xml_output;

mysql_close($con);

?>

