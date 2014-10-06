package components {
import auctionFunctionsClass.auctionItemClass;
import auctionFunctionsClass.fileLoaderClass;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class itemVideo extends itemVideoLayout {
    public function itemVideo() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, itemVideo_creationComplete);
        this.addEventListener(FlexEvent.HIDE, clearVideo_handler);
    }

    private var _itemID:int = -1;
    private var _auctionFileXML:XML = new XML();
    private var _item:auctionItemClass = new auctionItemClass();
    private var xmlFileLoader:HTTPService = new HTTPService();
    private var fileLoader:fileLoaderClass = new fileLoaderClass();

    private var _auctionItemFileXML:XML = new XML();

    public function get auctionItemFileXML():XML {
        _auctionItemFileXML = getAuctionFile();

        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
    }

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

    private var _auctionID:int = -1;

    public function get auctionID():int {
        return _auctionID;
    }

    public function set auctionID(value:int):void {
        _auctionID = value;
    }

    public function clear():void {

        clearTab();
    }

    public function clearTab():void {


        slowLoadingIFrameWithLoadIndicator.source = "";
        slowLoadingIFrameWithLoadIndicator.visible = false;
        sampleYoutube.visible = true;
        slowLoadingIFrameWithLoadIndicator.data = null;
        slowLoadingIFrameWithLoadIndicator.cacheAsBitmap = true;
        googleCode1.text = "";


        assignAuction();
    }

    public function assignAuction():void {
        var s:String;


        googleCode1.text = _auctionItemFileXML.youtubeVideoCode.toString();
        s = _auctionItemFileXML.youtubeVideo.toString();
        slowLoadingIFrameWithLoadIndicator.source = s;

        if (s != "") {
            slowLoadingIFrameWithLoadIndicator.visible = true;
            sampleYoutube.visible = false;
        }

    }

    public function assignItem():void {
        var s:String;


        googleCode1.text = _auctionItemFileXML.youtubeVideoCode.toString();
        s = _auctionItemFileXML.youtubeVideo.toString();
        slowLoadingIFrameWithLoadIndicator.source = s;

        if (s != "") {
            slowLoadingIFrameWithLoadIndicator.visible = true;
            sampleYoutube.visible = false;
        }

    }

    public function getAuctionFile():XML {
        var pass:Boolean = false;

        _auctionItemFileXML.youtubeVideoCode = googleCode1.text;

        return _auctionItemFileXML;
    }

    public function saveFile():void {

        _item.currentEditState = _currentEditState;
        _auctionItemFileXML = getAuctionFile();
        _item.auctionID = _auctionID;
        _item.saveItem(_auctionItemFileXML);
        _item.addEventListener(ResultEvent.RESULT, itemSaveVerify);
        _item.addEventListener(FaultEvent.FAULT, itemSaveFail);

    }

    public function hideVideo():void {
        slowLoadingIFrameWithLoadIndicator.visible = false;
        slowLoadingIFrameWithLoadIndicator.data = null;
        slowLoadingIFrameWithLoadIndicator.source = "";
        slowLoadingIFrameWithLoadIndicator.cacheAsBitmap = true;

        slowLoadingIFrameWithLoadIndicator.loadIFrame();
        slowLoadingIFrameWithLoadIndicator.validateDisplayList();
    }

    protected function clearVideo_handler(event:Event):void {
        hideVideo();
    }

    protected function itemVideo_creationComplete(event:FlexEvent):void {

        slowLoadingIFrameWithLoadIndicator.addEventListener(Event.ENTER_FRAME, slowLoadingIFrameWithLoadIndicator0_enterFrameHandler);
        googleMapLoader.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        clearTab();
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function slowLoadingIFrameWithLoadIndicator0_enterFrameHandler(event:Event):void {
        slowLoadingIFrameWithLoadIndicator.invalidateDisplayList();

    }

    private function auctionPageBtn_clickHandler(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;

        if (name == "googleMapLoader") {
            var s:String = googleCode1.text;

            if (s == "") {
                slowLoadingIFrameWithLoadIndicator.source = "";
                slowLoadingIFrameWithLoadIndicator.data = null;
                sampleYoutube.visible = true;
                return;
            }

            var t:int = s.search("//");

            var e:int = s.search("\" frameborder=\"0\"");

            if (t == -1 || e == -1) {
                googleCode1.text = "invalid code paste again";
                slowLoadingIFrameWithLoadIndicator.source = "";
                slowLoadingIFrameWithLoadIndicator.data = null;
                sampleYoutube.visible = true;
            }

            var s2:String = s.slice(t, e);

            _auctionItemFileXML.youtubeVideoCode = s.toString();
            _auctionItemFileXML.youtubeVideo = s2.toString();
            slowLoadingIFrameWithLoadIndicator.source = s2;
            slowLoadingIFrameWithLoadIndicator.visible = true;
            sampleYoutube.visible = false;

        }
    }

    private function itemSaveFail(event:FaultEvent):void {
        // TODO Auto-generated method stub
        _currentEditState = "New";

        _item.removeEventListener(ResultEvent.RESULT, itemSaveVerify);
        _item.removeEventListener(FaultEvent.FAULT, itemSaveFail);
    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function itemSaveVerify(event:ResultEvent):void {
        // TODO Auto-generated method stub
        _currentEditState = "Edit";
        _item.currentEditState = "Edit";

        _item.removeEventListener(ResultEvent.RESULT, itemSaveVerify);
        _item.removeEventListener(FaultEvent.FAULT, itemSaveFail);


    }

}
}