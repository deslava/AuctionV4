package components {
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;

import spark.components.Button;

public class auctionAdminTabNav extends auctionAdminTabNavLayout {
    public function auctionAdminTabNav() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, auctionAdminTabNav_creationComplete);
    }

    private var _previousTab:int = -1;
    private var _currentTab:int = -1;
    private var _userDBXML:XML;

    private var _currentEditState:String;

    public function get currentEditState():String {
        return _currentEditState;
    }

    public function set currentEditState(value:String):void {
        _currentEditState = value;
    }

    private var _fromAdminPage:String = "no";

    public function set fromAdminPage(value:String):void {
        _fromAdminPage = value;
    }

    private var _loginUserID:String = "";

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _loginUserType:String;

    public function set loginUserType(value:String):void {
        _loginUserType = value;
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

        AuctionEventListener();
        clearTab();
    }

    public function loadSelectedAuction():void {

        if (addAuctionTab1.auctionListHolder.selectedIndex == -1)
            return;

        AuctionAdminTabNav.selectedIndex = 1;
        _auctionFileXML = addAuctionTab1.auctionFileXML;
        _auctionDBXML = addAuctionTab1.auctionDBXML;
        _currentEditState = "Edit"

    }

    public function stopAuctionTimer():void {

        addAuctionTab2.auctionCountDown.deactivateTimer();
    }

    protected function addAuctionTab1Clear():void {


        var active:Boolean;
        if (addAuctionTab1 == null)
            return;
        active = addAuctionTab1.initialized;
        addAuctionTab1.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab1_creationComplete);
        if (active == false)
            return;

        addAuctionTab1.addEventListener(MouseEvent.CLICK, auctionTab1_clickHandler);

        auctionTab1.enabled = true;
        auctionTab2.enabled = false;
        auctionTab3.enabled = false;
        auctionTab4.enabled = false;
        auctionTab5.enabled = false;
        auctionTab6.enabled = false;
        auctionTab7.enabled = false;
        auctionTab8.enabled = false;
        auctionTab9.enabled = false;
        auctionTab10.enabled = false;

        addAuctionTab1.loginUserID = _loginUserID;
        addAuctionTab1.loginUserType = _loginUserType;
        addAuctionTab1.clear();

        this.invalidateDisplayList();

    }

    protected function addAuctionTab2Clear():void {
        var active:Boolean;
        if (addAuctionTab2 == null)
            return;
        active = addAuctionTab2.initialized;
        addAuctionTab2.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab2_creationComplete);
        if (active == false)
            return;

        auctionTab1.enabled = true;
        auctionTab2.enabled = true;

        if (_currentEditState == "Edit") {
            auctionTab3.enabled = true;
            auctionTab10.enabled = true;
        }
        else {
            auctionTab3.enabled = false;
            auctionTab10.enabled = false;
        }

        auctionTab2.addEventListener(MouseEvent.CLICK, auctionTab2_clickHandler);

        if (_currentEditState == "New") {
            addAuctionTab2.saveAuctionTab1Btn.visible = true;
        }
        else {
            addAuctionTab2.saveAuctionTab1Btn.visible = false;
        }

        addAuctionTab2.currentEditState = _currentEditState;
        addAuctionTab2.auctionFileXML = _auctionFileXML;
        addAuctionTab2.loginUserID = _loginUserID;
        addAuctionTab2.auctionDBXML = _auctionDBXML;

        addAuctionTab2.clear();

        this.invalidateDisplayList();


        _fromAdminPage = "no";
    }

    protected function addAuctionTab3Clear():void {

        var active:Boolean;
        if (addAuctionTab3 == null)
            return;
        active = addAuctionTab3.initialized;
        addAuctionTab3.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab3_creationComplete);
        if (active == false)
            return;

        addAuctionTab3.currentEditState = _currentEditState;
        addAuctionTab3.loginUserID = _loginUserID;
        addAuctionTab3.auctionFileXML = _auctionFileXML;
        addAuctionTab3.clear();

        auctionTab2.enabled = false;
        auctionTab4.enabled = true;
    }

    protected function addAuctionTab4Clear():void {

        var active:Boolean;
        if (addAuctionTab4 == null)
            return;
        active = addAuctionTab4.initialized;
        addAuctionTab4.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab4_creationComplete);
        if (active == false)
            return;

        addAuctionTab4.currentEditState = _currentEditState;
        addAuctionTab4.loginUserID = _loginUserID;
        addAuctionTab4.auctionFileXML = _auctionFileXML;
        addAuctionTab4.clear();

        auctionTab3.enabled = false;
        auctionTab5.enabled = true;
    }

    protected function addAuctionTab5Clear():void {

        var active:Boolean;
        if (addAuctionTab5 == null)
            return;
        active = addAuctionTab5.initialized;
        addAuctionTab5.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab5_creationComplete);
        if (active == false)
            return;

        addAuctionTab5.currentEditState = _currentEditState;
        addAuctionTab5.loginUserID = _loginUserID;
        addAuctionTab5.auctionFileXML = _auctionFileXML;
        addAuctionTab5.clear();

        auctionTab4.enabled = false;
        auctionTab6.enabled = true;
    }

    protected function addAuctionTab6Clear():void {

        var active:Boolean;
        if (addAuctionTab6 == null)
            return;
        active = addAuctionTab6.initialized;
        addAuctionTab6.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab6_creationComplete);
        if (active == false)
            return;

        addAuctionTab6.currentEditState = _currentEditState;
        addAuctionTab6.loginUserID = _loginUserID;
        addAuctionTab6.auctionFileXML = _auctionFileXML;
        addAuctionTab6.clear();

        auctionTab5.enabled = false;
        auctionTab7.enabled = true;
    }

    protected function addAuctionTab7Clear():void {

        var active:Boolean;
        if (addAuctionTab7 == null)
            return;
        active = addAuctionTab7.initialized;
        addAuctionTab7.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab7_creationComplete);
        if (active == false)
            return;

        addAuctionTab7.currentEditState = _currentEditState;
        addAuctionTab7.loginUserID = _loginUserID;
        addAuctionTab7.auctionFileXML = _auctionFileXML;
        addAuctionTab7.clear();

        auctionTab6.enabled = false;
        auctionTab8.enabled = true;
    }

    protected function addAuctionTab8Clear():void {

        var active:Boolean;
        if (addAuctionTab8 == null)
            return;
        active = addAuctionTab8.initialized;
        addAuctionTab8.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab8_creationComplete);
        if (active == false)
            return;

        addAuctionTab8.currentEditState = _currentEditState;
        addAuctionTab8.loginUserID = _loginUserID;
        addAuctionTab8.auctionFileXML = _auctionFileXML;
        addAuctionTab8.clear();

        auctionTab7.enabled = false;
        auctionTab9.enabled = true;
    }

    protected function addAuctionTab9Clear():void {

        var active:Boolean;
        if (addAuctionTab9 == null)
            return;
        active = addAuctionTab9.initialized;
        addAuctionTab9.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab9_creationComplete);
        if (active == false)
            return;

        addAuctionTab9.currentEditState = _currentEditState;
        addAuctionTab9.loginUserID = _loginUserID;
        addAuctionTab9.auctionFileXML = _auctionFileXML;
        addAuctionTab9.clear();

        auctionTab8.enabled = false;
        auctionTab10.enabled = true;
    }

    protected function addAuctionTab10Clear():void {
        _currentEditState = "New"
    }

    private function clearTab():void {
        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        AuctionNavClear();


    }

    private function AuctionEventListener():void {
        AuctionAdminTabNav.addEventListener(Event.CHANGE, tabNav_changeHandler);
    }

    private function savePreviousAuctionTab():void {

        if (_previousTab == -1)
            return;
        else if (_previousTab == 0)
            return;

        if (_previousTab == 0) {
            if (_currentTab == 2) {
                _currentEditState = "Edit";
            }

        }


        else if (_previousTab == 1) {
            _auctionDBXML = addAuctionTab2.auctionDBXML;
            _auctionFileXML = addAuctionTab2.auctionFileXML;

            if (_currentEditState == "Edit")
                addAuctionTab2.saveFile();

        }
        else if (_previousTab == 2) {
            _auctionFileXML = addAuctionTab3.auctionFileXML;
            addAuctionTab3.saveFile();
            _currentEditState = "Edit";
        }
        else if (_previousTab == 3) {
            _auctionFileXML = addAuctionTab4.auctionFileXML;
            addAuctionTab4.saveFile();
            _currentEditState = "Edit";
        }

        else if (_previousTab == 4) {
            _auctionFileXML = addAuctionTab5.auctionFileXML;
            addAuctionTab5.saveFile();
            _currentEditState = "Edit";
        }
        else if (_previousTab == 5) {
            _auctionFileXML = addAuctionTab6.auctionFileXML;
            addAuctionTab6.saveFile();
            _currentEditState = "Edit";
        }
        else if (_previousTab == 6) {
            _auctionFileXML = addAuctionTab7.auctionFileXML;
            addAuctionTab7.saveFile();
            _currentEditState = "Edit";
        }

        else if (_previousTab == 7) {
            _auctionFileXML = addAuctionTab8.auctionFileXML;
            addAuctionTab8.saveFile();
            _currentEditState = "Edit";
        }

        else if (_previousTab == 8) {
            _auctionFileXML = addAuctionTab9.auctionFileXML;
            addAuctionTab9.saveFile();
            _currentEditState = "Edit"

        }


    }

    private function AuctionNavClear():void {

        auctionTab1.enabled = true;

        if (_fromAdminPage == "yes" && _currentEditState == "New") {
            _currentEditState = "Edit";
        }
        else if (_fromAdminPage == "yes" && _currentEditState == "Edit") {
            _fromAdminPage = "no"
        }

        if (_currentEditState == "New") {
            _auctionFileXML = new XML();
            _auctionDBXML = new XML();

            AuctionAdminTabNav.selectedIndex = 0;
            addAuctionTab1Clear();
            auctionTab2.enabled = false;
            auctionTab3.enabled = false;

            stopAuctionTimer();
        }
        else {
            if (_fromAdminPage == "yes") {
                _currentEditState = "New";
                auctionTab2.enabled = false;
                auctionTab3.enabled = false;

                stopAuctionTimer();
            }
            else {
                _currentEditState = "Edit";
                auctionTab2.enabled = true;
                auctionTab3.enabled = true;
            }

            AuctionAdminTabNav.selectedIndex = 1;
            addAuctionTab2Clear();
        }


        auctionTab4.enabled = false;
        auctionTab5.enabled = false;
        auctionTab6.enabled = false;
        auctionTab7.enabled = false;
        auctionTab8.enabled = false;
        auctionTab9.enabled = false;
        //auctionTab10.enabled = false;

        this.invalidateDisplayList();

    }

    protected function auctionAdminTabNav_creationComplete(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, auctionAdminTabNav_creationComplete);
        this.dispatchEvent(event);
    }

    protected function tabNav_changeHandler(event:IndexChangedEvent):void {
        var currItem:Object = event.currentTarget;
        var name:String = currItem.selectedChild.label;

        _previousTab = _currentTab;
        _currentTab = AuctionAdminTabNav.selectedIndex;


        if (name != "Auction Info") {
            stopAuctionTimer();
        }

        if (name == "Auction") {
            savePreviousAuctionTab();
            addAuctionTab1Clear();
        }

        else if (name == "Auction Info") {
            savePreviousAuctionTab();
            addAuctionTab2Clear();

        }
        else if (name == "Highlight Images") {
            savePreviousAuctionTab();
            addAuctionTab3Clear();
            auctionTab1.enabled = false;
            auctionTab2.enabled = false;
            auctionTab3.enabled = true;
            auctionTab4.enabled = true;


        }
        else if (name == "Auction Type") {
            savePreviousAuctionTab();
            addAuctionTab4Clear();
            auctionTab3.enabled = false;
            auctionTab5.enabled = true;

        }
        else if (name == "Auction Map") {
            savePreviousAuctionTab();
            addAuctionTab5Clear();
            auctionTab4.enabled = false;
            auctionTab6.enabled = true;


        }
        else if (name == "Inspection & Pick up Date") {
            savePreviousAuctionTab();
            addAuctionTab6Clear();
            auctionTab5.enabled = false;
            auctionTab7.enabled = true;


        }
        else if (name == "Shipping & Terms") {
            savePreviousAuctionTab();
            addAuctionTab7Clear();

            auctionTab6.enabled = false;
            auctionTab8.enabled = true;

        }
        else if (name == "Auction Description") {
            savePreviousAuctionTab();
            addAuctionTab8Clear();

            auctionTab7.enabled = false;
            auctionTab9.enabled = true;


        }

        else if (name == "Auction Fees") {
            savePreviousAuctionTab();
            addAuctionTab9Clear();

            auctionTab8.enabled = false;
            auctionTab10.enabled = true;


        }
        else if (name == "Complete") {
            savePreviousAuctionTab();
            auctionTab1.enabled = true;
            auctionTab2.enabled = false;
            auctionTab3.enabled = false;
            auctionTab4.enabled = false;
            auctionTab5.enabled = false;
            auctionTab6.enabled = false;
            auctionTab7.enabled = false;
            auctionTab8.enabled = false;
            auctionTab9.enabled = false;
            _currentEditState = "New";

        }

    }

    protected function auctionTab1_clickHandler(event:MouseEvent):void {
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


        if (name == "createAuctionAdminPageBtn") {
            AuctionAdminTabNav.selectedIndex = 1;
            _currentEditState = "New";
            addAuctionTab2Clear();
        }

        if (name == "editAuctionBtn") {
            loadSelectedAuction();
        }


        if (name == "previewAuctionBtn") {
            if (addAuctionTab1.currentEditState == "View") {
                _currentEditState = "View";
                _auctionFileXML = addAuctionTab1.auctionFileXML;
                bubbleMouseEvent(event);
            }
        }

        if (name == "addAuctionItemsBtn") {
            if (addAuctionTab1.currentEditState == "New") {
                _currentEditState = "New";
                _auctionID = addAuctionTab1.auctionID;
                _auctionFileXML = addAuctionTab1.auctionFileXML;
                bubbleMouseEvent(event);
            }
            else {
                _currentEditState = "View";
                _auctionFileXML = addAuctionTab1.auctionFileXML;
            }
        }

        if (name == "editAuctionItemBtn") {

            _currentEditState = "Edit";
            _auctionItemFileXML = addAuctionTab1.auctionItemFileXML;
            _auctionID = addAuctionTab1.auctionID;
            _auctionFileXML = addAuctionTab1.auctionFileXML;
            bubbleMouseEvent(event);
        }

        if (name == "previewAuctionItemBtn") {
            if (addAuctionTab1.currentEditState == "View") {

                _currentEditState = "View";
                _auctionID = addAuctionTab1.auctionID;
                _auctionFileXML = addAuctionTab1.auctionFileXML;
                _auctionItemFileXML = addAuctionTab1.auctionItemFileXML;
                _auctionItemDBXML = addAuctionTab1.auctionItemDBXML;
                bubbleMouseEvent(event);
            }
        }

    }

    protected function auctionTab2_clickHandler(event:MouseEvent):void {

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


        if (name == "saveAuctionTab1Btn") {
            addAuctionTab2.saveAuctionTab1Btn.visible = false;
            _previousTab = 1;
            _currentEditState = "Edit";
            _auctionFileXML = addAuctionTab2.auctionFileXML;
            addAuctionTab2Clear();
        }
    }

    protected function addAuctionTab1_creationComplete(event:FlexEvent):void {
        addAuctionTab1.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab1_creationComplete);
        addAuctionTab1Clear();


    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function addAuctionTab2_creationComplete(event:FlexEvent):void {
        addAuctionTab2.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab2_creationComplete);
        addAuctionTab2Clear();
        addAuctionTab2.addEventListener(MouseEvent.CLICK, auctionTab2_clickHandler);
    }

    protected function addAuctionTab3_creationComplete(event:FlexEvent):void {
        addAuctionTab3.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab3_creationComplete);
        addAuctionTab3Clear()
    }

    protected function addAuctionTab4_creationComplete(event:FlexEvent):void {
        addAuctionTab4.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab4_creationComplete);
        addAuctionTab4Clear()
    }

    protected function addAuctionTab5_creationComplete(event:FlexEvent):void {
        addAuctionTab5.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab5_creationComplete);
        addAuctionTab5Clear()
    }

    protected function addAuctionTab6_creationComplete(event:FlexEvent):void {
        addAuctionTab6.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab6_creationComplete);
        addAuctionTab6Clear()
    }

    protected function addAuctionTab7_creationComplete(event:FlexEvent):void {
        addAuctionTab7.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab7_creationComplete);
        addAuctionTab7Clear()
    }

    protected function addAuctionTab8_creationComplete(event:FlexEvent):void {
        addAuctionTab8.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab8_creationComplete);
        addAuctionTab8Clear()
    }

    protected function addAuctionTab9_creationComplete(event:FlexEvent):void {
        addAuctionTab9.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab9_creationComplete);
        addAuctionTab9Clear()
    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }


}
}