package components {
import auctionFunctionsClass.auctionClass;

import flash.events.MouseEvent;

import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

public class auctionAddTab3 extends auctionAddTab3Layout {

    public function auctionAddTab3() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab3_creationCompleteHandler);

    }

    public var _auction:auctionClass = new auctionClass();

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

        check1.selected = true;
        check2.selected = false;
        check3.selected = true;
        check4.selected = false;
        check5.selected = false;
        check6.selected = false;
        check7.selected = false;


        extendTimer.value = 1;
        clearAllCheckMarks();
        r1.selected = true;

        loadAuctionXML();
        addAuctionTab3Events();

    }

    public function assignAuction():void {

        var s:String;
        var name:String;

        if (_auctionFileXML.auctionView == "Public Auction") {
            check1.selected = true;
            check2.selected = false;
        }
        else if (_auctionFileXML.auctionView == "Private Auction") {
            check1.selected = false;
            check2.selected = true;
        }

        if (_auctionFileXML.auctionType == "Open Bidding") {
            check3.selected = true;
            check5.selected = false;
            check7.selected = false;
        }
        else if (_auctionFileXML.auctionType == "Maximum Bidding") {
            check3.selected = false;
            check5.selected = true;
            check7.selected = false;
        }

        else if (_auctionFileXML.auctionType == "Price List") {
            check3.selected = false;
            check5.selected = false;
            check7.selected = true;
        }

        if (_auctionFileXML.auctionType2 == "Buy Now") {
            if (check3.selected == true) {
                check4.selected = true;
                check5.selected = false;
            }
            else if (check5.selected == true) {
                check4.selected = false;
                check5.selected = true;
            }
        }

        s = _auctionFileXML.auctionStagerEnding.toString();

        if (s == "1 item/20 minutes") {
            r1.selected = true;
            name = r1.id;
            r1.invalidateDisplayList();
        }
        if (s == "1 item/minute") {
            r2.selected = true;
            name = r2.id;
            r2.invalidateDisplayList();
        }
        if (s == "2 item/minute") {
            r3.selected = true;
            name = r3.id;
            r3.invalidateDisplayList();
        }
        if (s == "3 item/minute") {
            r4.selected = true;
            name = r4.id;
            r4.invalidateDisplayList();
        }
        if (s == "4 item/minute") {
            r5.selected = true;
            name = r5.id;
            r5.invalidateDisplayList();
        }
        if (s == "5 item/minute") {
            r6.selected = true;
            name = r6.id;
            r6.invalidateDisplayList();
        }
        if (s == "6 item/minute") {
            r7.selected = true;
            name = r7.id;
            r7.invalidateDisplayList();
        }
        if (s == "7 item/minute") {
            r8.selected = true;
            name = r8.id;
            r8.invalidateDisplayList();
        }
        if (s == "8 item/minute") {
            r9.selected = true;
            name = r9.id;
            r9.invalidateDisplayList();
        }
        if (s == "9 item/minute") {
            r10.selected = true;
            name = r10.id;
            r10.invalidateDisplayList();
        }
        if (s == "10 item/minute") {
            r11.selected = true;
            name = r11.id;
            r11.invalidateDisplayList();
        }
        if (s == "20 item/minute") {
            r12.selected = true;
            name = r12.id;
            r12.invalidateDisplayList();
        }
        if (s == "30 item/minute") {
            r13.selected = true;
            name = r13.id;
            r13.invalidateDisplayList();
        }
        if (s == "40 item/minute") {
            r14.selected = true;
            name = r14.id;
            r14.invalidateDisplayList();
        }
        if (s == "50 item/minute") {
            r15.selected = true;
            name = r15.id;
            r15.invalidateDisplayList();
        }

        clearAllCheckMarks(name);

        extendTimer.value = _auctionFileXML.extendTime;
    }

    public function getAuctionFile():XML {
        var pass:Boolean = false;


        if (check1.selected == true)
            _auctionFileXML.auctionView = "Public Auction";
        else
            _auctionFileXML.auctionView = "Private Auction";

        if (check3.selected == true)
            _auctionFileXML.auctionType = "Open Bidding";
        else if (check5.selected == true)
            _auctionFileXML.auctionType = "Maximum Bidding";
        else if (check7.selected == true)
            _auctionFileXML.auctionType = "Price List";

        if (check4.selected == true || check6.selected == true)
            _auctionFileXML.auctionType2 = "Buy Now";

        if (r1.selected == true) {
            _auctionFileXML.auctionStagerEnding = r1.label;
            _auctionFileXML.auctionStagerEnding.@min = "20";
            _auctionFileXML.auctionStagerEnding.@numpermin = "1";
        }
        else if (r2.selected == true) {
            _auctionFileXML.auctionStagerEnding = r2.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "1";
        }
        else if (r3.selected == true) {
            _auctionFileXML.auctionStagerEnding = r3.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "2";
        }
        else if (r4.selected == true) {
            _auctionFileXML.auctionStagerEnding = r4.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "3";
        }
        else if (r5.selected == true) {
            _auctionFileXML.auctionStagerEnding = r5.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "4";
        }
        else if (r6.selected == true) {
            _auctionFileXML.auctionStagerEnding = r6.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "5";
        }
        else if (r7.selected == true) {
            _auctionFileXML.auctionStagerEnding = r7.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "6";
        }
        else if (r8.selected == true) {
            _auctionFileXML.auctionStagerEnding = r8.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "7";
        }
        else if (r9.selected == true) {
            _auctionFileXML.auctionStagerEnding = r9.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "8";
        }
        else if (r10.selected == true) {
            _auctionFileXML.auctionStagerEnding = r10.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "9";
        }
        else if (r11.selected == true) {
            _auctionFileXML.auctionStagerEnding = r11.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "10";
        }
        else if (r12.selected == true) {
            _auctionFileXML.auctionStagerEnding = r12.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "20";
        }
        else if (r13.selected == true) {
            _auctionFileXML.auctionStagerEnding = r13.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "30";
        }
        else if (r14.selected == true) {
            _auctionFileXML.auctionStagerEnding = r14.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "40";
        }
        else if (r15.selected == true) {
            _auctionFileXML.auctionStagerEnding = r15.label;
            _auctionFileXML.auctionStagerEnding.@min = "1";
            _auctionFileXML.auctionStagerEnding.@numpermin = "50";
        }

        _auctionFileXML.extendTime = extendTimer.value;


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

    protected function addAuctionTab3Events():void {
        // TODO Auto-generated method stub

        check2.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        check1.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        check4.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        check3.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        check5.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        check6.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        check7.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);

        r1.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r2.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r3.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r4.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r5.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r6.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r7.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r8.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r9.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r10.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r11.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r12.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r13.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r14.addEventListener(MouseEvent.CLICK, r_clickHandler);
        r15.addEventListener(MouseEvent.CLICK, r_clickHandler);
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

    private function clearAllCheckMarks(name:String = ""):void {
        if (name != "r1") {
            r1.selected = false;
            r1.invalidateDisplayList();
        }
        if (name != "r2") {
            r2.selected = false;
            r2.invalidateDisplayList();
        }
        if (name != "r3") {
            r3.selected = false;
            r3.invalidateDisplayList();
        }
        if (name != "r4") {
            r4.selected = false;
            r4.invalidateDisplayList();
        }
        if (name != "r5") {
            r5.selected = false;
            r5.invalidateDisplayList();
        }
        if (name != "r6") {
            r6.selected = false;
            r6.invalidateDisplayList();
        }
        if (name != "r7") {
            r7.selected = false;
            r7.invalidateDisplayList();
        }
        if (name != "r8") {
            r8.selected = false;
            r8.invalidateDisplayList();
        }
        if (name != "r9") {
            r9.selected = false;
            r9.invalidateDisplayList();
        }
        if (name != "r10") {
            r10.selected = false;
            r10.invalidateDisplayList();
        }
        if (name != "r11") {
            r11.selected = false;
            r11.invalidateDisplayList();
        }
        if (name != "r12") {
            r12.selected = false;
            r12.invalidateDisplayList();
        }
        if (name != "r13") {
            r13.selected = false;
            r13.invalidateDisplayList();
        }
        if (name != "r14") {
            r14.selected = false;
            r14.invalidateDisplayList();
        }
        if (name != "r15") {
            r15.selected = false;
            r15.invalidateDisplayList();
        }

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

    protected function addAuctionTab3_creationCompleteHandler(event:FlexEvent):void {

        this.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab3_creationCompleteHandler);
        this.dispatchEvent(event);
    }

    protected function addAuctionTab3State(event:StateChangeEvent):void {
        // TODO Auto-generated method stub
        addAuctionTab3Events();

    }

    private function r_clickHandler(event:MouseEvent):void {
        var obj:Object = event.currentTarget.valueOf();
        var name:String = obj.id;

        _auctionFileXML.auctionStagerEnding = name;

        clearAllCheckMarks(name);
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionPageBtn_clickHandler(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;

        if (name == "check1") {
            check2.selected = false;

        }
        else if (name == "check2") {
            check1.selected = false;
        }
        else if (name == "check3") {

            check4.selected = false;
            check5.selected = false;
            check6.selected = false;
            check7.selected = false;

        }
        else if (name == "check4") {
            check3.selected = true;
            check5.selected = false;
            check6.selected = false;
            check7.selected = false;


        }
        else if (name == "check5") {
            check3.selected = false;
            check4.selected = false;
            check6.selected = false;
            check7.selected = false;

        }
        else if (name == "check6") {
            check3.selected = false;
            check4.selected = false;
            check5.selected = true;
            check7.selected = false;


        }
        else if (name == "check7") {
            check3.selected = false;
            check4.selected = false;
            check5.selected = false;
            check6.selected = false;

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