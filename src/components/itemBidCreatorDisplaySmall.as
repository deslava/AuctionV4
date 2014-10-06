package components {
import auctionFunctionsClass.fileLoaderClass;
import auctionFunctionsClass.itemBidClass;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Timer;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class itemBidCreatorDisplaySmall extends itemBidCreatorLayoutSmall {
    public function itemBidCreatorDisplaySmall() {
        super();
        this.mouseEnabled = true;
        clearItemBidCreator();
    }

    public var itemBidData:itemBidClass = new itemBidClass();
    public var _bidLoader:fileLoaderClass;
    private var _loginUserState:String;
    private var _loginUserType:String;
    private var _obj:Object;
    private var _bidObj:Object;
    private var _bidHistoryXML:XML = new XML;
    private var _currentTime:Date;
    private var _timer:Timer;
    private var extendtime:Number;
    private var minExtend:Number;
    private var countDownTime:Number;
    private var fileLoader:fileLoaderClass;
    private var _bidHistoryData:itemBidClass = new itemBidClass();

    private var _auctionID:Number;

    public function set auctionID(num:Number):void {

        _auctionID = num;

    }

    private var _itemID:Number;

    public function set itemID(num:Number):void {

        if (num != _itemID) {
            clear();
            this.currentState = "State1";
        }

        _itemID = num;


    }

    private var _loginUserID:String;

    public function set loginUserID(user:String):void {

        _loginUserID = user;
    }

    private var _loginUserXML:XML = new XML;

    public function get loginUserXML():XML {
        return _loginUserXML;
    }

    public function set loginUserXML(value:XML):void {
        _loginUserXML = value;
        _loginUserState = _loginUserXML.userState.toString();
        _loginUserType = _loginUserXML.userType.toString();
    }

    private var _bidDBXML:XML = new XML;

    public function set bidDBXML(xml:XML):void {

        var tempXML:XML = xml;

        _bidDBXML = tempXML.item[0];
        _bidDBXML;
    }

    private var _auctionItemFileXML:XML;

    public function set auctionItemFileXML(xml:XML):void {

        _auctionItemFileXML = xml;

    }

    private var _auctionItemDBXML:XML = new XML();

    public function get auctionItemDBXML():XML {
        return _auctionItemDBXML;
    }

    public function set auctionItemDBXML(value:XML):void {
        _auctionItemDBXML = value;
    }

    public function createExtendMinuteCalc():Number {
        var minutes:Number;

        minutes = 1000 * 60 * minExtend;

        return minutes;
    }

    public function extendTimerCalculate():void {
        var currTime:Number;
        var selTime:Number;
        var minute:Number;

        extendtime = 0;

        _currentTime = new Date();
        currTime = _currentTime.getTime();
        selTime = _auctionItemDBXML.isoTime;
        countDownTime = selTime - currTime;

        minute = 1000 * 60;

        if (countDownTime <= minute) {
            minExtend = _auctionItemDBXML.extendTime;
            extendtime = createExtendMinuteCalc();
            extendtime;
        }

        else {
            extendtime = 0;
        }
    }

    public function syncronizeDisplay():void {

        extendTimerCalculate();

        this.addEventListener(FlexEvent.ENTER_STATE, changeState_enterStateHandler);

        if (_auctionID == 0 || _itemID == 0) {
            clear();
            this.visible = false;
            this.currentState = "State1";

            return;
        }

        if (countDownTime <= 0) {
            this.visible = false;
            this.currentState = "State1";

            return;
        }

        this.visible = true;

        _bidDBXML;

        updateCurrentUserDisplay();

    }

    private function clear():void {

        var active:Boolean;
        if (this == null) {
            return;
        }
        active = this.initialized;
        if (active == false) {
            return;
        }

        countDownTimerTxt_Handler();

        currUserBidTxt.text = "";
        currUserMaxBidTxt.text = "";
        displayUpdate.text = "";

        userIDdisplay.text = "";
        userMaxDisplay.text = "";

        currUserBidDec.selectedIndex = 0;
        currUserMaxBidDec.selectedIndex = 0;

        logInText.visible = false;
        userIDdisplay.visible = false;

        maxText.visible = false;
        userMaxDisplay.visible = false;

        _bidHistoryXML = new XML;

    }

    private function updateCurrentUserDisplay():void {
        var s:String = "";
        var s1:String = "";

        var t:String = "";
        var t1:String = "";

        var m:String = "";
        var m1:String = "";


        maxText.visible = false;
        userMaxDisplay.visible = false;

        if (_loginUserID == "" || _loginUserID == "0") {


            logInText.visible = false;
            userIDdisplay.visible = false;

            maxText.visible = false;
            userMaxDisplay.visible = false;

            return;
        }
        else {

            if (currUserBidTxt.text == "LOG IN") {
                currUserBidTxt.text = "";
                currUserMaxBidTxt.text = "";
                displayUpdate.text = "";
            }

            displayUpdate.text = "";
            displayAllInfo.text = "";

            logInText.visible = true;
            userIDdisplay.visible = true;

            userIDdisplay.text = _loginUserID.toString();
        }

        if (_bidDBXML == null) {

            return;
        }

        if (countDownTime <= 0) {
            this.visible = false;
            this.currentState = "State1";

            return;
        }


        t = _bidDBXML.currBidWinner.toString();
        t1 = _loginUserID;

        s = _bidDBXML.currBidMaxUserID.toString();
        s1 = _loginUserID;

        m = _bidDBXML.currBidMax.toString();
        m1 = _bidDBXML.currentBid.toString();

        var n:Number = Number(m);
        var n1:Number = Number(m1);


        if (t == "")
            return;

        if (n1 >= n) {


            if (t == t1) {
                displayUpdate.text = "You're High Bidder";

                if (n1 == n) {
                    userMaxDisplay.visible = true;
                    userMaxDisplay.text = m;
                }

            }
            else {

                displayUpdate.text = "You've been out bid by " + t;
            }
        }

        else if (n1 < n) {


            if (t == t1) {

                displayUpdate.text = "You're Max Bidder";

                maxText.visible = true;
                userMaxDisplay.visible = true;
                userMaxDisplay.text = m;

            }

            else {

                displayUpdate.text = "You've been out bid by " + t;
            }


        }

        if (t == "" || t1 == "") {
            displayUpdate.text = "";
        }

        if (m == "" || m == "0")
            m = "none";
        if (s == "" || s == "0")
            s = "none";
        if (n <= n1)
            m = "none";

        if (_loginUserType == "Bidder") {
            displayAllInfo.visible = false;
        }
        else {
            displayAllInfo.visible = true;
        }

        displayAllInfo.text = "Current Bid:   " + m1 + "    Current Bid Winner:   " + t + "\nCurrent Max Bid:   " + m;


    }

    private function clearItemBidCreator():void {

        _auctionID = 0;
        _itemID = 0;
        _loginUserState = "";
        _loginUserID = "";

        _obj = new Object();
        _bidObj = new Object();
        _bidDBXML = new XML();
        _auctionItemFileXML = new XML();

        fileLoader = new fileLoaderClass();
        _bidLoader = new fileLoaderClass();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, itemBidCreator_creationCompleteHandler);

        syncronizeDisplay();
    }

    private function calculateBidRequirment(bidCurrAmount:String):String {

        if (bidCurrAmount == "")
            bidCurrAmount = "0";

        var numberConversion:Number;
        var numberStringHolder:String;

        var nextBidCalculator:Number;

        numberConversion = Number(bidCurrAmount);


        if (numberConversion >= 0 && numberConversion <= 10) {
            nextBidCalculator = 1;
        }
        else if (numberConversion >= 11 && numberConversion <= 25) {
            nextBidCalculator = 2;
        }
        else if (numberConversion >= 26 && numberConversion <= 100) {
            nextBidCalculator = 5;
        }
        else if (numberConversion >= 101 && numberConversion <= 500) {
            nextBidCalculator = 10;
        }
        else if (numberConversion >= 501 && numberConversion <= 1000) {
            nextBidCalculator = 25;
        }
        else if (numberConversion >= 1001 && numberConversion <= 10000) {
            nextBidCalculator = 50;
        }
        else if (numberConversion >= 10001) {
            nextBidCalculator = 100;
        }


        var nextBidTotal:Number = nextBidCalculator;
        numberStringHolder = nextBidTotal.toString();

        return numberStringHolder;

    }

    private function submitUserBid():void {


        _bidObj.table1 = "Bid";
        _bidObj.auctionID = _auctionID;
        _bidObj.userID = _loginUserID;
        _bidObj.itemID = _itemID;
        _bidObj.searchVar = _itemID;
        _bidObj.userState = _loginUserState;
        _bidObj.extendtime = extendtime;
        _bidObj.userType = _loginUserType;

        submitBid(_bidObj);


    }

    private function submitUserMaxBid():void {


        _bidObj.table1 = "MaxBid";
        _bidObj.auctionID = _auctionID;
        _bidObj.itemID = _itemID;
        _bidObj.userID = _loginUserID;
        _bidObj.searchVar = _itemID;
        _bidObj.userState = _loginUserState;
        _bidObj.extendtime = extendtime;
        _bidObj.userType = _loginUserType;

        submitBid(_bidObj);

    }

    private function submitBid(bObj:Object):void {

        var url:String = "bidFunctions.php";

        fileLoader = new fileLoaderClass();
        fileLoader.xmlFileLoader = new HTTPService();
        itemBidData.xmlFileLoader = new fileLoaderClass();
        itemBidData.xmlFileLoader.xmlFileLoader = new HTTPService();

        fileLoader = itemBidData.xmlFileLoader;

        fileLoader.xmlFileLoader.addEventListener(ResultEvent.RESULT, submitBidVerify);
        fileLoader.xmlFileLoader.addEventListener(FaultEvent.FAULT, submitBidFail);

        disableBidDisplay();
        itemBidData.sendBidDB(_bidObj);

    }

    private function submitBidValid():void {
        enableBidDisplay();
        syncronizeDisplay();
    }

    private function disableBidDisplay():void {

        currUserBidTxt.enabled = false;
        currUserBidDec.enabled = false;
        currUserMaxBidTxt.enabled = false;
        currUserMaxBidDec.enabled = false;
        bidUpdateBtn.enabled = false;

        displayUpdate.text = "Submitting your Bid..."


    }

    private function enableBidDisplay():void {

        currUserBidTxt.enabled = true;
        currUserBidDec.enabled = true;
        currUserMaxBidTxt.enabled = true;
        currUserMaxBidDec.enabled = true;
        bidUpdateBtn.enabled = true;

        displayUpdate.text = "";

    }

    private function loadBidHistory():void {

        _bidLoader = _bidHistoryData.xmlFileLoader;

        _bidLoader.xmlFileLoader.addEventListener(ResultEvent.RESULT, loadBidHistoryVerify);
        _bidLoader.xmlFileLoader.addEventListener(FaultEvent.FAULT, loadBidHistoryFail);


        _bidHistoryData.loadBidHistoryXML(_auctionID, _itemID);


    }

    private function bidHistoryDataAssign():void {

        var xl:XMLList = XMLList(_bidHistoryXML.children());
        var xc:XMLListCollection = new XMLListCollection(xl);
        bidHistoryDisplay.dataProvider = xc.list;


    }

    private function countDownTimerTxt_Handler():void {

        _auctionItemDBXML;

        if (_auctionItemDBXML == null)
            return;

        var currTime:Number;
        var selTime:Number;

        _currentTime = new Date();

        currTime = _currentTime.getTime();
        selTime = _auctionItemDBXML.isoTime;

        if (selTime == 0)
            return;

        countDownTime = selTime - currTime;


    }

    protected function refreshBidHistory_clickHandler(event:MouseEvent):void {
        loadBidHistory();
    }

    protected function changeState_enterStateHandler(event:FlexEvent):void {
        if (this.currentState == "State2") {
            this.refreshBtn.addEventListener(MouseEvent.CLICK, refreshBidHistory_clickHandler);
            this.returnToBidBtn.addEventListener(MouseEvent.CLICK, returnToBidHistory_clickHandler);

        }

    }

    protected function returnToBidHistory_clickHandler(event:MouseEvent):void {
        this.currentState = "State1";
    }

    private function currUserBidTxt_clickHandler(event:MouseEvent):void {
        currUserMaxBidTxt.text = "";

    }

    private function currUserMaxBidTxt_clickHandler(event:MouseEvent):void {
        currUserBidTxt.text = "";
    }

    private function itemBidCreator_creationCompleteHandler(event:Event):void {
        this.bidUpdateBtn.addEventListener(MouseEvent.CLICK, bidUpdateBtn_clickHandler);
        this.currUserMaxBidTxt.addEventListener(MouseEvent.CLICK, currUserMaxBidTxt_clickHandler);
        this.currUserBidTxt.addEventListener(MouseEvent.CLICK, currUserBidTxt_clickHandler);
        this.viewBidHistoryBtn.addEventListener(MouseEvent.CLICK, viewBidHistory_clickHandler);
        this.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, changeState_enterStateHandler);


    }

    private function viewBidHistory_clickHandler(event:MouseEvent):void {

        this.currentState = "State2";


        loadBidHistory();
    }

    private function bidUpdateBtn_clickHandler(event:MouseEvent):void {

        var bidCurrAmount:String = _bidDBXML.currentBid.toString();
        var bidIncrease:String = calculateBidRequirment(bidCurrAmount);
        var bidNextBidRequired:Number = Number(Number(bidCurrAmount) + Number(bidIncrease));


        var currUserBidString:String;
        var currUserBid:Number;

        var currMaxUserBidString:String;
        var currMaxUserBid:Number;

        if (_loginUserID == "" || _loginUserID == "0" || _loginUserID == null) {
            currUserBidTxt.text = "LOG IN";
            displayUpdate.text = "LOG IN";
            currUserMaxBidTxt.text = "LOG IN";
            return;
        }

        _loginUserState = _loginUserXML.userState.toString();
        _loginUserType = _loginUserXML.userType.toString();

        currUserBidString = currUserBidTxt.text.toString();
        currUserBid = Number(currUserBidString);

        currMaxUserBidString = currUserMaxBidTxt.text.toString();
        currMaxUserBid = Number(currMaxUserBidString);

        if (currUserBidString != "") {

            if (currUserBid >= bidNextBidRequired) {

                _bidObj.userCurrBid = currUserBidString;
                _bidObj.userMaxBid = "";
                _bidObj.userBidIncrement = bidIncrease;
                _bidObj.userType = _loginUserType;

                currUserBidTxt.text = "";
                submitUserBid();

            }
            else if (currUserBid < bidNextBidRequired) {
                currUserBidTxt.text = bidNextBidRequired.toString();
            }
        }
        else if (currMaxUserBidString != "") {
            if (currMaxUserBid >= bidNextBidRequired) {

                _bidObj.userCurrBid = "";
                _bidObj.userMaxBid = currMaxUserBidString;
                _bidObj.userBidIncrement = bidIncrease;
                _bidObj.userType = _loginUserType;

                currUserBidTxt.text = "";
                currUserMaxBidTxt.text = "";
                submitUserMaxBid();
            }
            else if (currUserBid < bidNextBidRequired) {
                currUserMaxBidTxt.text = bidNextBidRequired.toString();
            }
        }

        else {
            currUserBidTxt.text = bidNextBidRequired.toString();
        }


    }

    private function submitBidFail(event:Event):void {

        enableBidDisplay();

        fileLoader.xmlFileLoader.removeEventListener(ResultEvent.RESULT, submitBidVerify);
        fileLoader.xmlFileLoader.removeEventListener(FaultEvent.FAULT, submitBidFail);

    }

    private function submitBidVerify(event:Event):void {

        var xml:XML = new XML();

        xml = XML(itemBidData.xmlService.lastResult);

        _bidDBXML = xml.item[0];
        _bidDBXML;

        fileLoader.xmlFileLoader.removeEventListener(ResultEvent.RESULT, submitBidVerify);
        fileLoader.xmlFileLoader.removeEventListener(FaultEvent.FAULT, submitBidFail);


        submitBidValid();

    }

    private function loadBidHistoryFail(event:FaultEvent):void {
        _bidLoader.xmlFileLoader.removeEventListener(ResultEvent.RESULT, loadBidHistoryVerify);
        _bidLoader.xmlFileLoader.removeEventListener(FaultEvent.FAULT, loadBidHistoryFail);

    }

    ////////////////////////////////////////////////////////////////////////////////////////

    private function loadBidHistoryVerify(event:ResultEvent):void {
        var xml:XML = new XML();

        xml = XML(_bidHistoryData.xmlService.lastResult);

        _bidHistoryXML = xml;
        _bidHistoryXML;

        _bidLoader.xmlFileLoader.removeEventListener(ResultEvent.RESULT, loadBidHistoryVerify);
        _bidLoader.xmlFileLoader.removeEventListener(FaultEvent.FAULT, loadBidHistoryFail);

        bidHistoryDataAssign();
    }
}
}