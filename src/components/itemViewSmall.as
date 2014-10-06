package components {
import auctionFunctionsClass.fileLoaderClass;
import auctionFunctionsClass.itemBidClass;

import flash.events.Event;

import mx.collections.XMLListCollection;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.components.List;

public class itemViewSmall extends itemViewSmallLayout {

    public function itemViewSmall() {
        super();
    }

    public var itemBidData:itemBidClass = new itemBidClass();
    private var _bidXML:XML = new XML();
    private var _fileLoader:fileLoaderClass = new fileLoaderClass();

    private var _auctionID:Number;

    public function get auctionID():Number {
        return _auctionID;
    }

    public function set auctionID(value:Number):void {
        _auctionID = value;
    }

    private var _itemID:Number;

    public function get itemID():Number {
        return _itemID;
    }

    public function set itemID(value:Number):void {
        _itemID = value;
    }

    private var _loginUserID:String;

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _loginUserType:String;

    public function get loginUserType():String {
        return _loginUserType;
    }

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    private var _auctionDBXML:XML = new XML();

    public function get auctionDBXML():XML {
        return _auctionDBXML;
    }

    public function set auctionDBXML(value:XML):void {
        _auctionDBXML = value;
    }

    private var _auctionItemDBXML:XML = new XML();

    public function get auctionItemDBXML():XML {
        return _auctionItemDBXML;
    }

    public function set auctionItemDBXML(value:XML):void {
        _auctionItemDBXML = value;
    }

    private var _auctionItemFileXML:XML = new XML();

    public function get auctionItemFileXML():XML {
        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
    }

    private var _loginUserXML:XML = new XML();

    public function get loginUserXML():XML {
        return _loginUserXML;
    }

    public function set loginUserXML(value:XML):void {
        _loginUserXML = value;
    }

    public function clearAuction():void {

        clearItemPublicDisplay();
        timeBidClear();
    }

    public function clearItemPublicDisplay():void {

        _auctionID = 0;
        _itemID = 0;
        _loginUserID = "";
        _auctionItemFileXML = new XML();
        itemSelectedTxt.text = "";

        clearTab1()
    }

    public function syncronizeAuction():void {

        clearPage1();
    }

    private function clearTab1():void {

        itemTitle.text = "Select An Item";
        itemIDtext.text = "";
        categoryDisplay.text = "";
        ReserveBidNowLabel.text = "";
        itemIdLabel.visible = false;
        categoryText.visible = false;

        itemIDtext.visible = false;
        categoryDisplay.visible = false;
        ReserveBidNowLabel.visible = false;

        imgHolderHightlight.dataProvider = null;

    }

    ////////////////////////////////////////////////////////////////////////////////////

    private function loadItemFile(itemInfo:XML):void {

        if (itemInfo == null) {
            itemInfo = new XML
        }

        var s:String;
        var s2:String;
        var s3:String;
        var s4:String;
        var node:XML = new XML();
        var itemInfoXML:XML = itemInfo;

        itemIdLabel.visible = true;
        categoryText.visible = true;


        itemIDtext.visible = true;
        categoryDisplay.visible = true;
        ReserveBidNowLabel.visible = true;


        itemTitle.text = itemInfoXML.itemName.toString();
        categoryDisplay.text = itemInfoXML.category.toString();
        itemIDtext.text = itemInfoXML.itemId.toString();

        s2 = itemInfoXML.reserveDollar.toString();

        if (s2 == "")
            s2 = "0";

        s3 = itemInfoXML.buyNow.toString();
        if (s2 == "0") {
            ReserveBidNowLabel.text = "";
        }
        else if ((s2 != "0") && (s3 == "false")) {
            ReserveBidNowLabel.text = "Reserve Not Met on Item";
        }
        else if ((s2 != "0") && (s3 == "true")) {
            ReserveBidNowLabel.text = "Buy Now Item Amount: $" + s2;
        }

        s = itemInfoXML.rtdescription;


        imgHolderHightlight.useVirtualLayout = false;
        imgHolderHightlight.dataProvider = null;
        imgHolderHightlight.validateNow();

        assignHighlightImagHolderToList(imgHolderHightlight, itemInfoXML);

    }

    private function assignHighlightImagHolderToList(list:List, _auctionInfoXML:XML):void {

        var s:String = _auctionInfoXML.auctionImages.toString();

        s = _auctionInfoXML.auctionImages.toString();
        if (s != "") {
            var xl:XMLList = XMLList(_auctionInfoXML.auctionImages.children());
            var xc:XMLListCollection = new XMLListCollection(xl);
            list.dataProvider = xc.list;
        }
        else {
            _auctionInfoXML.auctionImages = "";
        }

    }


    ////////////////////////////////////////////////////////////////////////////////////

    private function clearPage1():void {

        clearPage1Data();
        setUpItemsDBData();
        itemBidSetup();


    }

    ////////////////////////////////////////////////////////////////////////////////////

    private function clearPage1Data():void {

        itemSelectedTxt.text = "";
        clearTab1();

        setUpItemFileData();

        countDownTimerComponent.clear();
        var time:String = _auctionItemDBXML.isoTime.toString();
        countDownTimerComponent.auctionTime = Number(time);

    }

    private function setUpItemsDBData():void {

        timeBidClear();
    }

    private function itemBidSetup():void {

        var itemBidDisplay:itemCurrentBidDisplaySmall = currentItemBidDisplay as itemCurrentBidDisplaySmall;

        var active:Boolean;
        if (itemBidDisplay == null) {
            return;
        }
        active = itemBidDisplay.initialized;
        if (active == false) {
            return;
        }

        itemBidDisplay.auctionID = _auctionID;
        itemBidDisplay.itemID = _itemID;


    }

    private function timeBidClear():void {

        var itemBidDisplay:itemCurrentBidDisplaySmall = currentItemBidDisplay as itemCurrentBidDisplaySmall;

        itemBidDisplay.auctionID = 0;
        itemBidDisplay.itemID = 0;
        itemBidDisplay.loginUserID = _loginUserID;


    }

    private function setUpItemFileData():void {

        itemSelectedTxt.text = _auctionItemFileXML.toString();

        loadItemFile(_auctionItemFileXML);

        restBidDisplaySync();

    }

    private function restBidDisplaySync():void {

        currentItemBidDisplay.itemBidData.xmlFileLoader = new fileLoaderClass()
        currentItemBidDisplay.itemBidData.xmlFileLoader.xmlFileLoader = new HTTPService();

        _fileLoader = currentItemBidDisplay.itemBidData.xmlFileLoader;
        _fileLoader.xmlFileLoader.addEventListener(ResultEvent.RESULT, updateBidVars);

    }

    private function reserveMaxBuyNowSync():void {
        var s2:String;
        var s3:String;

        var s1:String;

        var itemInfoXML:XML = _auctionItemFileXML;

        s2 = itemInfoXML.reserveDollar.toString();

        if (s2 == "")
            s2 = "0";

        s3 = itemInfoXML.buyNow.toString();

        s1 = _bidXML.item[0].currentBid;

        var num1:Number;
        var num2:Number;


        if (s2 == "0") {
            ReserveBidNowLabel.text = "";
        }
        else if ((s2 != "0") && (s3 == "false")) {

            num2 = Number(s2);
            num1 = Number(s1);

            if (num1 >= num2) {
                ReserveBidNowLabel.text = "Reserve Met on Item";
            }
        }
        else if ((s2 != "0") && (s3 == "true")) {
            num2 = Number(s2);
            num1 = Number(s1);

            if (num1 >= num2) {

                ReserveBidNowLabel.text = "Buy Now Item Purchased";
                currentItemBidder.visible = false;
            }
        }
    }

    private function updateBidVars(event:Event):void {
        var isoTimeUpdate:String;
        var currTimeDB:String;


        var _xmlFileLoader:HTTPService = new HTTPService();

        _xmlFileLoader = currentItemBidDisplay.itemBidData.xmlFileLoader.xmlFileLoader;

        _bidXML = XML(_xmlFileLoader.lastResult);
        currentItemBidder.bidDBXML = _bidXML;


        isoTimeUpdate = _bidXML.item[0].isoTime;
        currTimeDB = _auctionItemDBXML.isoTime.toString();
        _auctionItemDBXML.isoTime = isoTimeUpdate.toString();

        currentItemBidder.auctionID = _auctionID;
        currentItemBidder.itemID = _itemID;
        currentItemBidder.loginUserID = _loginUserID;
        currentItemBidder.loginUserXML = _loginUserXML;
        currentItemBidder.auctionItemDBXML = _auctionItemDBXML;

        //countDownTimerComponent.auctionDBXML = _auctionItemDBXML;
        currentItemBidder.syncronizeDisplay();

        restBidDisplaySync();

        reserveMaxBuyNowSync();
    }
}
}