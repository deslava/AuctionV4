package components {
import auctionFunctionsClass.auctionClass;
import auctionFunctionsClass.auctionItemClass;
import auctionFunctionsClass.auctionItemListClass;
import auctionFunctionsClass.auctionsListClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import spark.events.GridSelectionEvent;

[Event(name="Click", type="flash.events.MouseEvent")]

public class auctionLoader extends auctionLoaderLayout {
    public function auctionLoader() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, auctionLoader_creationCompleteHandler);
    }

    private var _itemID:int;
    private var _loginUserXML:XML = new XML();
    private var _auctionsListDBXML:XML = new XML();
    private var _auction:auctionClass = new auctionClass();
    private var _itemsList:auctionItemListClass = new auctionItemListClass();
    private var xc:XMLListCollection = new XMLListCollection;
    private var xc1:XMLListCollection = new XMLListCollection;

    private var _currentEditState:String;

    public function get currentEditState():String {
        return _currentEditState;
    }

    public function set currentEditState(value:String):void {
        _currentEditState = value;
    }

    private var _loginUserID:String;

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _auctionID:int;

    public function get auctionID():int {
        return _auctionID;
    }

    public function set auctionID(value:int):void {
        _auctionID = value;
    }

    private var _loginUserType:String = "Admin";

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    private var _auctionFileXML:XML = new XML();

    public function get auctionFileXML():XML {
        return _auctionFileXML;
    }

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;
    }

    private var _auctionDBXML:XML = new XML();

    public function get auctionDBXML():XML {
        return _auctionDBXML;
    }

    public function set auctionDBXML(value:XML):void {
        _auctionDBXML = value;
    }

    private var _auctionsList:auctionsListClass = new auctionsListClass();

    public function get auctionsList():auctionsListClass {
        return _auctionsList;
    }

    public function set auctionsList(value:auctionsListClass):void {
        _auctionsList = value;
    }

    private var _item:auctionItemClass = new auctionItemClass();

    public function get item():auctionItemClass {
        return _item;
    }

    public function set item(value:auctionItemClass):void {
        _item = value;
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

    public function clear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        clearTab();
        _currentEditState = "New";
        loadUserAuctions();
    }

    public function deleteAuction():void {

        _auction.addEventListener(ResultEvent.RESULT, deleteAuctionXMLVerify);
        _auction.addEventListener(FaultEvent.FAULT, deleteAuctionXMLFail);

        _auction.deleteAuction();
        this.enabled = false;
        deleteAuctionAdminPnl.enabled = false;
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

        _auctionsList.loadAuctionList(obj);
        _auctionsList.addEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        _auctionsList.addEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);


    }

    public function loadUserData(node:XML):void {

        this.currentState = "auctionLoader";

        _loginUserXML = node;
        _loginUserType = node.userType;

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function clearTab():void {
        this.enabled = true;
        assignAuctionLoaderEvents();
        activateAuctionBtn.label = "Activate Auction";

        auctionListHolder.dataProvider = null;
        auctionListHolder.invalidateDisplayList();
    }

    private function assignAuctionLoaderEvents():void {

        if (this.currentState == "auctionLoader") {
            createAuctionAdminPageBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            createAuctionAdminPageBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);

            editAuctionBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            editAuctionBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);

            previewAuctionBtn.addEventListener(MouseEvent.CLICK, clickFunction);

            addAuctionItemsBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            //addAuctionItemsBtn.addEventListener(MouseEvent.CLICK,  bubbleMouseEvent);

            previewAuctionItemsListBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            //editAuctionItemsBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);

            activateAuctionBtn.addEventListener(MouseEvent.CLICK, clickFunction);


            addUserPrivateAuctionBtn.addEventListener(MouseEvent.CLICK, clickFunction);

            auctionListHolder.addEventListener(GridSelectionEvent.SELECTION_CHANGE, auctionListHolder_selectionChangeHandler);

            deleteAuctionBtn.addEventListener(MouseEvent.CLICK, deleteAuctionBtn_clickHandler);

            //addUserPrivateAuctionBtn.addEventListener(MouseEvent.CLICK, addUserPrivateAuctionBtn_clickHandler);

        }

        if (this.currentState == "itemsLoader") {

            previewAuctionItemBtn.addEventListener(MouseEvent.CLICK, clickFunction);

            editAuctionItemBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            editAuctionItemBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);

            deleteAuctionItemBtn.addEventListener(MouseEvent.CLICK, clickFunction);

            backToAuctionBtn.addEventListener(MouseEvent.CLICK, AuctionBtn_clickHandler);
            itemsListHolder.addEventListener(GridSelectionEvent.SELECTION_CHANGE, itemsListHolder_selectionChangeHandler);

        }

        if (this.currentState == "deleteAuction") {

            deleteSelectedAuctionBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            deleteAuctionAdminPnl.addEventListener(CloseEvent.CLOSE, deleteAuctionAdminPnl_closeHandler);
            yesDeleteAuctionBtn.addEventListener(MouseEvent.CLICK, yesDeleteAuctionBtn_clickHandler);
        }

        if (this.currentState == "privateAuctionAdd") {

            userSearchBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            addPrivateUserBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            removePrivateUserBtn.addEventListener(MouseEvent.CLICK, clickFunction);

            //returnPrivateAuctionBtn.addEventListener(MouseEvent.CLICK, returnPrivateAuctionBtn_clickHandler);

        }

    }

    private function loadAuctionItemXML(url:String):void {

        _item = new auctionItemClass();

        _item.loadItemFileXML(url);

        _item.addEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.addEventListener(FaultEvent.FAULT, auctionItemXMLFail);

    }

    private function loadSelectedAuctionItems():void {


        if (auctionListHolder.selectedIndex != -1) {

            _auctionDBXML = auctionListHolder.selectedItem as XML;
            _auctionID = _auctionDBXML.id;

            _itemsList.auctionID = _auctionID;
            _itemsList.loadAuctionItemList();
            _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
            _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);

        }

    }

    private function itemDelete():void {

        var obj:Object = new Object();
        var url:String;

        if (itemsListHolder.selectedIndex == -1) {

            return;

        }
        else {
            _auctionItemDBXML = itemsListHolder.selectedItem as XML;
            _itemID = _auctionItemDBXML.itemId;

            _itemsList.auctionID = _auctionID;
            _itemsList.auctionItemDBXML = _auctionItemDBXML;
            _itemsList.deleteItemFromList(_itemID);
            _itemsList.addEventListener(ResultEvent.RESULT, auctionListsDBVerify);
            _itemsList.addEventListener(FaultEvent.FAULT, auctionListsDBFail);


        }

    }

    private function loadItemsList(items:XML):void {
        _auctionsListDBXML = items;

        var productAttributes:XMLList = _auctionsListDBXML.children();
        var xl:XMLList = XMLList(productAttributes);
        xc1 = new XMLListCollection(xl);

        itemsListHolder.dataProvider = xc1.list;

    }

    private function loadAuctionFileXML(url:String):void {
        _auction.auctionDBXML = _auctionDBXML;
        _auction.loadAuctionFileXML(url);
        _auction.addEventListener(ResultEvent.RESULT, loadAuctionXMLVerify);
        _auction.addEventListener(FaultEvent.FAULT, loadAuctionXMLFail);

    }

    private function updateAuctionStatusBtn():void {

        if (auctionListHolder.selectedIndex == -1) {
            return;
        }
        var status:String;

        status = _auctionFileXML.status.toString();

        if (status == "Active") {
            activateAuctionBtn.label = "Deactivate Auction";
        }

        else if (status == "Inactive" || status == "") {
            activateAuctionBtn.label = "Activate Auction";
        }


    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadAuctionsList(node:XML):void {

        this.currentState = "auctionLoader";

        var productAttributes:XMLList = node.children();
        var xl:XMLList = XMLList(productAttributes);
        xc = new XMLListCollection(xl);

        auctionListHolder.dataProvider = xc.list;

        auctionListHolder.invalidateDisplayList();

    }

    private function activateAuctionCalender():void {
        _auction.activateAuction();

        _auction.addEventListener(ResultEvent.RESULT, activateAuctionVerify);
        _auction.addEventListener(FaultEvent.FAULT, activateAuctionFail);
    }

    public function auctionLoader_creationCompleteHandler(event:FlexEvent):void {
        this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, auctionLoadComState);
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, auctionLoader_creationCompleteHandler);
        //this.dispatchEvent(event);

    }

    public function auctionItemXMLFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);

        _item.removeEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.removeEventListener(FaultEvent.FAULT, auctionItemXMLFail);

        this.dispatchEvent(event);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function auctionItemXMLVerify(event:ResultEvent):void {

        var obj:Object;

        obj = XML(event.result);
        _item.removeEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.removeEventListener(FaultEvent.FAULT, auctionItemXMLFail);

        //xml = _item.auctionItemFileXML;

        var node:XML;
        node = obj.item[0] as XML;

        _auctionItemFileXML = node;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function itemsListHolder_selectionChangeHandler(event:GridSelectionEvent):void {
        var s:String;
        var url:String;

        _auctionItemDBXML = itemsListHolder.selectedItem as XML;
        _itemID = _auctionItemDBXML.id;

        url = _auctionItemDBXML.info_xml.toString();

        loadAuctionItemXML(url);
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

                _auctionsListDBXML = node;

                loadItemsList(_auctionsListDBXML);
            }

        }
    }

    protected function loadAuctionXMLFail(event:Event):void {

        _auction.removeEventListener(ResultEvent.RESULT, loadAuctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, loadAuctionXMLFail);

    }

    protected function loadAuctionXMLVerify(event:Event):void {
        _auctionFileXML = _auction.auctionFileXML;

        _auction.removeEventListener(ResultEvent.RESULT, loadAuctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, loadAuctionXMLFail);

        updateAuctionStatusBtn();
    }

    protected function deleteAuctionXMLFail(event:FaultEvent):void {
        this.enabled = true;
        _auction.removeEventListener(ResultEvent.RESULT, deleteAuctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, deleteAuctionXMLFail);
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function deleteAuctionXMLVerify(event:ResultEvent):void {
        var obj:Object = XML(event.result);

        loadUserAuctions();
        yesDeleteAuctionBtn.selected = false;
        deleteSelectedAuctionBtn.enabled = false;
        this.enabled = true;
        deleteAuctionAdminPnl.enabled = true;
        _auction.removeEventListener(ResultEvent.RESULT, deleteAuctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, deleteAuctionXMLFail);

    }

    protected function auctionsListDBXMLFail(event:FaultEvent):void {

        _auctionsList.removeEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        _auctionsList.removeEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);

    }

    protected function auctionsListDBXMLVerify(event:ResultEvent):void {
        var obj:Object;

        this.currentState = "auctionLoader";
        _auctionsListDBXML = XML(event.result);
        loadAuctionsList(_auctionsListDBXML);

        _auctionsList.removeEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        _auctionsList.removeEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function activateAuctionFail(event:FaultEvent):void {
        _auction.removeEventListener(ResultEvent.RESULT, activateAuctionVerify);
        _auction.removeEventListener(FaultEvent.FAULT, activateAuctionFail);
    }

    protected function activateAuctionVerify(event:ResultEvent):void {


        _auction.removeEventListener(ResultEvent.RESULT, activateAuctionVerify);
        _auction.removeEventListener(FaultEvent.FAULT, activateAuctionFail);

        loadUserAuctions();

    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function clickFunction(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;

        if (name == "createAuctionAdminPageBtn") {
            _currentEditState = "New";

        }
        if (name == "editAuctionBtn") {
            _currentEditState = "Edit";

        }
        if (name == "previewAuctionBtn") {
            if (auctionListHolder.selectedIndex != -1) {
                _currentEditState = "View";

            }

            else {
                _currentEditState = "New";
            }
        }
        if (name == "addAuctionItemsBtn") {
            if (auctionListHolder.selectedIndex != -1) {
                _currentEditState = "New";
                bubbleMouseEvent(event);
            }
            else {
                _currentEditState = "View";
            }


        }

        if (name == "previewAuctionItemsListBtn") {
            _currentEditState = "Edit";
            this.currentState = "itemsLoader";
            loadSelectedAuctionItems();
        }

        if (name == "deleteAuctionItemBtn") {

            itemDelete();

        }

        if (name == "previewAuctionItemBtn") {
            if (itemsListHolder.selectedIndex == -1) {
                _currentEditState = "";
                return;

            }
            _currentEditState = "View";

        }

        if (name == "editAuctionItemBtn") {
            _currentEditState = "Edit";


        }

        if (name == "deleteSelectedAuctionBtn") {

            deleteAuction();

        }

        if (name == "addUserPrivateAuctionBtn") {

            //loadPrivateAuctionUsers();

        }


        if (name == "addPrivateUserBtn") {
            //obj = auctionLoaderCom.privateUserInfo();
            //addPrivateUserToAuction(obj);

        }

        if (name == "removePrivateUserBtn") {


        }


        if (name == "activateAuctionBtn") {

            activateAuctionCalender();
        }

    }

    private function AuctionBtn_clickHandler(event:MouseEvent):void {
        this.currentState = "auctionLoader";

        loadUserAuctions();
    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionLoadComState(event:StateChangeEvent):void {

        assignAuctionLoaderEvents();

        if (this.currentState == "auctionLoader") {
            loadAuctionsList(_auctionsListDBXML);
        }

        this.invalidateDisplayList();
    }

    private function auctionListHolder_selectionChangeHandler(event:GridSelectionEvent):void {

        var obj:Object = new Object();
        var s:String;
        var url:String;

        obj = this.auctionListHolder.selectedItem;
        s = obj.auctionView;

        _auctionDBXML = obj as XML;

        _auctionID = _auctionDBXML.id;

        if (s == "Private Auction")
            addUserPrivateAuctionBtn.enabled = true;
        else
            addUserPrivateAuctionBtn.enabled = false;

        url = obj.auctionXML;

        loadAuctionFileXML(url);

    }

    private function yesDeleteAuctionBtn_clickHandler(event:MouseEvent):void {

        if (yesDeleteAuctionBtn.enabled == true)
            deleteSelectedAuctionBtn.enabled = true;
    }

    private function deleteAuctionAdminPnl_closeHandler(event:CloseEvent):void {
        this.currentState = "auctionLoader";
        yesDeleteAuctionBtn.selected = false;
        deleteSelectedAuctionBtn.enabled = false;


    }

    private function deleteAuctionBtn_clickHandler(event:MouseEvent):void {
        if (auctionListHolder.selectedIndex != -1) {
            _auctionDBXML = auctionListHolder.selectedItem as XML;
            this.currentState = "deleteAuction";
            assignAuctionLoaderEvents();
        }

    }
}
}