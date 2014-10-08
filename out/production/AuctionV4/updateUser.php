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

$username = $_POST['username'];
$password = $_POST['password'];
$userType = $_POST['userType'];
$userEmail = $_POST['userEmail'];
$userStatus = $_POST['userStatus'];
$userPath = $_POST['userPath'];
$userState = $_POST['userState'];
$userXML = $_POST['userXML'];
$userCreator = $_POST['userCreator'];
$userCreatorID = $_POST['userCreatorID'];
$userUpdateHouse = $_POST['updateHouse'];

$compareVar = $_POST['searchVar'];
$tableUpdate = $_POST['table1'];


if ($tableUpdate == "users") {

    if ($username != "") {
        $query = ("UPDATE users SET name='$username' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }
    if ($password != "") {

        $query = ("UPDATE users SET user_password='$password' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);

        if ($userType == "House" && $userUpdateHouse == "All") {
            mysql_query("UPDATE users SET user_password='$password' WHERE user_type='$userType' AND user_creator_id = '$userCreatorID' ");
            $result = mysql_query($query);
        }


    }
    if ($userType != "") {
        $query = ("UPDATE users SET user_type='$userType' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }
    if ($userEmail != "") {
        $query = ("UPDATE users SET email='$userEmail' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }
    if ($userStatus != "") {
        $query = ("UPDATE users SET user_status='$userStatus' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }
    if ($userPath != "") {
        $query = ("UPDATE users SET path='$userPath' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }

    if ($userState != "") {
        $query = ("UPDATE users SET user_state='$userState' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }

    if ($userXML != "") {
        $query = ("UPDATE users SET user_xml='$userXML' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }

    if ($userCreator != "") {
        $query = ("UPDATE users SET user_creator='$userCreator' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }

    if ($userCreatorID != "") {
        $query = ("UPDATE users SET user_creator_id='$userCreatorID' WHERE user_id = '$compareVar'");
        $result = mysql_query($query);
    }


    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>ok</xml>";

    echo $xml_output;


}

if ($tableUpdate == "userDelete") {
    $query = ("DELETE FROM users WHERE user_id = '$compareVar'");
    $result = mysql_query($query);

    if ($userPath != "") {
        chmod($userPath, 0755);
        rm_recursive($userPath);

    }

    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<xml>ok</xml>";

    echo $xml_output;
}


mysql_close($con);

?>