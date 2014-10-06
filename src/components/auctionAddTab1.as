package components {
import auctionFunctionsClass.auctionClass;
import auctionFunctionsClass.fileLoaderClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.components.DropDownList;

public class auctionAddTab1 extends auctionAddTab1Layout {
    public function auctionAddTab1() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab1_creationCompleteHandler);
    }

    public var _auction:auctionClass = new auctionClass();
    private var _auctionID:Number = -1;
    private var _auctionCategoriesXML:XML = new XML();
    private var _xmlStatesLoader:HTTPService = new HTTPService();
    private var _stateFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _xmlAuctionCategoriesLoader:HTTPService = new HTTPService();
    private var _auctionCategoryFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _xmlService:HTTPService = new HTTPService();
    private var _statesXML:XML;
    private var _xc:XMLListCollection;
    private var _xc1:XMLListCollection;

    private var _currentEditState:String = "New";

    public function get currentEditState():String {
        return _currentEditState;
    }

    public function set currentEditState(value:String):void {
        _currentEditState = value;

    }

    private var _fromAdminPage:Boolean = false;

    public function set fromAdminPage(value:Boolean):void {
        _fromAdminPage = value;
    }

    private var _loginUserID:String = new String();

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _userDBXML:XML = new XML();

    public function get userDBXML():XML {
        return _userDBXML;
    }

    public function set userDBXML(value:XML):void {
        _userDBXML = value;
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

    public function clear():void {
        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        clearTab();
        addAuctionTabEvents();

        if (_currentEditState == "New")
            this.saveAuctionTab1Btn.visible = true;
        else
            this.saveAuctionTab1Btn.visible = false;

    }

    public function clear2():void {

        clearTab2();
        addAuctionTabEvents()
    }

    public function saveFile():void {

        _auction.currentEditState = _currentEditState;
        _auctionFileXML = getAuctionFile();
        _auction.saveAuction(_auctionFileXML);

        this.enabled = false;

        _auction.addEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.addEventListener(FaultEvent.FAULT, auctionSaveFail);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public function loadAuctionCategories():void {


        var obj:Object = new Object();
        obj = blankOutObjVar(obj);
        obj.table1 = "Load";
        auctionCategoryXML(obj);

    }

    public function assignAuction():void {
        var d:Date = new Date();
        var value:int;

        if (_auctionFileXML.year.toString() != "") {
            d = new Date(_auctionFileXML.year, _auctionFileXML.month, _auctionFileXML.day);


            auctionCountDown.auctionDateTab.selectedDate = d;
            auctionNameTab.text = _auctionFileXML.name;
            statesTabAuctionCreate.selectedIndex;
            streetAuctionTab.text = _auctionFileXML.address;
            cityAuctionTab.text = _auctionFileXML.city;
            zipAuctionTab.text = _auctionFileXML.zipcode;
            auctionCategoryTab.selectedIndex;
            auctionCountDown.auctionHourTab.value = _auctionFileXML.hr;
            auctionCountDown.auctionMinuteTab.value = _auctionFileXML.min;

            assignStates();
            assignAuctionCategories();
            auctionCountDown.ampmTab.selectedIndex = valueTabSearch(auctionCountDown.ampmTab, _auctionFileXML.ampm);
            auctionCountDown.auctionDateTab.selectedDate = d;
            auctionCountDown.formatUserSelectedTime();
        }

        auctionCountDown.auctionDateTab.validateDisplayList();
        auctionCountDown.auctionDateTab.validateNow();


    }

    public function getAuctionFile():XML {
        var pass:Boolean = false;

        pass = checkAuctionTab1Info();
        return _auctionFileXML;
    }

    private function clearTab():void {

        auctionCategoryTab.selectedIndex = -1;
        auctionNameTab.enabled = true;
        auctionNameTab.errorString = "";
        auctionNameTab.text = "";

        statesTabAuctionCreate.enabled = true;
        statesTabAuctionCreate.selectedIndex = -1;

        streetAuctionTab.enabled = true;
        streetAuctionTab.errorString = "";
        streetAuctionTab.text = "";

        cityAuctionTab.enabled = true;
        cityAuctionTab.errorString = "";
        cityAuctionTab.text = "";

        zipAuctionTab.enabled = true;
        zipAuctionTab.errorString = "";
        zipAuctionTab.text = "";

        saveAuctionTab1Btn.enabled = true;

        auctionCountDown.clear();
        auctionCountDown.auctionDateTab.invalidateDisplayList();
        auctionCountDown.auctionDateTab.validateNow();

        loadStatesXML();
        loadAuctionCategories();
        loadAuctionXML();

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadAuctionXML():void {

        _auction = new auctionClass();
        _auction.addEventListener(ResultEvent.RESULT, auctionXMLVerify);
        _auction.addEventListener(FaultEvent.FAULT, auctionXMLFail);

        if (_currentEditState == "New")
            _auction.createAuction();
        else {
            _auction.auctionFileXML = _auctionFileXML;
            assignAuction();
        }

    }

    private function clearTab2():void {

        newAuctionCategory.text = "";
        errorEventTypeLabel.text = "";
        auctionCategoryHolder.dataProvider = _xc1.list;
    }

    private function addAuctionTabEvents():void {

        if (this.currentState == "auctionEditInfo") {
            saveAuctionTab1Btn.addEventListener(MouseEvent.CLICK, clickFunction);
            saveAuctionTab1Btn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);

            addEventTypeAuctionBtn.addEventListener(MouseEvent.CLICK, addEventTypeAuctionBtn_clickHandler);

        }

        else if (this.currentState == "addAuctionCategory") {

            eventTypeCreateBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            eventTypePnl.addEventListener(CloseEvent.CLOSE, eventTypePnl_closeHandler);

        }
    }

    private function loadStatesXML():void {

        var url:String = "fileRead.php";
        var obj:Object = new Object();
        obj.fileName = "UsStates.xml";

        _xmlStatesLoader = _stateFileLoader.xmlFileLoader;

        _xmlStatesLoader.addEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        _xmlStatesLoader.addEventListener(FaultEvent.FAULT, loadStatesXMLFail);

        _stateFileLoader.loadXML(url, obj);


    }

    private function loadStates():void {

        var productAttributes:XMLList = _statesXML.state.attribute("label");
        var xl:XMLList = XMLList(productAttributes);
        _xc = new XMLListCollection(xl);

        assignStates();
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignStates():void {
        if (_xc == null)
            return;

        statesTabAuctionCreate.dataProvider = _xc.list;

        if (_currentEditState == "Edit")
            statesTabAuctionCreate.selectedIndex = valueTabSearch(statesTabAuctionCreate, _auctionFileXML.auctionState);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionCategoryXML(obj:Object):void {
        var url:String;
        url = "auctionCategories.php";

        _xmlAuctionCategoriesLoader = _auctionCategoryFileLoader.xmlFileLoader;
        _xmlAuctionCategoriesLoader.addEventListener(ResultEvent.RESULT, auctionCategoryVerify);
        _xmlAuctionCategoriesLoader.addEventListener(FaultEvent.FAULT, auctionCategoryFail);

        _auctionCategoryFileLoader.loadXML(url, obj);

    }

    private function auctionCategoryVerifyValid():void {

        var obj:Object = new Object();

        if (_auctionCategoriesXML.toString() == "ok") {
            obj = blankOutObjVar(obj);
            obj.table1 = "Load";
            auctionCategoryXML(obj);

        }

        else if (_auctionCategoriesXML.toString() == "Error") {
            errorEventTypeLabel.text = "That Category Already Exists";
        }

        else {

            loadAuctionCategoriesXML(_auctionCategoriesXML);
            assignAuctionCategories();
        }

    }

    private function loadAuctionCategoriesXML(xml:XML):void {

        var productAttributes:XMLList = xml.children();
        var xl:XMLList = XMLList(productAttributes);
        _xc1 = new XMLListCollection(xl);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignAuctionCategories():void {

        if (_xc1 == null)
            return;

        if (this.currentState == "auctionEditInfo") {
            auctionCategoryTab.dataProvider = _xc1.list;
            auctionCategoryTab.selectedIndex = -1;

            if (_currentEditState == "Edit")
                auctionCategoryTab.selectedIndex = valueTabSearch(auctionCategoryTab, _auctionFileXML.auctionCategory);

        }

        else if (this.currentState == "addAuctionCategory") {
            auctionCategoryHolder.dataProvider = _xc1.list;
            auctionCategoryHolder.selectedIndex = -1;
        }
    }

    private function checkAuctionTab1Info():Boolean {

        var pass:Boolean = false;

        pass = true;

        if (_loginUserID == "") {
            _loginUserID = "1000";
        }

        _auctionFileXML.sataliteID = _loginUserID;
        auctionInfoAddError.text = "";
        auctionNameTab.errorString = "";
        streetAuctionTab.errorString = "";
        cityAuctionTab.errorString = "";
        zipAuctionTab.errorString = "";
        _auctionFileXML.name = auctionNameTab.text;
        _auctionFileXML.auctionState = statesTabAuctionCreate.selectedItem;
        _auctionFileXML.address = streetAuctionTab.text;
        _auctionFileXML.city = cityAuctionTab.text;
        _auctionFileXML.zipcode = zipAuctionTab.text;

        _auctionFileXML.auctionCategory = auctionCategoryTab.selectedItem;
        _auctionFileXML.hr = auctionCountDown.auctionHourTab.value;
        _auctionFileXML.min = auctionCountDown.auctionMinuteTab.value;
        _auctionFileXML.sec = 0;
        _auctionFileXML.ampm = auctionCountDown.ampmTab.selectedItem;
        _auctionFileXML.isoTime = auctionCountDown.selectedDate.getTime();
        _auctionFileXML.timeZone = auctionCountDown.timeZoneString;

        var z1:String = _auctionFileXML.hr.toString();
        var z2:String = _auctionFileXML.min.toString();
        var z3:String = auctionCountDown.ampmTab.selectedItem.toString();
        var z4:String = auctionCountDown.timeZoneString;


        z1 = zeroTime(z1);
        z2 = zeroTime(z2);

        _auctionFileXML.endTime = auctionCountDown.auctionDateTab.selectedDate.toDateString() + " " + z1 + ":" + z2 + " " + z3 + " " + z4;
        _auctionFileXML.date = auctionCountDown.auctionDateTab.selectedDate;

        _auctionFileXML.year = auctionCountDown.auctionDateTab.displayedYear;
        _auctionFileXML.month = auctionCountDown.auctionDateTab.displayedMonth;
        _auctionFileXML.day = auctionCountDown.auctionDateTab.selectedDate.date;

        return(pass);

    }

    private function zeroTime(s:String):String {

        if (s.length < 2)
            s = "0" + s;
        return s;

    }

    private function valueTabSearch(list:DropDownList, searchVar:String):int {
        var x:int = 0;
        var obj:Object = list.dataProvider;
        var xl:XMLList = obj.source as XMLList;
        var s:String;

        for (x = 0; x < xl.length(); x++) {
            s = xl[x].toString();

            if (s == searchVar)
                return x;

        }

        return (-1);

    }

    private function blankOutObjVar(obj:Object):Object {

        obj.searchVar = "";
        obj.table1 = "";


        return(obj);

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function auctionXMLFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);
        obj;

        _auction.removeEventListener(ResultEvent.RESULT, auctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionXMLFail);

        this.dispatchEvent(event);

    }

    public function auctionXMLVerify(event:ResultEvent):void {

        var obj:Object;
        var xml:XML;

        obj = XML(event.result);
        _auction.removeEventListener(ResultEvent.RESULT, auctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionXMLFail);

        xml = _auction.auctionFileXML;

        var node:XML;
        node = obj.auction[0] as XML;

        if (node != null) {
            _auctionFileXML = node;
            assignAuction();
            this.dispatchEvent(event);
            return;
        }
    }

    protected function addAuctionTab1_creationCompleteHandler(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab1_creationCompleteHandler);
        this.dispatchEvent(event);
    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }

    private function addEventTypeAuctionBtn_clickHandler(event:MouseEvent):void {
        this.currentState = "addAuctionCategory";
        clear2();

    }

    private function eventTypePnl_closeHandler(event:CloseEvent):void {

        this.currentState = "auctionEditInfo";
        assignAuctionCategories();

    }

    private function clickFunction(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;

        var node:XML = new XML();
        var obj:Object = new Object();

        if (name == "saveAuctionTab1Btn") {
            saveFile();
        }


        if (name == "eventTypeCreateBtn") {

            errorEventTypeLabel.text = "";

            if (newAuctionCategory.text.length < 4) {
                errorEventTypeLabel.text = "Enter a Valid Event Type";
                return;
            }

            obj = blankOutObjVar(obj);
            obj.searchVar = newAuctionCategory.text;
            obj.table1 = "Add";
            auctionCategoryXML(obj);

        }

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionSaveFail(event:FaultEvent):void {
        _currentEditState = "New";

        this.enabled = true;

        _auction.removeEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionSaveFail);
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionSaveVerify(event:ResultEvent):void {
        _currentEditState = "Edit";
        _auction.currentEditState = "Edit";

        this.enabled = true;

        _auction.removeEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionSaveFail);

    }

    private function loadStatesXMLFail(event:Event):void {

        var obj:Object = new Object();

        obj = _xmlStatesLoader.lastResult;

        _xmlStatesLoader.removeEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        _xmlStatesLoader.removeEventListener(FaultEvent.FAULT, loadStatesXMLFail);

    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadStatesXMLVerify(event:Event):void {

        var obj:Object = new Object();
        obj = _xmlStatesLoader.lastResult;

        _statesXML = new XML();
        var s:String;
        _statesXML = XML(_xmlStatesLoader.lastResult);

        _xmlStatesLoader.removeEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        _xmlStatesLoader.removeEventListener(FaultEvent.FAULT, loadStatesXMLFail);

        loadStates();
    }

    private function auctionCategoryFail(event:Event):void {

        _xmlAuctionCategoriesLoader.removeEventListener(ResultEvent.RESULT, auctionCategoryVerify);
        _xmlAuctionCategoriesLoader.removeEventListener(FaultEvent.FAULT, auctionCategoryFail);
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionCategoryVerify(event:Event):void {

        _auctionCategoriesXML = new XML();
        _auctionCategoriesXML = XML(_xmlAuctionCategoriesLoader.lastResult);
        _xmlAuctionCategoriesLoader.removeEventListener(ResultEvent.RESULT, auctionCategoryVerify);
        _xmlAuctionCategoriesLoader.removeEventListener(FaultEvent.FAULT, auctionCategoryFail);
        auctionCategoryVerifyValid();

    }


}
}