package components {
import auctionFunctionsClass.auctionClass;

import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import spark.components.DataGrid;

public class auctionAddTab5 extends auctionAddTab5Layout {

    public function auctionAddTab5() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab5_creationCompleteHandler);
    }

    public var _auction:auctionClass = new auctionClass();
    private var ampm:String;
    private var timZone:String;
    private var xc3:XMLListCollection = new XMLListCollection();
    private var xc4:XMLListCollection = new XMLListCollection();

    private var _loginUserID:String;

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
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
    }

    public function clear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;


        ampm = _auctionFileXML.ampm.toString();
        timZone = _auctionFileXML.timeZone.toString();

        loadTimeList();
        loadTimeZoneList();

        ampmTab0.dataProvider = xc3.list;
        ampmTab1.dataProvider = xc3.list;
        ampmTab2.dataProvider = xc3.list;
        ampmTab3.dataProvider = xc3.list;

        richTextEditor2.text = "";
        richTextEditor2.htmlText = "";
        richTextEditor2.validateNow();

        richTextEditor3.text = "";
        richTextEditor3.htmlText = "";
        richTextEditor3.validateNow();


        inspectionDateHr.value = 7;
        inspectionDateMin.value = 0;

        inspectionDateHr0.value = 7;
        inspectionDateMin0.value = 0;

        inspectionDateDay.selectedDate = null;
        inspectionDateDay.text = "";


        pickUpDateHr.value = 7;
        pickUpdateMin.value = 0;

        pickUpDateHr0.value = 7;
        pickUpdateMin0.value = 0;


        pickUpdateDay.selectedDate = null;
        pickUpdateDay.text = "";

        assignInspectionDateHolderToDataGrid(inspectionDateHolder);
        assignPickDateHolderToDataGrid(pickupDatesHolder);

        ampmTab0.selectedIndex = 0;
        ampmTab1.selectedIndex = 1;
        ampmTab2.selectedIndex = 0;
        ampmTab3.selectedIndex = 1;

        loadAuctionXML();
        addAuctionTab5Events();

    }

    public function assignAuction():void {

        var s:String;

        assignInspectionDateHolderToDataGrid(inspectionDateHolder);
        assignPickDateHolderToDataGrid(pickupDatesHolder);

        s = _auctionFileXML.rtInspectInfo.toString();
        richTextEditor2.htmlText = s;

        s = _auctionFileXML.rtPickUpInfo.toString();
        richTextEditor3.htmlText = s;
    }

    public function getAuctionFile():XML {
        var pass:Boolean = false;

        _auctionFileXML.InspectInfo = richTextEditor2.text.toString();
        _auctionFileXML.rtInspectInfo = richTextEditor2.htmlText.toString();

        _auctionFileXML.PickUpInfo = richTextEditor3.text.toString();
        _auctionFileXML.rtPickUpInfo = richTextEditor3.htmlText.toString();

        return _auctionFileXML;
    }

    public function saveFile():void {

        _auction.currentEditState = _currentEditState;
        _auctionFileXML = getAuctionFile();
        _auction.saveAuction(_auctionFileXML);
        _auction.addEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.addEventListener(FaultEvent.FAULT, auctionSaveFail);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    protected function addAuctionTab5Events():void {
        inspectionDateBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        inspectDateDeleteBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        pickupDateBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        pickupDateDeleteBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
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

    private function zeroTime(s:String):String {

        if (s.length < 2)
            s = "0" + s;
        return s;

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignInspectionDateHolderToDataGrid(list:DataGrid):void {

        var node:XML = new XML();

        var xl:XMLList = XMLList(_auctionFileXML.inspectionDates.children());
        var xc:XMLListCollection = new XMLListCollection(xl);
        list.dataProvider = xc.list;

    }

    private function assignPickDateHolderToDataGrid(list:DataGrid):void {

        var node:XML = new XML();

        var xl:XMLList = XMLList(_auctionFileXML.pickupDates.children());
        var xc:XMLListCollection = new XMLListCollection(xl);
        list.dataProvider = xc.list;

    }

    private function loadTimeList():void {


        var timeXML:XML = <time>
            <uu>AM</uu>
            <uu>PM</uu>
        </time>;

        var productAttributes:XMLList = timeXML.uu.children();
        var xl:XMLList = XMLList(productAttributes);
        xc3 = new XMLListCollection(xl);


    }

    private function loadTimeZoneList():void {


        var timeZoneXML:XML = <timezones>
            <uu>EDT</uu>
            <uu>CDT</uu>
            <uu> MDT</uu>
            <uu>PDT</uu>
            <uu> AKDT</uu>
            <uu>HST</uu>
        </timezones>;

        var productAttributes:XMLList = timeZoneXML.uu.children();
        var xl:XMLList = XMLList(productAttributes);
        xc4 = new XMLListCollection(xl);


    }

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

    protected function addAuctionTab5_creationCompleteHandler(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab5_creationCompleteHandler);
        this.dispatchEvent(event);

    }

    protected function addAuctionTab5State(event:StateChangeEvent):void {
        // TODO Auto-generated method stub
        addAuctionTab5Events();

    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionPageBtn_clickHandler(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean;
        var node:XML;

        var obj:Object = new Object;
        var t:int;

        if (name == "inspectionDateBtn") {
            var z1:String;
            var z2:String;
            var z3:String;
            var z4:String;
            var z5:String;
            var z6:String;

            if (inspectionDateDay.selectedDate == null)
                return;
            else {
                z1 = inspectionDateHr.value.toString();
                z2 = inspectionDateMin.value.toString();
                z3 = inspectionDateHr0.value.toString();
                z4 = inspectionDateMin0.value.toString();

                z5 = ampmTab0.selectedItem.toString();
                z6 = ampmTab1.selectedItem.toString();


                z1 = zeroTime(z1);
                z2 = zeroTime(z2);
                z3 = zeroTime(z3);
                z4 = zeroTime(z4);


                var t1:String = z1 + ":" + z2 + " " + z5 + "-" + z3 + ":" + z4 + " " + z6 + " " + timZone;
                node = new XML();
                node = <inspectionDate day="" hours=""></inspectionDate>;
                node.@hours = t1;
                node.@day = inspectionDateDay.selectedDate.toDateString();
                _auctionFileXML.inspectionDates.appendChild(node);
                assignInspectionDateHolderToDataGrid(inspectionDateHolder);
            }
        }

        if (name == "inspectDateDeleteBtn") {
            if (inspectionDateHolder.selectedIndex == -1) {

                return;
            }

            else {

                t = inspectionDateHolder.selectedIndex;
                delete _auctionFileXML.inspectionDates.inspectionDate[t];
                assignInspectionDateHolderToDataGrid(inspectionDateHolder);
            }

        }

        if (name == "pickupDateBtn") {
            if (inspectionDateDay.selectedDate == null)
                return;
            else {
                z1 = pickUpDateHr.value.toString();
                z2 = pickUpdateMin.value.toString();
                z3 = pickUpDateHr0.value.toString();
                z4 = pickUpdateMin0.value.toString();

                z5 = ampmTab2.selectedItem.toString();
                z6 = ampmTab3.selectedItem.toString();

                z1 = zeroTime(z1);
                z2 = zeroTime(z2);
                z3 = zeroTime(z3);
                z4 = zeroTime(z4);

                var t2:String = z1 + ":" + z2 + " " + z5 + "-" + z3 + ":" + z4 + " " + z6 + " " + timZone;
                node = new XML();
                node = <pickupDate day="" hours=""></pickupDate>;
                node.@hours = t2;
                node.@day = pickUpdateDay.selectedDate.toDateString();
                _auctionFileXML.pickupDates.appendChild(node);
                assignPickDateHolderToDataGrid(pickupDatesHolder);
            }
        }

        if (name == "pickupDateDeleteBtn") {
            if (pickupDatesHolder.selectedIndex == -1) {

                return;
            }

            else {

                t = pickupDatesHolder.selectedIndex;
                delete _auctionFileXML.pickupDates.pickupDate[t];
                assignPickDateHolderToDataGrid(pickupDatesHolder);
            }
        }

    }

    private function auctionSaveFail(event:FaultEvent):void {
        // TODO Auto-generated method stub
        _currentEditState = "New";

        _auction.removeEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionSaveFail);
    }

    private function auctionSaveVerify(event:ResultEvent):void {
        // TODO Auto-generated method stub
        _currentEditState = "Edit";
        _auction.currentEditState = "Edit";

        _auction.removeEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionSaveFail);


    }


}
}