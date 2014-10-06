<?php
/*
 * Created on May 7, 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

$from = $_POST['email'];
//define the receiver of the email
$to = $_POST['emailF'];
//define the subject of the email
$subject = $_POST['subject'];

$headers = "From: " . $from;
$headers .= "\r\n";
$headers .= "Reply-To: " . $from;
$headers .= "\r\n";
$header_ = 'MIME-Version: 1.0' . "\r\n" . 'Content-type: text/plain; charset=UTF-8' . "\r\n";
//send the email
$message = $_POST['message'];
$message .= "\n";

$mail_sent = @mail($to, '=?UTF-8?B?' . base64_encode($subject) . '?=', $message, $header_ . $headers);
//if the message is sent successfully print "Mail sent". Otherwise print "Mail failed" 
$xml_output = "<?xml version='1.0' encoding='utf-8'?>\n";
$xml_output .= "\t<xml>ok</xml>";

echo $xml_output;

?>
