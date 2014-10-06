<?php

include 'serverConfig.php';
$con = mysql_connect($db_host, $db_user, $db_pwd);
mysql_select_db($db_name) or die("Unable to select database");

$username = $_POST['username'];
$password = $_POST['password'];
$userEmail = $_POST['userEmail'];
$userState = $_POST['userState'];
$userType = $_POST['userType'];
$userStatus = $_POST['userStatus'];
$userCreator = $_POST['userCreator'];
$userCreatorID = $_POST['userCreatorID'];
$userActiveCode = $_POST['activeCode'];

$userFullName = $_POST['userFullName'];
$userAddress = $_POST['userAddress'];
$userZipcode = $_POST['userZipcode'];
$userPhone = $_POST['userPhone'];
$userCell = $_POST['userCell'];
$userCc1 = $_POST['cc1'];
$userccNum = $_POST['ccNum'];
$userMmcc = $_POST['mmcc'];
$userYycc = $_POST['yycc'];
$userCsc = $_POST['csc'];

$userRegister = $_POST['userRegister'];

$avail_num = 0;
$last = 1000;
$counter = 0;
$userId = 0;


if ($userRegister == "Register") {
    if ($userEmail != "House") {
        $query = "SELECT * FROM users WHERE email ='$userEmail'";
        $result = mysql_fetch_array(mysql_query($query));
    } else {
        $result = false;
    }

    if (!$result) {


        $strSQL = "SELECT user_id FROM users ORDER BY user_id ASC";
        $result = mysql_query($strSQL);
        $rowCount = mysql_num_rows($result);


        for ($x = 0; $x < $rowCount; $x++) {
            $row = mysql_fetch_assoc($result);

            if ($last < $row['user_id'] && $avail_num < $row['user_id']) {
                $avail_num = $last + 1;
                break;
            }

            $last = $row['user_id'];
            $avail_num = $last + 1;
        }
        If (!$avail_num) {
            $avail_num = $last + 1;
        } // in case there are no gaps !!
        $userId = $avail_num;


        $target_path = "users/";
        $target_path = $target_path . $userEmail . "/";
        $target_path2 = "userInfo.xml";


        $query = ("INSERT INTO users (user_id, name, email,  user_password,  activate_code, user_type, user_status, path, user_xml, user_state, user_creator, user_creator_id ) VALUES ('$userId', '$username', '$userEmail', '$password', '$userActiveCode', '$userType', '$userStatus', '$target_path', '$target_path2', '$userState', '$userCreator', '$userCreatorID' )");
        $result = mysql_query($query);


        if (!file_exists($target_path2)) {
            $oldumask = umask(0);
            $rs = mkdir($target_path2, 0755, true);
            umask($oldumask);
        }


        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml " . "id=" . "\"" . $userId . "\"" . ">" . "ok" . "</xml>\n";
        echo $xml_output;

    } else {

        $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
        $xml_output .= "\t<xml>error</xml>";

        echo $xml_output;

    }

} else if ($userRegister == "Verify") {
    $query = "SELECT * FROM users WHERE  user_id='$username'";
    $result = mysql_query($query);

    if ($result) {

        $row = mysql_fetch_assoc($result);
        $verifyCode = $row['activate_code'];

        if ($userActiveCode == $verifyCode) {

            $query = ("UPDATE users SET user_status= 'Active'  WHERE user_id ='$username'");
            $result = mysql_query($query);


            $query = ("INSERT INTO user_info (user_id, user_fullname, user_address, user_zipcode,  user_phone ) VALUES ('$username', '$userFullName', '$userAddress', '$userZipcode', '$userPhone')");
            $result = mysql_query($query);

            $query = ("INSERT INTO user_cc (user_id, cc_type, cc,  mm, yy,  csc ) VALUES ('$username', '$userCc1', '$userccNum', '$userMmcc', '$userYycc', '$userCsc')");
            $result = mysql_query($query);

            $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
            $xml_output .= "\t<xml>ok</xml>";

            echo $xml_output;
        } else {
            $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
            $xml_output .= "\t<xml>error</xml>";

            echo $xml_output;
        }
    }

}


mysql_close($con);

?>
