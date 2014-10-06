package components {
import auctionFunctionsClass.auctionClass;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

public class auctionAddTab4 extends auctionAddTab4Layout {
    public function auctionAddTab4() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab4_creationCompleteHandler);
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
        loadAuctionXML();
        addAuctionTab4Events();

    }

    public function assignAuction():void {
        var s:String;
        var s2:String;

        s = _auctionFileXML.rtDirectionMap.toString();
        s2 = _auctionFileXML.DirectionMap.toString();
        richTextEditor.text = s2;
        richTextEditor.htmlText = s;

        s = _auctionFileXML.googleMapCode.toString();
        googleCode1.text = s;
        slowLoadingIFrameWithLoadIndicator.content = s;

        if (s != "")
            slowLoadingIFrameWithLoadIndicator.visible = true;

    }

    public function getAuctionFile():XML {
        var pass:Boolean = false;

        _auctionFileXML.googleMapCode = googleCode1.text;
        _auctionFileXML.DirectionMap = richTextEditor.text.toString();
        _auctionFileXML.rtDirectionMap = richTextEditor.htmlText.toString();

        return _auctionFileXML;
    }

    public function saveFile():void {

        _auction.currentEditState = _currentEditState;
        _auctionFileXML = getAuctionFile();
        _auction.saveAuction(_auctionFileXML);
        _auction.addEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.addEventListener(FaultEvent.FAULT, auctionSaveFail);

    }

    protected function addAuctionTab4Events():void {
        slowLoadingIFrameWithLoadIndicator.addEventListener(Event.ENTER_FRAME, slowLoadingIFrameWithLoadIndicator0_enterFrameHandler);
        googleMapLoader.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);

    }

    protected function clearTab():void {

        slowLoadingIFrameWithLoadIndicator.source = "";
        slowLoadingIFrameWithLoadIndicator.content = "";
        slowLoadingIFrameWithLoadIndicator.visible = false;
        slowLoadingIFrameWithLoadIndicator.data = null;
        slowLoadingIFrameWithLoadIndicator.cacheAsBitmap = true;
        googleCode1.text = "";

        richTextEditor.text = "";
        richTextEditor.htmlText = "";

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

    protected function addAuctionTab4_creationCompleteHandler(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionTab4_creationCompleteHandler);
        this.dispatchEvent(event);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    protected function addAuctionTab4State(event:StateChangeEvent):void {
        // TODO Auto-generated method stub
        addAuctionTab4Events();

    }

    protected function slowLoadingIFrameWithLoadIndicator0_enterFrameHandler(event:Event):void {
        slowLoadingIFrameWithLoadIndicator.invalidateDisplayList();

    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionPageBtn_clickHandler(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;

        if (name == "googleMapLoader") {
            var s:String = googleCode1.text;

            if (s == "") {
                slowLoadingIFrameWithLoadIndicator.content = "";
                slowLoadingIFrameWithLoadIndicator.data = null;
                return;
            }

            /* 	var t:int = s.search("http:");
             var e:int = s.search("\">");
             if(t == -1 || e == -1)
             {
             googleCode1.text = "invalid code paste again";
             slowLoadingIFrameWithLoadIndicator.source = "";
             slowLoadingIFrameWithLoadIndicator.data = null;
             } */
            //var s2:String = s.slice(t, e);

            _auctionFileXML.googleMapCode = s.toString();
            _auctionFileXML.googleMap = s.toString();

            slowLoadingIFrameWithLoadIndicator.content = s;
            slowLoadingIFrameWithLoadIndicator.visible = true;

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