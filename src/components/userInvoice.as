/**
 * Created by Daniel Eslava on 5/13/2014.
 */
package components {
import auctionFunctionsClass.auctionItemListClass;
import auctionFunctionsClass.auctionsListClass;

import flash.display.InteractiveObject;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import spark.events.GridSelectionEvent;

public class userInvoice extends userInvoiceLayout {

    public function userInvoice() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, userInvoice_creationCompleteHandler);
    }

    public var currentEditState:String;
    private var _itemID:Number = 0;
    private var _auctionsListDBXML:XML = new XML();
    private var _auctionsItemListDBXML:XML = new XML();
    private var _auctionsList:auctionsListClass = new auctionsListClass();
    private var _itemsList:auctionItemListClass = new auctionItemListClass();
    private var _auctionItemDBXML:XML;
    private var xc1:XMLListCollection = new XMLListCollection;
    private var xc:XMLListCollection;

    private var _auctionID:Number;

    public function get auctionID():Number {
        return _auctionID;
    }

    private var _bidderID:Number = 0;

    public function get bidderID():Number {
        return _bidderID;
    }

    private var _sellerID:Number = 0;

    public function get sellerID():Number {
        return _sellerID;
    }

    private var _loginUserID:String = new String();

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _loginUserType:String = new String();

    public function get loginUserType():String {
        return _loginUserType;
    }

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    private var _invoiceType:String = new String();

    public function get invoiceType():String {
        _invoiceType = this.currentEditState.toString();
        return _invoiceType;
    }

    public function set invoiceType(value:String):void {
        _invoiceType = value;
    }

    public function clear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        assignUserInvoiceEvents();
        clearTab1();

    }

    public function clear2():void {

        itemsListHolder2.dataProvider = null;

        assignUserInvoiceEvents();

        loadBuyersList();
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

        _auctionsList.loadAuctionList(obj);
        _auctionsList.addEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        _auctionsList.addEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);
    }

    public function auctionsListDBXMLValid():void {

        assignAuctionLists();
    }

    private function clearTab1():void {

        xc = new XMLListCollection();
        xc1 = new XMLListCollection();

        auctionListDropDown.selectedIndex = -1;
        auctionListDropDown.dataProvider = null;
        itemsListHolder.selectedIndex = -1;

        auctionListDropDown.dataProvider = null;
        itemsListHolder.dataProvider = null;

        _auctionID = 0;

        if (_loginUserType != "Admin") {
            settlementInvoiceBtn.visible = false;
        }
        else {
            settlementInvoiceBtn.visible = true;
        }

        loadUserAuctions();
    }

    private function clearTab2():void {


        auctionListDropDown.selectedIndex = -1;
        itemsListHolder3.selectedIndex = -1;

        auctionListDropDown.dataProvider = null;
        itemsListHolder3.dataProvider = null;


        loadSellersList();
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function clearTab3():void {


        auctionListDropDown.selectedIndex = -1;
        itemsListHolder4.selectedIndex = -1;

        auctionListDropDown.dataProvider = null;
        itemsListHolder4.dataProvider = null;


        loadAuctionsList();
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignAuctionLists():void {

        if (_auctionsListDBXML == null)
            return;

        var productAttributes:XMLList = _auctionsListDBXML.auctionDB.name;
        var xl:XMLList = XMLList(productAttributes);
        xc = new XMLListCollection(xl);

        auctionListDropDown.dataProvider = xc.list;


    }

    private function assignUserInvoiceEvents():void {

        if (this.currentState == "userInvoiceSelect") {
            loadAuctionListBtn.addEventListener(MouseEvent.CLICK, loadAuctionListBtn_clickHandler);
            loadSoldItemBtn.addEventListener(MouseEvent.CLICK, loadSoldItemBtn_clickFunction);
            loadUnsoldItemBtn.addEventListener(MouseEvent.CLICK, loadUnsoldItemBtn_clickFunction);
            loadAuctionItemsBtn.addEventListener(MouseEvent.CLICK, loadAuctionItemsBtn_clickFunction);
            loadReserveItemsBtn.addEventListener(MouseEvent.CLICK, loadReserveItemsBtn_clickFunction);
            itemsListHolder.addEventListener(GridSelectionEvent.SELECTION_CHANGE, itemsListHolder_selectionChangeHandler);
            itemInvoiceBtn.addEventListener(MouseEvent.CLICK, itemInvoiceBtn_clickFunction);

            itemDisplayBtn.addEventListener(MouseEvent.CLICK, itemDisplay_clickHandler);
            buyerDisplayBtn.addEventListener(MouseEvent.CLICK, buyerDisplay_clickHandler);
            settlementInvoiceBtn.addEventListener(MouseEvent.CLICK, settlementInvoiceBtn_clickFunction);
            satelliteInvoiceBtn.addEventListener(MouseEvent.CLICK, satelliteInvoiceBtn_clickFunction);
        }

        if (this.currentState == "buyerInvoiceSelect") {
            //itemsListHolder2.addEventListener(GridSelectionEvent.SELECTION_CHANGE, itemsListHolder2_selectionChangeHandler);

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadBuyersList():void {
        if (_auctionID == 0)
            return;

        // TODO Auto-generated method stub
        var obj:Object = new Object();

        obj = _itemsList.blankOutItemVar(obj);
        obj.auctionID = _auctionID;
        obj.table1 = "loadSoldByBuyer";

        _itemsList.auctionID = _auctionID;
        _itemsList.loadAuctionItemList(obj);
        _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);

    }

    private function loadSellersList():void {
        if (_auctionID == 0)
            return;

        // TODO Auto-generated method stub
        var obj:Object = new Object();

        obj = _itemsList.blankOutItemVar(obj);
        obj.auctionID = _auctionID;
        obj.table1 = "loadSoldBySeller";

        _itemsList.auctionID = _auctionID;
        _itemsList.loadAuctionItemList(obj);
        _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);

    }

    private function loadAuctionsList():void {
        if (_auctionID == 0)
            return;

        // TODO Auto-generated method stub
        var obj:Object = new Object();

        obj = _itemsList.blankOutItemVar(obj);
        obj.auctionID = _auctionID;
        obj.table1 = "loadSoldByAuction";

        _itemsList.auctionID = _auctionID;
        _itemsList.loadAuctionItemList(obj);
        _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);

    }

    private function loadItemsList(items:XML):void {
        _auctionsItemListDBXML = items;

        var productAttributes:XMLList = _auctionsItemListDBXML.children();
        var xl:XMLList = XMLList(productAttributes);
        xc1 = new XMLListCollection(xl);


        if (this.currentState == "userInvoiceSelect")
            itemsListHolder.dataProvider = xc1.list;
        else if (this.currentState == "buyerInvoiceSelect")
            itemsListHolder2.dataProvider = xc1.list;
        else if (this.currentState == "sellerInvoiceSelect")
            itemsListHolder3.dataProvider = xc1.list;
        else if (this.currentState == "satteliteInvoiceSelect")
            itemsListHolder4.dataProvider = xc1.list;



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

    protected function loadSoldItemBtn_clickFunction(event:MouseEvent):void {

        if (_auctionID == 0)
            return;

        // TODO Auto-generated method stub
        var obj:Object = new Object();

        obj = _itemsList.blankOutItemVar(obj);
        obj.auctionID = _auctionID;
        obj.table1 = "loadSold";

        _itemsList.auctionID = _auctionID;
        _itemsList.loadAuctionItemList(obj);
        _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);
    }

    protected function loadUnsoldItemBtn_clickFunction(event:MouseEvent):void {
        if (_auctionID == 0)
            return;

        // TODO Auto-generated method stub
        var obj:Object = new Object();

        obj = _itemsList.blankOutItemVar(obj);
        obj.auctionID = _auctionID;
        obj.table1 = "loadUnsold";

        _itemsList.auctionID = _auctionID;
        _itemsList.loadAuctionItemList(obj);
        _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);
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

    ////////////////////////////////////////////////////////////////////////////////////////////////

    private function userInvoice_creationCompleteHandler(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, userInvoice_creationCompleteHandler);
        // this.dispatchEvent(event);
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadAuctionListBtn_clickHandler(event:MouseEvent):void {
        if (auctionListDropDown.selectedIndex == -1)
            return;

        loadSelectedAuctionItems()

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadReserveItemsBtn_clickFunction(event:MouseEvent):void {
        if (_auctionID == 0)
            return;

        // TODO Auto-generated method stub
        var obj:Object = new Object();

        obj = _itemsList.blankOutItemVar(obj);
        obj.auctionID = _auctionID;
        obj.table1 = "loadReserve";

        _itemsList.auctionID = _auctionID;
        _itemsList.loadAuctionItemList(obj);
        _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);

    }

    private function loadAuctionItemsBtn_clickFunction(event:MouseEvent):void {
        if (_auctionID == 0)
            return;

        // TODO Auto-generated method stub
        var obj:Object = new Object();

        obj = _itemsList.blankOutItemVar(obj);
        obj.auctionID = _auctionID;
        obj.table1 = "loadHouse";

        _itemsList.auctionID = _auctionID;
        _itemsList.loadAuctionItemList(obj);
        _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
        _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);
    }

    private function buyerDisplay_clickHandler(event:MouseEvent):void {

        if (_auctionID == 0)
            return;

        this.currentState = "buyerInvoiceSelect";
        clear2();

    }

    private function itemDisplay_clickHandler(event:MouseEvent):void {

        this.currentState = "userInvoiceSelect";
        assignUserInvoiceEvents();
        clearTab1();
    }

    private function settlementInvoiceBtn_clickFunction(event:MouseEvent):void {
        this.currentState = "sellerInvoiceSelect";
        assignUserInvoiceEvents();
        clearTab2();
    }

    private function satelliteInvoiceBtn_clickFunction(event:MouseEvent):void {
        this.currentState = "satteliteInvoiceSelect";
        assignUserInvoiceEvents();
        clearTab3();
    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }

    private function itemInvoiceBtn_clickFunction(event:MouseEvent):void {

        if (_auctionID == 0) {
            return;
        }
        else {
            currentEditState = "loadSelectedInvoices";
        }

        _itemsList;
        _itemsList.loadAllItemsListXML();
        _itemsList.addEventListener(ResultEvent.RESULT, invoiceListsDBVerify);

        bubbleMouseEvent(event);

    }

    private function invoiceListsDBVerify(event:ResultEvent):void {

        _auctionID;
        this.dispatchEvent(event);
        _itemsList.removeEventListener(ResultEvent.RESULT, invoiceListsDBVerify);
    }

    private function itemsListHolder_selectionChangeHandler(event:GridSelectionEvent):void {
        var node:Object = new Object();
        node = itemsListHolder.selectedItem;

        _auctionItemDBXML = node as XML;

        _bidderID = node.currBidWinner.toString();
        _sellerID = node.sellerId.toString();
        _itemID = node.itemId;
    }

    public function get auctionsItemListDBXML():XML {
        return _auctionsItemListDBXML;
    }

    public function get itemID():Number {
        return _itemID;
    }
}
}
