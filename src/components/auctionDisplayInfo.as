package components {
import auctionFunctionsClass.auctionClass;
import auctionFunctionsClass.auctionItemClass;
import auctionFunctionsClass.auctionItemsListClass;
import auctionFunctionsClass.fileLoaderClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import flashx.textLayout.conversion.TextConverter;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.components.Button;
import spark.components.List;

public dynamic class auctionDisplayInfo extends auctionDisplayLayout {
    public function auctionDisplayInfo():void {
        super();
        clearAuctionDisplay();
    }

    public var _auction:auctionClass;
    public var _auctionItemLists:auctionItemsListClass;
    public var _auctionItem:auctionItemClass;
    private var _turnOnButton:Boolean = false;
    private var _dataXML:XML;
    private var _auctionItemsDBListXML:XML;
    private var _xmlFileLoader:HTTPService;
    private var _itemListFileLoader:HTTPService;

    private var _itemID:Number;

    public function get itemID():Number {

        return _itemID;
    }

    private var _auctionID:Number;

    public function get auctionID():Number {

        return _auctionID;
    }

    private var _auctionDBXML:XML;

    public function get auctionDBXML():XML {
        return _auctionDBXML;
    }

    public function set auctionDBXML(value:XML):void {
        _auctionDBXML = value;
    }

    private var _auctionFileXML:XML;

    public function get auctionFileXML():XML {

        return _auctionFileXML;
    }

    private var _auctionItemDBXML:XML;


    ////////////////////////////////////////////////////////////////////////////////////

    public function get auctionItemDBXML():XML {
        return _auctionItemDBXML;
    }

    public function set auctionItemDBXML(value:XML):void {
        _auctionItemDBXML = value;
    }

    private var _auctionItemFileXML:XML;

    public function get auctionItemFileXML():XML {

        return _auctionItemFileXML;
    }

    public function clearAuctionDisplay():void {

        _itemID = 0;
        _auctionID = 0;

        _dataXML = new XML();

        _auctionDBXML = new XML();
        _auctionFileXML = new XML();

        _auctionItemsDBListXML = new XML();
        _auctionItemDBXML = new XML();
        _auctionItemFileXML = new XML();

        _xmlFileLoader = new HTTPService();
        _itemListFileLoader = new HTTPService();

        _auction = new auctionClass();
        _auctionItemLists = new auctionItemsListClass();
        _auctionItem = new auctionItemClass();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, itemrenderer1_creationCompleteHandler);
        this.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, clickHandlers);

        this.currentState = "State1";


    }

    private function clearPage1():void {
        clearPage1Data();
    }

    private function clearPage2():void {
        clearPage2Data();
    }

    private function clearPage1Data():void {
        var countDownTimerComponent:countDownDisplay = countDownTimer as countDownDisplay;

        _dataXML = this.data as XML;
        _auctionDBXML = _dataXML;
        _auctionID = _auctionDBXML.id;
        xmlDBInfo.text = _auctionDBXML.toString();
        imgHolderHightlight.dataProvider = null;

        //countDownTimerComponent.auctionDBXML = _auctionDBXML;

        if (_dataXML != null)
            loadSelectedAuctionFileXML();

    }

    ////////////////////////////////////////////////////////////////////////////////////

    private function clearPage2Data():void {

        xmlItemsDBInfo.dataProvider = null;

        itemSelectedTxt.text = "";

        clearTab2();

        loadSelectedAuctionItemsDBXML();

    }

    private function loadSelectedAuctionFileXML():void {

        var auctionURL:String = _auctionDBXML.auctionXML.toString();

        if (auctionURL == "")
            return;

        _xmlFileLoader = new HTTPService();

        _xmlFileLoader = _auction.xmlFileLoader.xmlFileLoader;

        _xmlFileLoader.addEventListener(ResultEvent.RESULT, auctionsXMLVerify);
        _xmlFileLoader.addEventListener(FaultEvent.FAULT, auctionsXMLFail);

        _auction.loadAuctionFileXML(auctionURL);
    }

    private function loadSelectedItemFileXML():void {

        var auctionURL:String = _auctionItemDBXML.info_xml.toString();

        if (auctionURL == "")
            return;

        _xmlFileLoader = new HTTPService();
        _auctionItem._xmlFileLoader = new fileLoaderClass();
        _auctionItem._xmlFileLoader.xmlFileLoader = new HTTPService();

        _xmlFileLoader = _auctionItem._xmlFileLoader.xmlFileLoader;

        _xmlFileLoader.addEventListener(ResultEvent.RESULT, itemXMLVerify);
        _xmlFileLoader.addEventListener(FaultEvent.FAULT, itemXMLFail);

        _auctionItem.loadItemFileXML(auctionURL);
    }


    ////////////////////////////////////////////////////////////////////////////////////

    private function loadSelectedAuctionItemsDBXML():void {
        var auctionItemURL:String = "itemsXML.php"

        _itemListFileLoader = new HTTPService();

        _itemListFileLoader = _auctionItemLists.xmlFileLoader.xmlFileLoader;

        _itemListFileLoader.addEventListener(ResultEvent.RESULT, auctionsItemDBXMLVerify);
        _itemListFileLoader.addEventListener(FaultEvent.FAULT, auctionsItemDBXMLFail);

        _auctionItemLists.loadItemsListDBXML(auctionItemURL, _auctionID);

    }

    private function setUpAuctionDBData():void {
        xmlDBInfo.text = _auctionDBXML.toString();
        xmlFileInfo.text = _auctionFileXML.toString();

        _auction.auctionDBXML = _auctionDBXML;
        _auction.auctionFileXML = _auctionFileXML;


        displayAuctionFile(_auctionFileXML.auction[0]);
    }

    private function setUpItemsDBData():void {

        itemBidClear();

        _auctionItemLists.auctionItemsDBListXML = _auctionItemsDBListXML;
        xmlItemsDBInfo.dataProvider = _auctionItemLists.auctionItemsCollectionList();


    }

    private function setUpItemFileData():void {

        itemSelectedTxt.text = _auctionItemFileXML.toString();

        loadItemFile(_auctionItemFileXML.item[0]);


    }


    ////////////////////////////////////////////////////////////////////////////////////

    private function itemBidSetup():void {

        var itemBidDisplay:itemCurrentBidDisplay = currentItemBidDisplay as itemCurrentBidDisplay;

        itemBidDisplay.auctionID = _auctionDBXML.id;
        itemBidDisplay.itemID = _auctionItemDBXML.itemId;

        _auctionID = _auctionDBXML.id;
        _itemID = _auctionItemDBXML.itemId;


    }

    private function itemBidClear():void {

        var itemBidDisplay:itemCurrentBidDisplay = currentItemBidDisplay as itemCurrentBidDisplay;

        itemBidDisplay.auctionID = 0;
        itemBidDisplay.itemID = 0;
    }

    private function clearTab2():void {


        itemTitle.text = "Select An Item";
        itemIDtext.text = "";
        categoryDisplay2.text = "";
        itemDescription.text = "";
        ReserveBidNowLabel.text = "";

        itemIdLabel.visible = false;
        categoryText.visible = false;
        descriptionText.visible = false;

        itemIDtext.visible = false;
        categoryDisplay2.visible = false;
        itemDescription.visible = false;
        ReserveBidNowLabel.visible = false;

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function displayAuctionFile(auctionInfoXML:XML):void {
        var s:String;


        s = auctionInfoXML.address.toString();

        auctionTitle.text = auctionInfoXML.name;
        categoryDisplay.text = auctionInfoXML.auctionCategory;
        dateTimevalues.text = auctionInfoXML.endTime;
        locationValues.text = auctionInfoXML.address + "\n" + auctionInfoXML.city + ", " + auctionInfoXML.auctionState + " " + auctionInfoXML.zipcode;

        s = auctionInfoXML.rtAuctionDesInfo;
        auctionNotesText.text = auctionInfoXML.AuctionDesInfo;
        auctionNotesText.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);

        imgHolderHightlight.useVirtualLayout = false;
        assignHighlightImagHolderToList(imgHolderHightlight, auctionInfoXML);
    }

    private function loadItemFile(itemInfo:XML):void {

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
        categoryDisplay2.visible = true;
        itemDescription.visible = true;
        ReserveBidNowLabel.visible = true;


        itemTitle.text = itemInfoXML.itemName.toString();
        categoryDisplay2.text = itemInfoXML.category.toString();
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
            ReserveBidNowLabel.text = "Buy Now Item";
        }

        s = itemInfoXML.rtdescription;
        itemDescription.text = itemInfoXML.description;
        itemDescription.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);


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

    private function clickHandlers(event:FlexEvent):void {


        if (this.currentState == "State1") {
            this.loadAuctionPreviewBtn.addEventListener(FlexEvent.CREATION_COMPLETE, btn_creationCompleteHandler);
            this.auctionViewItemBtn.addEventListener(MouseEvent.CLICK, auctionViewItemBtn_clickHandler);
        }

        if (this.currentState == "State2") {
            this.xmlItemsDBInfo.addEventListener(MouseEvent.CLICK, xmlItemsDBInfo_clickHandler)
            this.loadItemPreviewBtn.addEventListener(FlexEvent.CREATION_COMPLETE, btn_creationCompleteHandler);
            this.viewAuctionDisplayBtn.addEventListener(MouseEvent.CLICK, viewAuctionDisplayBtn_clickHandler);
        }
    }

    private function btn_creationCompleteHandler(event:FlexEvent):void {
        var btn:Button;
        btn = event.target as Button;
        btn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);


    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function viewAuctionDisplayBtn_clickHandler(event:MouseEvent):void {
        this.currentState = "State1";
        clearPage1();
    }

    private function auctionViewItemBtn_clickHandler(event:MouseEvent):void {
        this.currentState = "State2";
        clearPage2();

    }

    private function itemrenderer1_creationCompleteHandler(event:Event):void {
        clearPage1();

    }

    //////////////////////////////////////////////////////////////////////////////////////

    private function auctionsXMLFail(event:Event):void {

        var obj:Object = new Object();
        obj = _xmlFileLoader.lastResult;
        obj;

    }

    private function auctionsXMLVerify(event:Event):void {

        _auctionFileXML = XML(_xmlFileLoader.lastResult);
        auctionFileXML;


        setUpAuctionDBData();

    }

    private function itemXMLFail(event:Event):void {

        var obj:Object = new Object();
        obj = _xmlFileLoader.lastResult;
        obj;

        _xmlFileLoader.removeEventListener(ResultEvent.RESULT, itemXMLVerify);
        _xmlFileLoader.removeEventListener(FaultEvent.FAULT, itemXMLFail);

    }

    //////////////////////////////////////////////////////////////////////////////////////

    private function itemXMLVerify(event:Event):void {

        _auctionItemFileXML = XML(_xmlFileLoader.lastResult);
        _auctionItemFileXML;


        _xmlFileLoader.removeEventListener(ResultEvent.RESULT, itemXMLVerify);
        _xmlFileLoader.removeEventListener(FaultEvent.FAULT, itemXMLFail);

        setUpItemFileData();

    }

    private function auctionsItemDBXMLFail(event:Event):void {

        var obj:Object = new Object();
        obj = _itemListFileLoader.lastResult;

    }

    private function auctionsItemDBXMLVerify(event:Event):void {

        _auctionItemsDBListXML = XML(_itemListFileLoader.lastResult);
        _auctionItemsDBListXML;

        setUpItemsDBData();
    }

    private function xmlItemsDBInfo_clickHandler(event:MouseEvent):void {
        var itemSelected:Object = new Object;

        itemSelected = xmlItemsDBInfo.selectedItem;

        _auctionItemDBXML = XML(itemSelected);

        if (itemSelected == null) {
            itemBidClear();
            return;
        }

        itemBidSetup();
        loadSelectedItemFileXML();

    }


}
}