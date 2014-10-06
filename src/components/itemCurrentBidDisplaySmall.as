package components {
import auctionFunctionsClass.fileLoaderClass;
import auctionFunctionsClass.itemBidClass;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class itemCurrentBidDisplaySmall extends itemCurrentBidDisplaySmallLayout {

    public function itemCurrentBidDisplaySmall() {
        super();
        clearItemCurrentBidDisplay();
    }

    public var itemBidData:itemBidClass = new itemBidClass();
    private var _fileLoader:fileLoaderClass = new fileLoaderClass();
    private var _timer:Timer;

    private var _auctionID:Number;

    public function set auctionID(num:Number):void {

        if (num != _auctionID)
            this.currentState = "State2";

        _auctionID = num;

    }

    private var _itemID:Number;

    public function set itemID(num:Number):void {

        if (num != _itemID)
            this.currentState = "State2";

        _itemID = num;

    }

    private var _loginUserID:String;

    public function set loginUserID(user:String):void {

        _loginUserID = user;
    }

    private var _bidDBXML:XML;

    public function set bidDBXML(xml:XML):void {

        _bidDBXML = xml;
    }

    private function clearItemCurrentBidDisplay():void {

        _auctionID = 0;
        _itemID = 0;
        _loginUserID = "";
        _bidDBXML = new XML();
        itemBidData = new itemBidClass();
        _fileLoader = new fileLoaderClass();
        _timer = new Timer(1000);

        this.visible = false;

        this.addEventListener(FlexEvent.CREATION_COMPLETE, itemCurrentBidDisplay_creationCompleteHandler);

    }

    private function currentItemBidInfoDisplay():void {

        this.currentState = "State1";

        var bidsCount:String = _bidDBXML.itemBidCount.toString();
        var bidCurrAmount:String = _bidDBXML.currentBid.toString();
        var bidNextBidRequired:String = calculateBidRequirment(bidCurrAmount);
        var bidCurrBidWinner:String = _bidDBXML.currBidWinner.toString();
        var bidCurrBidState:String = _bidDBXML.currBidState.toString();

        if (bidsCount == "")
            bidsCount = "0";

        if (bidCurrBidWinner == "")
            bidCurrBidWinner = "None";

        if (bidCurrBidState == "")
            bidCurrBidState = "None";


        bidsTxt.text = bidsCount;
        currAmountTxt.text = bidCurrAmount;
        bidRequiredTxt.text = bidNextBidRequired;
        higherBidderTxt.text = bidCurrBidWinner;
        stateBidderTxt.text = bidCurrBidState;

        _timer.start();
        bgFill.color = 0xFFFFFF;
    }

    private function clearCurrentItemBidInfoDisplay():void {

        bidsTxt.text = "0";
        currAmountTxt.text = "0";
        bidRequiredTxt.text = "0";
        higherBidderTxt.text = "0";

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


        var nextBidTotal:Number = numberConversion + nextBidCalculator;
        numberStringHolder = nextBidTotal.toString();

        return numberStringHolder;

    }

    private function itemCurrentBidDisplay_creationCompleteHandler(event:FlexEvent):void {

        clearCurrentItemBidInfoDisplay();
        _timer = new Timer(1000);
        _timer.addEventListener(TimerEvent.TIMER, currentItemBidInfo);
        _timer.start();
    }

    private function currentItemBidInfo(event:Event):void {

        if (_auctionID == 0 || _itemID == 0) {
            this.visible = false;
            return;
        }

        _timer.stop();

        this.visible = true;
        bgFill.color = 0xFCFF00;

        _fileLoader.xmlFileLoader = new HTTPService();

        _fileLoader = itemBidData.xmlFileLoader;

        _fileLoader.xmlFileLoader.addEventListener(ResultEvent.RESULT, currentItemBidInfoVerify);
        _fileLoader.xmlFileLoader.addEventListener(FaultEvent.FAULT, currentItemBidInfoFail);


        itemBidData.loadBidDBXML(_auctionID, _itemID);

    }

    private function currentItemBidInfoFail(event:Event):void {

        _fileLoader.xmlFileLoader.removeEventListener(ResultEvent.RESULT, currentItemBidInfoVerify);
        _fileLoader.xmlFileLoader.removeEventListener(FaultEvent.FAULT, currentItemBidInfoFail);

        _timer.start();
    }

    private function currentItemBidInfoVerify(event:Event):void {
        var xml:XML = new XML();

        xml = XML(itemBidData.xmlService.lastResult);

        _bidDBXML = xml.item[0];
        _bidDBXML;

        _fileLoader.xmlFileLoader.removeEventListener(ResultEvent.RESULT, currentItemBidInfoVerify);
        _fileLoader.xmlFileLoader.removeEventListener(FaultEvent.FAULT, currentItemBidInfoFail);

        if (_bidDBXML == null)
            return;

        currentItemBidInfoDisplay();
    }
}
}