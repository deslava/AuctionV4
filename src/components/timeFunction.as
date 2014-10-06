import components.DrDredelDate;

import flash.events.TimerEvent;
import flash.utils.Timer;

protected var currentTime:Date;
protected var currentTimeString:String;

public function addLeadingZero(inD:Number):String {
    return ( inD >= 10) ? inD + "" : "0" + inD;
}

public function showCurrentTime():void {

    var myTimer:Timer = new Timer(1000);

    myTimer.addEventListener(TimerEvent.TIMER, runPerSecond);
    myTimer.start();

}

public function runPerSecond(event:TimerEvent):void {

    getUserTime();

}

public function getUserTime():void {

    currentTime = new Date();

    currentTimeString = getDateIso8601Long(currentTime);
    currentTimeString;


    var newFormatTime:DrDredelDate = new DrDredelDate(currentTimeString);
    var displayHourFormat:String = "HH";
    var displayMinuteAMFormat:String = "MM A";
    var displayAPMDYYYY:String = "mm/dd/yyyy";


    var currentHTimeString:String = newFormatTime.getFormattedDate(displayHourFormat);
    var currentMAMTimeString:String = newFormatTime.getFormattedDate(displayMinuteAMFormat);
    var currentAPMDYYYYTimeString:String = newFormatTime.getFormattedDate(displayAPMDYYYY);

    var timeZoneString:String = "GMT" + newFormatTime.timezoneOffset;
    timeZoneString = parseTimeZoneFromGMT(timeZoneString);

    currentTimeString = currentHTimeString + ":" + currentMAMTimeString + " " + timeZoneString + " " + currentAPMDYYYYTimeString;

}


public function getCurrentTime():String {

    return currentTimeString;
}


public static function getDateIso8601Long(date:Date):String {
    var str:String = date.getFullYear().toString();
    str = str + "-" + ((String((date.getMonth() + 1)).length == 1) ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1)).toString();
    str = str + "-" + ((date.getDate().toString().length == 1) ? "0" + date.getDate() : date.getDate()).toString();
    str = str + "T" + ((date.getHours().toString().length == 1) ? "0" + date.getHours() : date.getHours()).toString();
    str = str + ":" + ((date.getMinutes().toString().length == 1) ? "0" + date.getMinutes() : date.getMinutes()).toString();
    str = str + ":" + ((date.getSeconds().toString().length == 1) ? "0" + date.getSeconds() : date.getSeconds()).toString();
    /*var ms:String = date.getMilliseconds().toString()
     while (ms.length < 3)
     ms = "0"+ms
     str = str+"."+ms*/
    var offsetMinute:Number = date.getTimezoneOffset();
    var direction:Number = (offsetMinute < 0) ? 1 : -1;
    var offsetHour:Number = Math.floor(offsetMinute / 60);
    offsetMinute = offsetMinute - (offsetHour * 60);

    var offsetHourStr:String = offsetHour.toString();
    while (offsetHourStr.length < 2)
        offsetHourStr = "0" + offsetHourStr;
    var offsetMinuteStr:String = offsetMinute.toString();
    while (offsetMinuteStr.length < 2)
        offsetMinuteStr = "0" + offsetMinuteStr;
    str = str + ((direction == -1) ? "-" : "+") + offsetHourStr + ":" + offsetMinuteStr;
    return str

}


////////////////////////////////////////////////////////////////////////

/**
 * List of timezone abbreviations and matching GMT times.
 * Modified form original code at:
 * http://blog.flexexamples.com/2009/07/27/parsing-dates-with-timezones-in-flex/
 * */
private static var timeZoneAbbreviations:Array = [
    /* Hawaii-Aleutian Standard/Daylight Time */
    {abbr: "HAST", zone: "GMT-1000"},
    {abbr: "HADT", zone: "GMT-0900"},
    /* Alaska Standard/Daylight Time */
    {abbr: "AKST", zone: "GMT-0900"},
    {abbr: "ASDT", zone: "GMT-0800"},
    /* Pacific Standard/Daylight Time */
    {abbr: "PST", zone: "GMT-0800"},
    {abbr: "PDT", zone: "GMT-0700"},
    /* Mountain Standard/Daylight Time */
    {abbr: "MST", zone: "GMT-0700"},
    {abbr: "MDT", zone: "GMT-0600"},
    /* Central Standard/Daylight Time */
    {abbr: "CST", zone: "GMT-0600"},
    {abbr: "CDT", zone: "GMT-0500"},
    /* Eastern Standard/Daylight Time */
    {abbr: "EST", zone: "GMT-0500"},
    {abbr: "EDT", zone: "GMT-0400"},
    /* Atlantic Standard/Daylight Time */
    {abbr: "AST", zone: "GMT-0400"},
    {abbr: "ADT", zone: "GMT-0300"},
    /* Newfoundland Standard/Daylight Time */
    {abbr: "NST", zone: "GMT-0330"},
    {abbr: "NDT", zone: "GMT-0230"},
    /* London Standard/Daylight Time */
    {abbr: "BST", zone: "GMT+0100"},
    {abbr: "GMT", zone: "GMT+0000"}
];

/**
 * Goes through the timze zone abbreviations looking for matching GMT time.
 * */
private static function parseTimeZoneFromGMT(gmt:String):String {
    for each (var obj:Object in timeZoneAbbreviations) {
        if (obj.zone == gmt) {
            return obj.abbr;
        }
    }
    return gmt;
}


