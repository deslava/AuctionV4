package components {

import auctionFunctionsClass.auctionClass;
import auctionFunctionsClass.auctionItemClass;
import auctionFunctionsClass.auctionItemListClass;
import auctionFunctionsClass.auctionsListClass;
import auctionFunctionsClass.userBidderClass;

import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import spark.events.DropDownEvent;
import spark.events.GridSelectionEvent;

public class houseNumberBid extends houseNumberBidLayout {

    public function houseNumberBid() {
        super();
    }

    private var _auctionID:Number;
    private var _itemID:Number;
    private var _auctionFileXML:XML = new XML();
    private var _auctionDBXML:XML = new XML();
    private var _auctionsListDBXML:XML = new XML();
    private var _auctionsItemListDBXML:XML = new XML();
    private var _auctionItemDBXML:XML;
    private var _auctionItemFileXML:XML;
    private var _userBidderListDB:XML = new XML();
    private var _auction:auctionClass = new auctionClass();
    private var _item:auctionItemClass = new auctionItemClass();
    private var _auctionsList:auctionsListClass = new auctionsListClass();
    private var _itemsList:auctionItemListClass = new auctionItemListClass();
    private var _bidderList:userBidderClass = new userBidderClass();
    private var xc1:XMLListCollection = new XMLListCollection;
    private var xc:XMLListCollection;
    private var xc2:XMLListCollection

    private var _loginUserType:String;

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    private var _loginUserID:String;

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _userFileXML:XML;

    public function set userFileXML(value:XML):void {
        _userFileXML = value;
    }

    public function clear():void {

        clearBidDisplayer();
    }

    public function loadUserAuctions():void {
        var node:XML;
        var obj:Object = new Object();

        obj = _auctionsList.blankOutAuctionVar(obj);
        obj = _auctionsList.loadAuctionsListObj(obj);

        if (_loginUserType == "Admin") {
            obj.searchVar = "";
        }
        if (_loginUserType == "Satellite") {
            obj.searchVar = _loginUserID;
        }

        if (_loginUserType == "Bidder") {

            obj.searchVar = "";
        }

        _auctionsList.loadAuctionList(obj);
        _auctionsList.addEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        _auctionsList.addEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);
    }

    public function auctionsListDBXMLValid():void {

        assignAuctionLists();
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function itemPublicFileViewDisplayComplete():void {


        itemPublicFileViewDisplay.clearAuction();

        itemPublicFileViewDisplay.visible = true;

        itemPublicFileViewDisplay.auctionID = _auctionID;
        itemPublicFileViewDisplay.itemID = _itemID;
        itemPublicFileViewDisplay.auctionDBXML = _auctionDBXML;
        itemPublicFileViewDisplay.auctionItemDBXML = _auctionItemDBXML;
        itemPublicFileViewDisplay.auctionItemFileXML = _auctionItemFileXML;
        itemPublicFileViewDisplay.loginUserID = _loginUserID;
        itemPublicFileViewDisplay.loginUserXML = _userFileXML;

        itemPublicFileViewDisplay.syncronizeAuction();
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function clearBidDisplayer():void {
        assignHouseNumberBidEvents();

        itemsListHolder.dataProvider = null;
        itemsListHolder.invalidateDisplayList();

        itemPublicFileViewDisplay.visible = false;
        itemPublicFileViewDisplay.clearAuction();
        itemPublicFileViewDisplay.clearItemPublicDisplay();

        loadUserAuctions();
        loadHouseNumbers();

    }

    private function assignAuctionLists():void {

        if (_auctionsListDBXML == null)
            return;

        var productAttributes:XMLList = _auctionsListDBXML.auctionDB.name;
        var xl:XMLList = XMLList(productAttributes);
        xc = new XMLListCollection(xl);

        auctionListDropDown.dataProvider = xc.list;


    }

    private function loadHouseNumbers():void {

        if (_loginUserType == "Bidder") {
            houseNumberDropDown.visible = false;
            houseLabelTxt.visible = false;
            return;

        }

        houseNumberDropDown.visible = true;
        houseLabelTxt.visible = true;


        _bidderList.loginUserID = _loginUserID;
        _bidderList.loginUserType = _loginUserType;

        _bidderList.searchBidderList();
        _bidderList.addEventListener(ResultEvent.RESULT, bidderListDBXMLVerify);
        _bidderList.addEventListener(FaultEvent.FAULT, bidderListDBXMLFail);


    }

    private function assignUserBidData():void {


        if (_userBidderListDB == null)
            return;

        var productAttributes:XMLList = _userBidderListDB.user.userId;
        var xl:XMLList = XMLList(productAttributes);
        xc2 = new XMLListCollection(xl);

        houseNumberDropDown.dataProvider = xc2.list;
    }


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignHouseNumberBidEvents():void {
        if (this.currentState == "houseBidSelect") {
            loadAuctionListBtn.addEventListener(MouseEvent.CLICK, loadAuctionListBtn_clickHandler);
            loadItemDisplayBtn.addEventListener(MouseEvent.CLICK, loadAuctionItemBtn_clickHandler);
            auctionListDropDown.addEventListener(DropDownEvent.CLOSE, auctionListDropDown_selectionChangeHandler);
            itemsListHolder.addEventListener(GridSelectionEvent.SELECTION_CHANGE, itemsListHolder_selectionChangeHandler);
            houseNumberDropDown.addEventListener(DropDownEvent.CLOSE, houseNumberDropDown_selectionChangeHandler);
        }

    }

    private function loadSelectedAuctionItems():void {

        var obj:Object = new Object();
        var selAuction:int;
        var url:String;


        selAuction = auctionListDropDown.selectedIndex;

        var node:XML = new XML();

        node = _auctionsListDBXML.auctionDB[selAuction];
        node;

        var selectedAuction:int;
        var selectedAuctionString:String;


        selectedAuctionString = node.id.toString();
        selectedAuction = int(selectedAuctionString);
        _auctionID = selectedAuction;

        _itemsList.auctionID = _auctionID;
        _itemsList.loadAuctionItemList();
        _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);
    }

    private function loadAuctionFileXML(url:String):void {
        _auction.auctionDBXML = _auctionDBXML;
        _auction.loadAuctionFileXML(url);
        _auction.addEventListener(ResultEvent.RESULT, loadAuctionXMLVerify);
        _auction.addEventListener(FaultEvent.FAULT, loadAuctionXMLFail);

    }

    private function loadSelectedItemFileXML():void {

        var url:String = _auctionItemDBXML.info_xml.toString();
        _itemID = _auctionItemDBXML.itemId;

        if (url == "")
            return;

        loadAuctionItemXML(url);
    }

    private function loadAuctionItemXML(url:String):void {

        _item = new auctionItemClass();

        _item.loadItemFileXML(url);

        _item.addEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.addEventListener(FaultEvent.FAULT, auctionItemXMLFail);

    }

    private function loadItemsList(items:XML):void {
        _auctionsItemListDBXML = items;

        var productAttributes:XMLList = _auctionsItemListDBXML.children();
        var xl:XMLList = XMLList(productAttributes);
        xc1 = new XMLListCollection(xl);

        itemsListHolder.dataProvider = xc1.list;

    }

    public function auctionItemXMLFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);

        _item.removeEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.removeEventListener(FaultEvent.FAULT, auctionItemXMLFail);

        this.dispatchEvent(event);

    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function auctionItemXMLVerify(event:ResultEvent):void {

        var obj:Object;

        obj = XML(event.result);
        _item.removeEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.removeEventListener(FaultEvent.FAULT, auctionItemXMLFail);

        var node:XML;
        node = obj.item[0] as XML;

        _auctionItemFileXML = node;
    }

    protected function auctionsListDBXMLFail(event:FaultEvent):void {

        _auctionsList.removeEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        _auctionsList.removeEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);

    }

    protected function auctionsListDBXMLVerify(event:ResultEvent):void {
        var obj:Object;

        _auctionsListDBXML = XML(event.result);

        _auctionsList.removeEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        _auctionsList.removeEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);

        auctionsListDBXMLValid()

    }

    protected function houseNumberDropDown_selectionChangeHandler(event:DropDownEvent):void {
        var node:XML = new XML();
        var id:String;
        var index:int;

        if (houseNumberDropDown.selectedIndex == -1)
            return;

        node = houseNumberDropDown.selectedItem as XML;
        index = houseNumberDropDown.selectedIndex;

        _userFileXML = _userBidderListDB.user[index];

        _loginUserID = node.toString();

        node;
    }

