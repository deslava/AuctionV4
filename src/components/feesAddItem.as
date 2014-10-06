package components {
import auctionFunctionsClass.auctionClass;
import auctionFunctionsClass.auctionItemClass;
import auctionFunctionsClass.fileLoaderClass;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class feesAddItem extends feesAddLayout {
    public function feesAddItem() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, feesAdd_creationCompleteHandler);
    }

    private var _fileXML:XML = new XML();
    private var _feeLoaderXML:XML = new XML();
    private var _auction:auctionClass = new auctionClass();
    private var _item:auctionItemClass = new auctionItemClass();
    private var xc3:XMLListCollection = new XMLListCollection();
    private var xc2:XMLListCollection = new XMLListCollection();
    private var xc:XMLListCollection = new XMLListCollection();
    private var empty:XMLListCollection = new XMLListCollection();
    private var _xmlFeesFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _xmlFeesLoader:HTTPService = new HTTPService();

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

    private var _currentEditState:String = new String();

    public function get currentEditState():String {
        return _currentEditState;
    }

    public function set currentEditState(value:String):void {
        _currentEditState = value;
    }

    private var _auctionFileXML:XML = new XML();

    public function get auctionFileXML():XML {
        return _auctionFileXML;
    }

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;
        _fileXML = value;
    }

    private var _auctionItemFileXML:XML = new XML();

    public function get auctionItemFileXML():XML {
        return _auctionItemFileXML;

    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
        _fileXML = value;
    }

    public function clear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        clearTab();
        addFeeEvents();

    }

    public function clearTab():void {


        feeNameDropDown.selectedIndex = -1;
        feeAmountItem.text = "";
        feeTypeDropDown.selectedIndex = -1;

        auctionItemFeeHolder.dataProvider = null;
        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();


        feeTypeDropDown.dataProvider = xc2.list;
        feeTypeDropDown.selectedIndex = -1;

        loadAuctionXML();
        loadFeeCategories();
        loadAuctionFeeType();
        //loadFeeList();

        assignFeeCategories();
    }

    public function clear2():void {

        newFeeCategory.text = "";
        errorEventFeeLabel.text = "";
        addFeeEvents();
    }

    public function loadAuctionFeeType():void {
        var auctionFeeTypesXML:XML = <Types>
            <type id="$">$ Dollar</type>
            <type id="%">% Percent</type>
        </Types>;

        var productAttributes:XMLList = auctionFeeTypesXML.type.children();
        var xl:XMLList = XMLList(productAttributes);
        xc2 = new XMLListCollection(xl);

    }

    public function assignAuction():void {
        var s:String;

        auctionItemFeeHolder.dataProvider = null;
        auctionItemFeeHolder.dataProvider = empty.list;
        auctionItemFeeHolder.validateNow();

        var xl:XMLList = XMLList(_fileXML.auctionFees.children());
        xc2 = new XMLListCollection(xl);
        auctionItemFeeHolder.dataProvider = xc2.list;

        auctionItemFeeHolder.invalidateDisplayList();
    }

    public function getAuctionFile():XML {
        var pass:Boolean = false;

        return _fileXML;
    }

    public function saveFile():void {

        _item.currentEditState = _currentEditState;

        _auctionItemFileXML = _fileXML;
        _auctionItemFileXML = getAuctionFile();
        _item.auctionID = _auctionID;
        _item.saveItem(_auctionItemFileXML);
        _item.addEventListener(ResultEvent.RESULT, itemSaveVerify);
        _item.addEventListener(FaultEvent.FAULT, itemSaveFail);

    }

    public function loadFeeCategories():void {


        var obj:Object = new Object();
        obj = blankOutObjVar(obj);
        obj.table1 = "LoadAuctionFee";
        auctionFeesXML(obj);

    }

    public function auctionFeeVerifyValid():void {
        var obj:Object = new Object();
        var t:String;

        if (_feeLoaderXML.toString() == "ok") {
            loadFeeCategories();

        }

        else if (_feeLoaderXML.toString() == "Error") {
            errorEventFeeLabel.text = "That Category Already Exists";
        }

        else {
            feeCategoriesXML(_feeLoaderXML);
            assignFeeCategories();

        }


    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public function feeCategoriesXML(xml:XML):void {

        var productAttributes:XMLList = xml.children();
        var xl:XMLList = XMLList(productAttributes);
        xc3 = new XMLListCollection(xl);

        assignFeeCategories();

    }

    protected function addFeeEvents():void {
        this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, addItem3State);

        if (this.currentState == "AddFees") {
            auctionItemFeeAddBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
            deleteFeeBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
            addFeeBtn.addEventListener(MouseEvent.CLICK, addFeeBtn_clickHandler);

        }

        if (this.currentState == "AddFeeType") {
            eventFeeCreateBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
            eventTypePnl.addEventListener(CloseEvent.CLOSE, eventTypePnl_closeHandler);
        }

    }

    private function assignFeeCategories():void {
        if (this.currentState == "AddFees") {
            feeNameDropDown.dataProvider = xc3.list;
            feeNameDropDown.selectedIndex = -1;
            feeTypeDropDown.dataProvider = xc2.list;
            feeTypeDropDown.selectedIndex = -1;
        }

        else if (this.currentState == "AddFeeType") {
            auctionFeeCategoryHolder.dataProvider = xc3.list;
            auctionFeeCategoryHolder.selectedIndex = -1;
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadFeeList():void {


        var auctionItemFeesXML:XML = <fees>
            <fee>Federal Tax</fee>
            <fee>State Tax</fee>
            <fee>City Tax</fee>
            <fee>County Tax</fee>
            <fee>Advertising</fee>
            <fee>Reserve</fee>
            <fee>Other</fee>
        </fees>;

        var productAttributes:XMLList = auctionItemFeesXML.fee.children();
        var xl:XMLList = XMLList(productAttributes);
        xc3 = new XMLListCollection(xl);


    }

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

    private function auctionFeesXML(obj:Object):void {
        var url:String;
        url = "feeCategories.php";


        _xmlFeesLoader = _xmlFeesFileLoader.xmlFileLoader;
        _xmlFeesLoader.addEventListener(ResultEvent.RESULT, auctionFeesVerify);
        _xmlFeesLoader.addEventListener(FaultEvent.FAULT, auctionFeesFail);

        _xmlFeesFileLoader.loadXML(url, obj);

    }

    private function blankOutObjVar(obj:Object):Object {


        obj.searchVar = "";
        obj.table1 = "";


        return(obj);

    }

    public function auctionXMLFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);
        obj;

        _auction.removeEventListener(ResultEvent.RESULT, auctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionXMLFail);

        this.dispatchEvent(event);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

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

    protected function feesAdd_creationCompleteHandler(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, feesAdd_creationCompleteHandler);
        this.dispatchEvent(event);
    }

    protected function addItem3State(event:StateChangeEvent):void {

        addFeeEvents();

    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function eventTypePnl_closeHandler(event:CloseEvent):void {
        // TODO Auto-generated method stub
        this.currentState = "AddFees";
        assignFeeCategories();

    }

    protected function addFeeBtn_clickHandler(event:MouseEvent):void {
        // TODO Auto-generated method stub
        this.currentState = "AddFeeType";
        clear2();
        feeCategoriesXML(_feeLoaderXML);
        assignFeeCategories();
    }

    private function auctionPageBtn_clickHandler(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;
        var t:int;

        if (name == "auctionItemFeeAddBtn") {
            var node:XML = new XML();
            node = <fee id="" type="" amount="" display="" applyTo=""/>;

            node.@id = feeNameDropDown.selectedItem;
            node.@type = feeTypeDropDown.selectedItem;
            node.@amount = feeAmountItem.text;

            if (node.@type == "% Percent") {
                node.@display = node.@amount + " " + "%";
            }
            else if (node.@type == "$ Dollar") {
                node.@display = "$" + node.@amount;
            }

            if (this.id == "addAuctionTab9")
                node.@applyTo = "Auction";

            else if (this.id == "addItem1")
                node.@applyTo = "Seller";

            else if (this.id == "addItem3")
                node.@applyTo = "Item";


            auctionItemFeeHolder.dataProvider = null;
            auctionItemFeeHolder.dataProvider = empty.list;
            auctionItemFeeHolder.validateNow();

            _fileXML.auctionFees.appendChild(node);


            var xl:XMLList = XMLList(_fileXML.auctionFees.children());
            xc2 = new XMLListCollection(xl);
            auctionItemFeeHolder.dataProvider = xc2.list;

        }

        if (name == "deleteFeeBtn") {
            if (auctionItemFeeHolder.selectedIndex == -1) {

                return;
            }

            else {

                t = auctionItemFeeHolder.selectedIndex;

                delete _fileXML.auctionFees.fee[t];

                xl = XMLList(_fileXML.auctionFees.children());
                xc2 = new XMLListCollection(xl);
                auctionItemFeeHolder.dataProvider = xc2.list;
            }
        }

        if (name == "eventFeeCreateBtn") {
            var obj:Object = new Object();
            errorEventFeeLabel.text = "";

            if (newFeeCategory.text.length < 4) {
                errorEventFeeLabel.text = "Enter a Valid Event Type";
                return;
            }

            obj = blankOutObjVar(obj);
            obj.searchVar = newFeeCategory.text;
            obj.table1 = "AddAuctionFee";
            auctionFeesXML(obj);


        }
        auctionItemFeeHolder.validateNow();
    }

    private function itemSaveFail(event:FaultEvent):void {
        // TODO Auto-generated method stub
        _currentEditState = "New";

        _item.removeEventListener(ResultEvent.RESULT, itemSaveVerify);
        _item.removeEventListener(FaultEvent.FAULT, itemSaveFail);
    }

    private function itemSaveVerify(event:ResultEvent):void {
        // TODO Auto-generated method stub
        _currentEditState = "Edit";
        _item.currentEditState = "Edit";

        _item.removeEventListener(ResultEvent.RESULT, itemSaveVerify);
        _item.removeEventListener(FaultEvent.FAULT, itemSaveFail);


    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionFeesFail(event:Event):void {

        _xmlFeesLoader.removeEventListener(ResultEvent.RESULT, auctionFeesVerify);
        _xmlFeesLoader.removeEventListener(FaultEvent.FAULT, auctionFeesFail);
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionFeesVerify(event:Event):void {

        _feeLoaderXML = new XML();
        _feeLoaderXML = XML(_xmlFeesLoader.lastResult);
        _xmlFeesLoader.removeEventListener(ResultEvent.RESULT, auctionFeesVerify);
        _xmlFeesLoader.removeEventListener(FaultEvent.FAULT, auctionFeesFail);
        auctionFeeVerifyValid();

    }

}
}