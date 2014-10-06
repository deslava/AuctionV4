package components {
import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;

import spark.components.Button;

public class itemAdminTabNav extends itemAdminTabNavLayout {
    public function itemAdminTabNav() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, itemAdminTabNav_creationComplete);
    }

    private var _previousTab:int = -1;
    private var _currentTab:int = -1;

    private var _loginUserID:String = "";
    private var _userDBXML:XML;
    private var _auctionItemDBXML:XML = new XML();

    private var _currentEditState:String;

    public function get currentEditState():String {
        return _currentEditState;
    }

    public function set currentEditState(value:String):void {
        _currentEditState = value;
    }

    private var _auctionID:int;

    public function get auctionID():int {
        return _auctionID;
    }

    public function set auctionID(value:int):void {
        _auctionID = value;
    }

    private var _auctionFileXML:XML;

    public function get auctionFileXML():XML {
        return _auctionFileXML;
    }

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;
    }

    private var _auctionDBXML:XML;

    public function get auctionDBXML():XML {
        return _auctionDBXML;
    }

    public function set auctionDBXML(value:XML):void {
        _auctionDBXML = value;
    }

    private var _auctionItemFileXML:XML = new XML();

    public function get auctionItemFileXML():XML {
        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
    }

    public function clear():void {
        clearTab();
    }

    public function hideVideo():void {

        var active:Boolean;
        if (addItem4 == null)
            return;
        active = addItem4.initialized;
        if (active == false)
            return;

        addItem4.hideVideo();
    }

    protected function addItem2Clear():void {
        itemsTab1.enabled = false;
        itemsTab2.enabled = true;
        itemsTab3.enabled = true;
        itemsTab4.enabled = false;
        itemsTab5.enabled = true;

        item2Clear();
    }

    protected function addItem3Clear():void {
        //itemsTab0.enabled = true;
        itemsTab1.enabled = false;
        itemsTab2.enabled = false;
        itemsTab3.enabled = true;
        itemsTab4.enabled = true;
        itemsTab5.enabled = true;

        item3Clear();
    }

    protected function addItem4Clear():void {

        itemsTab1.enabled = false;
        itemsTab2.enabled = false;
        itemsTab3.enabled = false;
        itemsTab4.enabled = true;
        itemsTab5.enabled = true;

        item4Clear();

    }

    protected function addItem5Clear():void {

        itemsTab1.enabled = false;
        itemsTab2.enabled = false;
        itemsTab3.enabled = false;
        itemsTab4.enabled = false;
        itemsTab5.enabled = true;

    }

    protected function addItem1Clear():void {

        var active:Boolean;
        if (addItem1 == null)
            return;
        active = addItem1.initialized;
        if (active == false)
            return;


        if (_currentEditState == "New")
            addItem1.saveItemAddBtn.visible = true;
        else
            addItem1.saveItemAddBtn.visible = false;


        addItem1.currentState = "addItem";
        addItem1.auctionID = _auctionID;
        //addItem1.loginUserID = _loginUserID;
        addItem1.currentEditState = _currentEditState;
        addItem1.auctionFileXML = _auctionFileXML;
        addItem1.auctionItemFileXML = _auctionItemFileXML;
        addItem1.clear();

        addItem1.addEventListener(MouseEvent.CLICK, itemTab1_clickHandler);

    }

    protected function item2Clear():void {

        addItem2.auctionID = _auctionID;
        addItem2.currentEditState = currentEditState;
        //addItem2.loginUserID = loginUserID;
        addItem2.auctionItemFileXML = _auctionItemFileXML;
        addItem2.clear();
    }

    protected function item3Clear():void {

        var active:Boolean;
        if (addItem3 == null)
            return;
        active = addItem3.initialized;
        if (active == false)
            return;

        addItem3.auctionID = _auctionID;
        addItem3.currentEditState = currentEditState;
        //addItem2.loginUserID = loginUserID;
        addItem3.auctionItemFileXML = _auctionItemFileXML;
        addItem3.clear();


    }

    protected function item4Clear():void {

        var active:Boolean;
        if (addItem4 == null)
            return;
        active = addItem4.initialized;
        if (active == false)
            return;

        addItem4.auctionID = _auctionID;
        addItem4.currentEditState = currentEditState;
        //addItem4.loginUserID = loginUserID;
        addItem4.auctionItemFileXML = _auctionItemFileXML;
        addItem4.clear();

    }

    private function clearTab():void {
        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        AuctionItemNavClear();
    }

    private function AuctionEventListener():void {
        ItemAuctionTabNav.addEventListener(Event.CHANGE, tabNav_changeHandler);
    }

    private function savePreviousItemTab():void {


        if (_previousTab == 0) {
            _auctionItemFileXML = addItem1.auctionItemFileXML;

        }
        if (_previousTab == 1 && _currentTab != 0) {

            _auctionItemFileXML = addItem1.auctionItemFileXML;
            addItem1.saveFile();


        }
        if (_previousTab == 2) {

            _auctionItemFileXML = addItem2.auctionItemFileXML;
            addItem2.saveFile();


        }
        if (_previousTab == 3) {

            _auctionItemFileXML = addItem3.auctionItemFileXML;
            addItem3.saveFile();


        }
        if (_previousTab == 4) {
            addItem4.hideVideo();
            _auctionItemFileXML = addItem4.auctionItemFileXML;
            addItem4.saveFile();

        }
        if (_previousTab == 5) {
            addItem4.hideVideo();
            _currentEditState = "New"
            itemsTab1.enabled = true;
            itemsTab5.enabled = false;

        }
    }

    private function AuctionItemNavClear():void {
        var selectedTab:int = ItemAuctionTabNav.selectedIndex;

        ItemAuctionTabNav.selectedIndex = 1;
        _previousTab = -1;

        itemsTab0.enabled = true;
        itemsTab1.enabled = true;

        if (_currentEditState == "New") {
            itemsTab2.enabled = false;
        }
        else {
            itemsTab2.enabled = true;
        }

        itemsTab3.enabled = false;
        itemsTab4.enabled = false;
        itemsTab5.enabled = false;

        if (selectedTab == 1)
            addItem1Clear();
    }

    protected function itemAdminTabNav_creationComplete(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, itemAdminTabNav_creationComplete);
        AuctionEventListener()
    }

    protected function itemTab1_clickHandler(event:MouseEvent):void {
        var obj:Object;
        obj = event.target;
        obj;

        if (obj is Button) {
            obj;
        }
        else
            return;

        var name:String = obj.id;
        obj;
        if (name == "saveItemAddBtn") {
            _currentEditState = "Edit";
            _auctionItemFileXML = addItem1.auctionItemFileXML;
            itemsTab2.enabled = true;

        }

    }

    protected function tabNav_changeHandler(event:IndexChangedEvent):void {
        var currItem:Object = event.currentTarget;
        var name:String = currItem.selectedChild.label;

        _previousTab = _currentTab;
        _currentTab = ItemAuctionTabNav.selectedIndex;


        if (name == "item") {
            addItem4.hideVideo();
            savePreviousItemTab();
            _currentEditState = "New"
            _previousTab = -1;

            addItem1Clear();
            itemsTab1.enabled = true;
            itemsTab2.enabled = false;
            itemsTab3.enabled = false;
            itemsTab4.enabled = false;
            itemsTab5.enabled = false;

        }


        if (name == "Item Info") {
            savePreviousItemTab();
            addItem1Clear();
        }
        if (name == "Item Images") {
            savePreviousItemTab();
            addItem2Clear();

        }
        if (name == "Fees") {
            savePreviousItemTab();
            addItem3Clear();

        }

        if (name == "Videos") {

            savePreviousItemTab();
            addItem4Clear();

        }

        if (name == "Complete") {
            addItem4.hideVideo();
            savePreviousItemTab();
            addItem5Clear();

        }

    }
}

}