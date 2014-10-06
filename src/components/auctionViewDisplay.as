package components {
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import flashx.textLayout.conversion.TextConverter;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;

import spark.components.Button;
import spark.components.DataGrid;
import spark.components.List;

public dynamic class auctionViewDisplay extends auctionViewDisplayLayout {
    public function auctionViewDisplay() {

        super();

        clearAuctionViewDisplay();
        itemPublicViewDisplay.addEventListener(FlexEvent.CREATION_COMPLETE, itemPublicViewDisplay_creationCompleteHandler);
    }

    private var _auctionInfoXML:XML = new XML;

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

    private var _auctionFileXML:XML = new XML;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function get auctionFileXML():XML {
        return _auctionFileXML;
    }

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;
    }

    private var _auctionItemFileXML:XML = new XML;

    public function get auctionItemFileXML():XML {
        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
    }

    public function clearAuction():void {

        clearAuctionViewDisplay();

    }

    public function syncronizeAuction():void {

        setUpAuctionFileData();
        setUpAuctionItemData();
    }

    private function clearAuctionViewDisplay():void {
        _auctionID = 0;
        _itemID = 0;
        _loginUserID = "";
        _auctionFileXML = new XML();
        _auctionItemFileXML = new XML();

        this.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, auctionViewDisplay_creationCompleteHandler);

    }

    private function setUpAuctionItemData():void {

        itemPublicViewDisplay.clearAuction();

        itemPublicViewDisplay.auctionID = _auctionID;
        itemPublicViewDisplay.itemID = _itemID;
        itemPublicViewDisplay.auctionItemFileXML = _auctionItemFileXML;
        itemPublicViewDisplay.option1Disable = true;

        itemPublicViewDisplay.syncronizeAuction();
    }

    private function setUpAuctionFileData():void {

        _auctionInfoXML = _auctionFileXML;
        _auctionID = _auctionFileXML.id;
        xmlFileInfo.text = _auctionFileXML.toString();
        displayAuctionFile(_auctionInfoXML);

    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignHighlightImagHolderToList(list:List):void {

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

    private function assignInspectionDateHolderToDataGrid(list:DataGrid):void {

        var node:XML = new XML();

        var xl:XMLList = XMLList(_auctionInfoXML.inspectionDates.children());
        var xc:XMLListCollection = new XMLListCollection(xl);
        list.dataProvider = xc.list;

    }

    private function assignPickDateHolderToDataGrid(list:DataGrid):void {

        var node:XML = new XML();

        var xl:XMLList = XMLList(_auctionInfoXML.pickupDates.children());
        var xc:XMLListCollection = new XMLListCollection(xl);
        list.dataProvider = xc.list;


    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function displayAuctionFile(_auctionInfoXML:XML):void {
        var countDownTimerComponent:countDownDisplay = countDownTimer as countDownDisplay;
        var s:String;

        auctionTitle.text = _auctionInfoXML.name;
        categoryDisplay.text = _auctionInfoXML.auctionCategory;
        dateTimevalues.text = _auctionInfoXML.endTime;
        locationValues.text = _auctionInfoXML.address + "\n" + _auctionInfoXML.city + ", " + _auctionInfoXML.auctionState + " " + _auctionInfoXML.zipcode;

        s = _auctionInfoXML.googleMap;

        //slowLoadingIFrameWithLoadIndicator0.content = s;


        s = _auctionInfoXML.rtAuctionDesInfo;
        auctionNotesText.text = _auctionInfoXML.AuctionDesInfo;
        auctionNotesText.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);

        s = _auctionInfoXML.rtDirectionMap;
        //mapDirectionsText.text = _auctionInfoXML.DirectionMap;
        //this.mapDirectionsText.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);

        s = _auctionInfoXML.rtInspectInfo;
        inspecitonNotesText.text = _auctionInfoXML.InspectInfo;
        inspecitonNotesText.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);

        s = _auctionInfoXML.rtPickUpInfo;
        pickupNotesText.text = _auctionInfoXML.PickUpInfo;
        pickupNotesText.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);

        s = _auctionInfoXML.rtShippingInfo;
        shippingNotesText.text = _auctionInfoXML.ShippingInfo;
        shippingNotesText.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);

        s = _auctionInfoXML.rtTermsInfo;
        termsNotesText.text = _auctionInfoXML.TermsInfo;
        termsNotesText.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);


        assignInspectionDateHolderToDataGrid(inspectionDateHolder0);


        assignPickDateHolderToDataGrid(pickupDatesHolder0);


        imgHolderHightlight.useVirtualLayout = false;
        imgHolderHightlight.dataProvider = null;
        imgHolderHightlight.validateNow();

        assignHighlightImagHolderToList(imgHolderHightlight);

        countDownTimerComponent.clear();
        var time:String = _auctionInfoXML.isoTime.toString();
        countDownTimerComponent.auctionTime = Number(time);

    }

    public function syncronizeAuctionItemRenderer(event:MouseEvent):void {

        _auctionID = itemPublicViewDisplay.auctionID;
        _itemID = itemPublicViewDisplay.itemID;
        //itemPublicViewDisplay.loadSelectedAuctionItemsDBXML();

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionViewDisplay_creationCompleteHandler(event:Event):void {
        syncronizeAuction();
    }

    private function itemPublicViewDisplay_creationCompleteHandler(event:FlexEvent):void {
        itemPublicViewDisplay.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);
        mapDisplayBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);
        imgHolderHightlight.addEventListener(Event.TAB_CHILDREN_CHANGE, bubbleMouseEvent);
        itemPublicViewDisplay.addEventListener(MouseEvent.CLICK, syncronizeAuctionItemRenderer);


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

}
}