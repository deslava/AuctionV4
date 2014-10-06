package components {
import auctionFunctionsClass.auctionClass;

import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

public class auctionAddTab6 extends auctionAddTab6Layout {
    public function auctionAddTab6() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab6_creationCompleteHandler);
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

        clearTab();

    }

    public function assignAuction():void {

        var s:String;

        s = _auctionFileXML.rtShippingInfo.toString();
        richTextEditor4.htmlText = s;

        s = _auctionFileXML.rtTermsInfo.toString();
        richTextEditor6.htmlText = s;


    }

    public function getAuctionFile():XML {
        var pass:Boolean = false;

        _auctionFileXML.rtShippingInfo = richTextEditor4.htmlText.toString();
        _auctionFileXML.ShippingInfo = richTextEditor4.text.toString();

        _auctionFileXML.rtTermsInfo = richTextEditor6.htmlText.toString();
        _auctionFileXML.TermsInfo = richTextEditor6.text.toString();

        return _auctionFileXML;

    }

    public function saveFile():void {

        _auction.currentEditState = _currentEditState;
        _auctionFileXML = getAuctionFile();
        _auction.saveAuction(_auctionFileXML);
        _auction.addEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.addEventListener(FaultEvent.FAULT, auctionSaveFail);

    }

    protected function addAuctionTab6Events():void {
        // TODO Auto-generated method stub


    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function clearTab():void {

        richTextEditor4.text = "";
        richTextEditor4.htmlText = "";
        richTextEditor4.validateNow();

        richTextEditor6.text = "";
        richTextEditor6.htmlText = "";
        richTextEditor6.validateNow();

        loadAuctionXML();
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

    public function auctionXMLFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);
        obj;

        _auction.removeEventListener(ResultEvent.RESULT, auctionXMLVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionXMLFail);

        this.dispatchEvent(event);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

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

    protected function addAuctionTab6_creationCompleteHandler(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab6_creationCompleteHandler);
        this.dispatchEvent(event);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function addAuctionTab6State(event:StateChangeEvent):void {
        // TODO Auto-generated method stub
        addAuctionTab6Events();

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