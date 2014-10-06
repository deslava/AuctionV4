package components {
import auctionFunctionsClass.auctionClass;

import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

public class auctionAddTab7 extends auctionAddTab7Layout {
    public function auctionAddTab7() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab7_creationCompleteHandler);
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


        s = _auctionFileXML.rtAuctionDesInfo.toString();
        richTextEditor5.htmlText = s;
    }

    public function getAuctionFile():XML {
        _auctionFileXML.rtAuctionDesInfo = richTextEditor5.htmlText.toString();
        _auctionFileXML.AuctionDesInfo = richTextEditor5.text.toString();

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

    protected function addAuctionTab7Events():void {
        // TODO Auto-generated method stub

    }

    private function clearTab():void {

        richTextEditor5.text = "";
        richTextEditor5.htmlText = "";
        richTextEditor5.validateNow();

        loadAuctionXML();
        addAuctionTab7Events();

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

    /////////////////////////////////////////////////////////////////////////////////////////////////

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

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function addAuctionTab7_creationCompleteHandler(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab7_creationCompleteHandler);
        this.dispatchEvent(event);


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