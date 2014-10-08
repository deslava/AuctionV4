<?php
$success = "false";

switch ($_REQUEST['action']) {
    case "upload":
        $file_temp = $_FILES['file']['tmp_name'];
        $file_name = $_FILES['file']['name'];
        $path = trim($_SERVER['SCRIPT_FILENAME'], "upload.php");
        $file_path = $path . $_REQUEST['strUploadFolder'];

        if (!file_exists($file_path . $file_name)) {
            $filestatus = move_uploaded_file($file_temp, $file_path . $file_name);
            if (!$filestatus) {
                $success = "false";
            } else {
                $success = "true";
            }

        } else {
            $filestatus = move_uploaded_file($file_temp, $file_path . $file_name);
            if (!$filestatus) {
                $success = "false";
            } else {
                $success = "true";
            }
        }
        break;
    default:
        $success = "false";
}


if ($success == "false") {
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<success>false</success>";
} else {
    $xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
    $xml_output .= "\t<success>true</success>";
}

?>