package components {
import auctionFunctionsClass.auctionItemClass;
import auctionFunctionsClass.auctionItemsListClass;
import auctionFunctionsClass.fileLoaderClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import flashx.textLayout.conversion.TextConverter;

import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.components.Button;

public dynamic class itemPublicDisplay extends itemPublicDisplayLayout {


    public function itemPublicDisplay() {
        super();
        clearItemPublicDisplay();
    }

    private var _auctionItemsDBListXML:XML;
    private var _dataXML:XML = new XML;
    private var _xmlFileLoader:HTTPService;
    private var _itemListFileLoader:HTTPService;
    private var _auctionItemLists:auctionItemsListClass;
    private var _auctionItem:auctionItemClass;

    private var _option1Disable:Boolean = false;

    public function get option1Disable():Boolean {
        return _option1Disable;
    }

    public function set option1Disable(value:Boolean):void {
        _option1Disable = value;
    }

    private var _auctionID:Number;

    public function get auctionID():Number {
        return _auctionID;
    }

    public function set auctionID(num:Number):void {

        _auctionID = num;
    }

    private var _itemID:Number;

    public function get itemID():Number {
        return _itemID;
    }

    public function set itemID(num:Number):void {

        _itemID = num;
    }

    private var _auctionItemDBXML:XML;

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

    public function set auctionItemFileXML(xml:XML):void {

        _auctionItemFileXML = xml;

    }

    public function clearAuction():void {

        clearItemPublicDisplay();
        timeBidClear();

    }

    public function syncronizeAuction():void {

        clearPage1();
    }

    public function loadSelectedAuctionItemsDBXML():void {
        var auctionItemURL:String = "itemsXML.php"

        _itemListFileLoader = new HTTPService();

        _itemListFileLoader = _auctionItemLists.xmlFileLoader.xmlFileLoader;

        _auctionItemLists.xmlFileLoader.xmlFileLoader.addEventListener(ResultEvent.RESULT, auctionsItemDBXMLVerify);
        _auctionItemLists.xmlFileLoader.xmlFileLoader.addEventListener(FaultEvent.FAULT, auctionsItemDBXMLFail);

        _auctionItemLists.loadItemsListDBXML(auctionItemURL, _auctionID);

    }

    public function loadSelectedItemFileXML():void {

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

    public function loadItemFile(itemInfo:XML):void {

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

    ////////////////////////////////////////////////////////////////////////////////////

    protected function timeBidClear():void {

        var itemBidDisplay:itemCurrentBidDisplay = currentItemBidDisplay as itemCurrentBidDisplay;

        itemBidDisplay.auctionID = 0;
        itemBidDisplay.itemID = 0;
    }

    protected function itemBidSetup():void {

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
        itemBidDisplay.itemID = _auctionItemDBXML.itemId;
        _itemID = _auctionItemDBXML.itemId;

    }


    ////////////////////////////////////////////////////////////////////////////////////

    protected function setUpItemFileData():void {

        itemSelectedTxt.text = _auctionItemFileXML.toString();

        loadItemFile(_auctionItemFileXML);

    }

    protected function clearTab1():void {


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

    private function clearItemPublicDisplay():void {

        _auctionItemsDBListXML = new XML();

        _auctionItemDBXML = new XML();

        _auctionItemFileXML = new XML();

        _dataXML = new XML();

        _xmlFileLoader = new HTTPService();
        _itemListFileLoader = new HTTPService();

        _auctionItemLists = new auctionItemsListClass();
        _auctionItem = new auctionItemClass();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, itemPublicDisplay_creationCompleteHandler);

        disableMenuItems();

    }

    private function disableMenuItems():void {
        if (_option1Disable == false) {
            loadItemInfoBtn.visible = true;
            loadAuctionPreviewBtn.visible = true;
            loadItemPreviewBtn.visible = false;
        }
        else {
            loadItemInfoBtn.visible = false;
            loadAuctionPreviewBtn.visible = false;
            loadItemPreviewBtn.visible = true;
        }
    }

    private function clearPage1():void {

        clearPage1Data();
        disableMenuItems();

    }

    private function clearPage1Data():void {


        xmlItemsDBInfo.dataProvider = null;
        itemSelectedTxt.text = "";

        clearTab1();

        loadSelectedAuctionItemsDBXML();

    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function setUpItemsDBData():void {

        timeBidClear();

        _auctionItemLists.auctionItemsDBListXML = _auctionItemsDBListXML;
        xmlItemsDBInfo.dataProvider = _auctionItemLists.auctionItemsCollectionList();


    }

    protected function itemXMLFail(event:Event):void {

        var obj:Object = new Object();
        obj = _xmlFileLoader.lastResult;
        obj;

        _xmlFileLoader.removeEventListener(ResultEvent.RESULT, itemXMLVerify);
        _xmlFileLoader.removeEventListener(FaultEvent.FAULT, itemXMLFail);

    }

    protected function itemXMLVerify(event:Event):void {

        _auctionItemFileXML = XML(_xmlFileLoader.lastResult);
        _auctionItemFileXML;


        _xmlFileLoader.removeEventListener(ResultEvent.RESULT, itemXMLVerify);
        _xmlFileLoader.removeEventListener(FaultEvent.FAULT, itemXMLFail);

        setUpItemFileData();

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function xmlItemsDBInfo_clickHandler(event:MouseEvent):void {
        var itemSelected:Object = new Object;

        itemSelected = xmlItemsDBInfo.selectedItem;

        _auctionItemDBXML = XML(itemSelected);

        if (itemSelected == null) {
            timeBidClear();
            return;
        }

        itemBidSetup();
        loadSelectedItemFileXML();

    }

    private function itemPublicDisplay_creationCompleteHandler(event:FlexEvent):void {
        this.xmlItemsDBInfo.addEventListener(MouseEvent.CLICK, xmlItemsDBInfo_clickHandler);
        this.loadAuctionPreviewBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);
        this.loadItemPreviewBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);

        clearPage1();

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

    private function auctionsItemDBXMLFail(event:Event):void {

        var obj:Object = new Object();
        obj = _itemListFileLoader.lastResult;

    }

    private function auctionsItemDBXMLVerify(event:Event):void {

        _auctionItemsDBListXML = XML(_itemListFileLoader.lastResult);
        _auctionItemsDBListXML;

        setUpItemsDBData();
    }

}
}