////////////////////////////////////////////////////////////////////////////////////////////////

    protected function loadAuctionItemBtn_clickHandler(event:MouseEvent):void {
        if (auctionListDropDown.selectedIndex == -1)
            return;

        if (itemsListHolder.selectedIndex == -1)
            return;

        // if (houseNumberDropDown.selectedIndex == -1)
        //    return;

        itemPublicFileViewDisplayComplete();
    }

    protected function auctionListsDBFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(event.fault);
        _itemsList.removeEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.removeEventListener(FaultEvent.FAULT, auctionListsDBFail);
    }

    protected function auctionListsDBVerify(event:ResultEvent):void {
        var obj:Object;
        var status:String;

        obj = XML(event.result);
        obj;

        _itemsList.removeEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.removeEventListener(FaultEvent.FAULT, auctionListsDBFail);

        if (obj != null) {
            status = obj.toString();

            if (status == "delete ok") {

                loadSelectedAuctionItems();
            }


            else {
                var node:XML;
                node = obj as XML;

                _auctionsItemListDBXML = node;

                loadItemsList(_auctionsItemListDBXML);
            }

        }
    }

    protected function auctionListDropDown_selectionChangeHandler(event:DropDownEvent):void {

        if (auctionListDropDown.selectedIndex == -1)
            return;

        var obj:Object = new Object();
        var selAuction:int;
        var url:String;

        selAuction = auctionListDropDown.selectedIndex;

        _auctionDBXML = _auctionsListDBXML.auctionDB[selAuction];


        url = _auctionDBXML.auctionXML.toString();

        loadAuctionFileXML(url);

    }

    protected function loadAuctionXMLFail(event:FaultEvent):void {
        var obj:Object = new Object();

        obj = XML(event.fault);
        _auction.removeEventListener(ResultEvent.RESULT, loadAuctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, loadAuctionXMLFail);

    }


////////////////////////////////////////////////////////////////////////////////////////////////

    protected function loadAuctionXMLVerify(event:ResultEvent):void {
        _auctionFileXML = _auction.auctionFileXML;

        _auction.removeEventListener(ResultEvent.RESULT, loadAuctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, loadAuctionXMLFail);

    }

    ////////////////////////////////////////////////////////////////////////////////////////////////

    private function bidderListDBXMLVerify(event:ResultEvent):void {
        _userBidderListDB = XML(event.result);
        assignUserBidData();
    }

    private function bidderListDBXMLFail(event:FaultEvent):void {
    }

    private function loadAuctionListBtn_clickHandler(event:MouseEvent):void {
        if (auctionListDropDown.selectedIndex == -1)
            return;

        loadSelectedAuctionItems();

    }

    private function itemsListHolder_selectionChangeHandler(event:GridSelectionEvent):void {
        var obj:Object = new Object();
        var s:String;

        _auctionItemDBXML = itemsListHolder.selectedItem as XML;
        loadSelectedItemFileXML();

    }
}
}
