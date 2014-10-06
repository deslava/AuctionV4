package components {
import auctionFunctionsClass.fileLoaderClass;
import auctionFunctionsClass.itemBidClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import flashx.textLayout.conversion.TextConverter;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.components.List;

public dynamic class itemViewDisplay extends itemViewLayout {


    public function itemViewDisplay() {
        super();
        clearItemPublicDisplay();
    }

    public var itemBidData:itemBidClass = new itemBidClass();
    private var _bidXML:XML = new XML();
    private var _fileLoader:fileLoaderClass = new fileLoaderClass();

    private var _auctionID:Number;

    public function set auctionID(num:Number):void {

        _auctionID = num;

    }

    private var _itemID:Number;

    public function set itemID(num:Number):void {
        _itemID = num;


    }

    private var _loginUserID:String;

    public function set loginUserID(user:String):void {

        _loginUserID = user;
    }

    private var _auctionItemDBXML:XML = new XML();

    public function get auctionItemDBXML():XML {
        return _auctionItemDBXML;
    }

    public function set auctionItemDBXML(value:XML):void {
        _auctionItemDBXML = value;
        _auctionItemDBXML;
    }

    private var _auctionItemFileXML:XML = new XML();

    public function set auctionItemFileXML(xml:XML):void {

        _auctionItemFileXML = xml;

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

    public function syncronizeAuction():void {

        clearPage1();
    }

    private function clearItemPublicDisplay():void {

        _auctionID = 0;
        _itemID = 0;
        _loginUserID = "";
        _auctionItemFileXML = new XML();
        itemSelectedTxt.text = "";

        addEventListener(FlexEvent.CREATION_COMPLETE, itemView_creationCompleteHandler);
        currentItemBidDisplay.addEventListener(FlexEvent.CREATION_COMPLETE, currentItemBidDisplay_creationCompleteHandler);
        currentItemBidder.addEventListener(FlexEvent.CREATION_COMPLETE, currentItemBid_creationCompleteHandler);
        imgHolderHightlight.addEventListener(Event.TAB_CHILDREN_CHANGE, bubbleMouseEvent);


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

        var itemInfoXML:XML = _auctionItemFileXML.item[0];

        s2 = itemInfoXML.reserveDollar.toString();
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

    private function setUpItemsDBData():void {

        timeBidClear();
    }

    private function clearPage1():void {

        clearPage1Data();
        setUpItemsDBData();
        itemBidSetup();


    }

    private function clearPage1Data():void {

        itemSelectedTxt.text = "";
        clearTab1();

        setUpItemFileData();

        //countDownTimerComponent.auctionDBXML = _auctionItemDBXML;
        _auctionItemDBXML;

    }

    private function itemBidSetup():void {

        var itemBidDisplay:itemCurrentBidDisplay = currentItemBidDisplay as itemCurrentBidDisplay;

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

        var itemBidDisplay:itemCurrentBidDisplay = currentItemBidDisplay as itemCurrentBidDisplay;

        itemBidDisplay.auctionID = 0;
        itemBidDisplay.itemID = 0;
        itemBidDisplay.loginUserID = _loginUserID;


    }

    ////////////////////////////////////////////////////////////////////////////////////

    private function setUpItemFileData():void {

        itemSelectedTxt.text = _auctionItemFileXML.toString();

        loadItemFile(_auctionItemFileXML);

        restBidDisplaySync();

    }

    ////////////////////////////////////////////////////////////////////////////////////

    private function clearTab1():void {


        itemTitle.text = "Select An Item";
        itemIDtext.text = "";
        categoryDisplay.text = "";
        itemDescription.text = "";
        ReserveBidNowLabel.text = "";

        itemIdLabel.visible = false;
        categoryText.visible = false;
        descriptionText.visible = false;

        itemIDtext.visible = false;
        categoryDisplay.visible = false;
        itemDescription.visible = false;
        ReserveBidNowLabel.visible = false;

        imgHolderHightlight.dataProvider = null;

    }

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
        descriptionText.visible = true;

        itemIDtext.visible = true;
        categoryDisplay.visible = true;
        itemDescription.visible = true;
        ReserveBidNowLabel.visible = true;


        itemTitle.text = itemInfoXML.itemName.toString();
        categoryDisplay.text = itemInfoXML.category.toString();
        itemIDtext.text = itemInfoXML.itemId.toString();

        s2 = itemInfoXML.reserveDollar.toString();
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
        itemDescription.text = itemInfoXML.description;
        itemDescription.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);


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

    private function currentItemBidDisplay_creationCompleteHandler(event:FlexEvent):void {

        itemBidSetup();

    }

    private function currentItemBid_creationCompleteHandler(event:FlexEvent):void {

        restBidDisplaySync();

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function itemView_creationCompleteHandler(event:FlexEvent):void {
        //clearPage1();
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

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }


}
}