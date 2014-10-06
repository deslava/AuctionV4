package components {
import auctionFunctionsClass.serverTime;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

public class dateSetup extends dateSetupLayout {
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

    public function dateSetup() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, dateSetup_creationComplete);
    }

    public var selectedDate:Date = new Date();
    public var timeZoneString:String;
    private var serversTime:Date = new Date();
    private var serverTimeLoaderItem:serverTime = new serverTime();
    private var currTime:Number;
    private var selTime:Number;
    private var xc1:XMLListCollection = new XMLListCollection();
    private var xc2:XMLListCollection = new XMLListCollection();

    public function formatUserSelectedTime():void {
        var auctionHour:Number;
        var auctionMinutes:Number;
        var auctionDate:Object;
        var auctionAMPM:Object;

        auctionHour = auctionHourTab.value;
        auctionMinutes = auctionMinuteTab.value;
        auctionAMPM = ampmTab.selectedItem;
        auctionDate = auctionDateTab.selectedDate;

        if (auctionDate == "" || auctionDate == null)
            return;

        if (auctionAMPM == "PM") {
            auctionHour = auctionHour + 12;
        }

        auctionDate;

        selectedDate = new Date();

        selectedDate.setHours(auctionHour, auctionMinutes);
        var selectedM:Number = auctionDate.month;
        var selectedD:Number = auctionDate.date;
        var selectedY:Number = auctionDate.fullYear;

        selectedDate.setFullYear(selectedY, selectedM, selectedD);
        closingAuctionTime.text = formatSelectedTime(selectedDate);
    }

    public function clear():void {
        loadTimeList();

        auctionHourTab.value = 9;
        auctionMinuteTab.value = 0;

        ampmTab.selectedIndex = 0;

        auctionDateTab.text = "";
        auctionDateTab.selectedDate = null;

        auctionDateTab.invalidateDisplayList();

        currentTimeDisplay.text = "";
        closingAuctionTime.text = "";
        countDownTimerTxt.text = "";

        serversTime = new Date();
        selectedDate = new Date();

        serverTimeLoaderItem = new serverTime();
        serverTimeLoaderItem.clear();
        serverTimeLoaderItem.addEventListener(ResultEvent.RESULT, serverTimeLoader_resultHandler);
        serverTimeLoaderItem.addEventListener(FaultEvent.FAULT, serverTimeLoader_faultHandler);
        serverTimeLoaderItem.getServerTime();
    }

    public function deactivateTimer():void {
        serverTimeLoaderItem = new serverTime();
        serverTimeLoaderItem.clear();
        serverTimeLoaderItem.timerOn = false;
        serverTimeLoaderItem.removeEventListener(ResultEvent.RESULT, serverTimeLoader_resultHandler);
        serverTimeLoaderItem.removeEventListener(FaultEvent.FAULT, serverTimeLoader_faultHandler);
    }

    public function calculateCountDown():void {

        if (serversTime == null) {
            serversTime = selectedDate;
            var newTime:String = "00:00:00:00";
            countDownTimerTxt.text = newTime;
        }

        currTime = serversTime.getTime();
        selTime = selectedDate.getTime();

        var countDownTime:Number = selTime - currTime;

        var sec:Number = Math.floor(countDownTime / 1000);
        var min:Number = Math.floor(sec / 60);
        var hours:Number = Math.floor(min / 60);
        var days:Number = Math.floor(hours / 24);
        //Takes results of var remaining value.  Also converts "sec" into a string
        var seconds:String = String(sec % 60);
        //Once a string, you can check the values length and see whether it has been reduced below 2.
        //If so, add a "0" for visual purposes.
        if (seconds.length < 2) {
            seconds = "0" + seconds;
        }
        var minutes:String = String(min % 60);
        if (minutes.length < 2) {
            minutes = "0" + minutes;
        }
        var hoursPassed:String = String(hours % 24);
        if (hoursPassed.length < 2) {
            hoursPassed = "0" + hoursPassed;
        }
        var daysPassed:String = String(days);

        if (countDownTime > 0) {
            //Joins all values into one string value
            var counter:String = daysPassed + " Days " + hoursPassed + ":" + minutes + ":" + seconds;
            countDownTimerTxt.text = counter;
        } else {
            trace("TIME'S UP");
            newTime = "00:00:00:00";
            countDownTimerTxt.text = newTime;
        }

    }

    public function loadTimeList():void {


        var timeXML:XML = <time>
            <uu>AM</uu>
            <uu>PM</uu>
        </time>;

        var productAttributes:XMLList = timeXML.uu.children();
        var xl:XMLList = XMLList(productAttributes);
        xc1 = new XMLListCollection(xl);

        ampmTab.dataProvider = xc1.list;
        ampmTab.selectedIndex = 0;
        ampmTab.invalidateDisplayList();

    }

    public function formatSelectedTime(dateToFormat:Date):String {

        var formattedDate:String;
        var currentTimeString2:String = getDateIso8601Long(dateToFormat);
        currentTimeString2;


        var newFormatTime2:DrDredelDate = new DrDredelDate(currentTimeString2);
        var displayHourFormat2:String = "HH";
        var displayMinuteAFormat2:String = "MM";
        var displaySecondFormat2:String = "ss";
        var displayMinuteMFormat2:String = "A";
        var displayAPMDYYYY2:String = "mm/dd/yyyy";


        var currentHTimeString2:String = newFormatTime2.getFormattedDate(displayHourFormat2);
        var currentMTimeString2:String = newFormatTime2.getFormattedDate(displayMinuteAFormat2);
        var currentSTimeString2:String = newFormatTime2.getFormattedDate(displaySecondFormat2);
        var currentAMTimeString2:String = newFormatTime2.getFormattedDate(displayMinuteMFormat2);
        var currentAPMDYYYYTimeString2:String = newFormatTime2.getFormattedDate(displayAPMDYYYY2);

        timeZoneString = "GMT" + newFormatTime2.timezoneOffset;
        timeZoneString = parseTimeZoneFromGMT(timeZoneString);

        currentTimeString2 = currentHTimeString2 + ":" + currentMTimeString2 + ":" + currentSTimeString2 + " " + currentAMTimeString2 + " " + timeZoneString + " " + currentAPMDYYYYTimeString2;
        formattedDate = currentTimeString2;

        return formattedDate;
    }

    protected function setDateBtn_clickHandler(event:MouseEvent):void {
        formatUserSelectedTime();

    }

////////////////////////////////////////////////////////////////////////		

    protected function serverTimeLoader_faultHandler(event:Event):void {
        var obj:Object;
        obj = event;
    }

    ////////////////////////////////////////////////////////////////////////

    protected function serverTimeLoader_resultHandler(event:Event):void {
        if (serverTimeLoaderItem.currentTime == null)
            return;

        serversTime = serverTimeLoaderItem.currentTime;
        currentTimeDisplay.text = formatSelectedTime(serversTime);

        calculateCountDown();
    }

    private function dateSetup_creationComplete(event:FlexEvent):void {
        clear();
        setDateBtn.addEventListener(MouseEvent.CLICK, setDateBtn_clickHandler);
    }

}
}