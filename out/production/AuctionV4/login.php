<?php
include 'serverConfig.php';

session_start();
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Content-type: text/xml");

$con = mysql_connect($db_host, $db_user, $db_pwd);
mysql_select_db($db_name) or die("Unable to select database");

$username = $_POST['username'];
$password = $_POST['password'];
$type = $_POST['type'];

if ($type == "id") {
    $query = "(SELECT * FROM users WHERE user_id='$username' AND user_password='$password')";
    $result = mysql_query($query);
} else if ($type == "email") {
    $query = "(SELECT * FROM users WHERE email='$username' AND user_password='$password')";
    $result = mysql_query($query);
}


//start outputting the XML
$xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
$xml_output .= "\t<user>\n";
for ($x = 0; $x < mysql_num_rows($result); $x++) {
    $row = mysql_fetch_assoc($result);


    $xml_output .= "\t\t<userId>" . $row['user_id'] . "</userId>\n";
    $xml_output .= "\t\t<userPass>" . $row['user_password'] . "</userPass>\n";
    $xml_output .= "\t\t<userName>" . $row['name'] . "</userName>\n";
    $xml_output .= "\t\t<userEmail>" . $row['email'] . "</userEmail>\n";
    $xml_output .= "\t\t<userType>" . $row['user_type'] . "</userType>\n";
    $xml_output .= "\t\t<userStatus>" . $row['user_status'] . "</userStatus>\n";
    $xml_output .= "\t\t<userPath>" . $row['path'] . "</userPath>\n";
    $xml_output .= "\t\t<userXML>" . $row['user_xml'] . "</userXML>\n";
    $xml_output .= "\t\t<userState>" . $row['user_state'] . "</userState>\n";
    $xml_output .= "\t\t<userCreator>" . $row['user_creator'] . "</userCreator>\n";
    $xml_output .= "\t\t<userActivateCode>" . $row['activate_code'] . "</userActivateCode>\n";

}
$xml_output .= "\t</user>\n";

echo $xml_output;

mysql_close($con);
?>