package auctionFunctionsClass {
import flash.events.Event;

import mx.core.FlexGlobals;
import mx.rpc.AbstractInvoker;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]

public class auctionClass extends AbstractInvoker {

    public function auctionClass() {
        _auctionFileXML = new XML();
        _auctionDBXML = new XML();
        _auctionFeesXML = new XML();
        _auctionID = 0;

        _auctionEndTime = "";
        _auctionStartTime = "";

        _auctionItemsFile = new XML();
        _auctionItemDBXML = new XML();
        _auctionItemsFeesXML = new XML();

        _auctionBid = new XML();
        _auctionBidsHistory = new XML();

        _auctionObject = new XML();

        _xmlFileLoader = new fileLoaderClass();

        xmlService = new HTTPService();
    }

    public var xmlService:HTTPService;
    private var _auctionFeesXML:XML;
    private var _auctionURL:String;
    private var _auctionEndTime:String;
    private var _auctionStartTime:String;
    private var _auctionItemsFile:XML;
    private var _auctionItemDBXML:XML;
    private var _auctionItemsFeesXML:XML;
    private var _auctionBid:XML;
    private var _auctionBidsHistory:XML;
    private var _auctionObject:Object;

    private var _currentEditState:String = "New";

    public function set currentEditState(value:String):void {
        _currentEditState = value;
    }

    private var _auctionFileXML:XML;

    public function get auctionFileXML():XML {

        return _auctionFileXML;
    }

    public function set auctionFileXML(xml:XML):void {

        var node:XML = xml.auction[0];

        if (node == null)
            _auctionFileXML = xml;
        else
            _auctionFileXML = xml.auction[0];
    }

    private var _auctionDBXML:XML;

    public function get auctionDBXML():XML {

        return _auctionDBXML;
    }

    public function set auctionDBXML(xml:XML):void {
        _auctionDBXML = xml;
    }

    private var _auctionID:int;

    public function get auctionID():Number {

        return _auctionID;
    }

    public function set auctionID(num:Number):void {

        _auctionID = num;
    }

    public var _xmlFileLoader:fileLoaderClass;

    public function get xmlFileLoader():fileLoaderClass {
        return _xmlFileLoader;
    }

    public function createAuction():void {
        _auctionURL = "auction.xml";
        loadAuctionFileXML(_auctionURL);
    }

    public function saveAuction(_xml:XML):void {
        var url:String;
        var obj:Object = new Object();

        _auctionFileXML = _xml;

        url = "AuctionXML.php";
        obj = blankOutAuctionVar(obj);

        if (_currentEditState == "New") {
            obj = createAuctionObj(obj);
        }

        else {
            obj = updateAuctionDB(obj);
        }

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, auctionDBXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, auctionDBXMLFail);

        _xmlFileLoader.loadXML(url, obj);

        FlexGlobals.topLevelApplication.enabled = false;

    }

    public function deleteAuction():void {
        var obj:Object = new Object();
        var url:String;

        url = "AuctionXML.php";

        obj = blankOutAuctionVar(obj);
        obj = deleteAuctionObj(obj);

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, auctionXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, auctionXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);
    }

    public  function loadAuctionByID(id:int = 0):void{
        _auctionID = id;
        loadAuctionDBXML();

    }

    public function updateAuction():void {

    }

    public function uploadAuction():void {

    }

    public function loadAuctionFileXML(_auctionURL:String):void {
        var url:String = "fileRead.php";
        var obj:Object = new Object();
        obj.fileName = _auctionURL;

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, auctionXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, auctionXMLFail);

        _xmlFileLoader.loadXML(url, obj);


    }


    public function activateAuction():void {

        var url:String;
        var obj:Object = new Object();

        url = "AuctionXML.php";

        obj = blankOutAuctionVar(obj);
        obj = activateAuctionObj(obj);

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, auctionXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, auctionXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);
    }

    public function blankOutAuctionVar(obj:Object):Object {

        obj.auctionId = "";
        obj.auctionName = "";
        obj.auctionCategory = "";
        obj.userId = "";
        obj.auctionStatus = "";
        obj.endTime = "";
        obj.isoTime = "";
        obj.auctionState = "";
        obj.auctionXML = "";
        obj.auctionView = "";
        obj.path = "";

        obj.fileXML = "";

        obj.data1 = "";
        obj.data2 = "";

        obj.searchVar = "";
        obj.table1 = "";

        obj.userSearch = "";

        return(obj);

    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadAuctionDBXML():void {

        var url:String;
        var obj:Object = new Object();

        url = "AuctionXML.php";

        obj = blankOutAuctionVar(obj);
        obj = loadAuctionObj(obj);

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, auctionDBXMLLoadVerify);
        xmlService.addEventListener(FaultEvent.FAULT, auctionDBXMLLoadFail);

        _xmlFileLoader.loadXML(url, obj);

        FlexGlobals.topLevelApplication.enabled = false;
    }


    private function saveAuctionXMLFile():void {
        var obj:Object = new Object();
        var url:String;

        url = "AuctionXML.php";
        obj = blankOutAuctionVar(obj);
        obj = saveFileAuctionObj(obj);

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, auctionXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, auctionXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);

        FlexGlobals.topLevelApplication.enabled = false;

    }

    private function formatAuctionFileXML(_auctionFileXML:XML):String {
        var node:XML = new XML();
        node = <auctions></auctions>;
        node.appendChild(_auctionFileXML);

        var s:String = "<?xml version=" + '"' + "1.0" + '"' + " encoding=" + '"' + "UTF-8" + '"' + "?>\n";

        var FileSend:String;
        FileSend = s + node.toXMLString();

        return FileSend;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    private function synchronizeDBwithFile():void {
        var s:String;

        s = _auctionDBXML.id;
        _auctionFileXML.id = s;

        s = _auctionDBXML.name;
        _auctionFileXML.name = s;

        s = _auctionDBXML.auctionCategory;
        _auctionFileXML.auctionCategory = s;

        s = _auctionDBXML.ipCount;
        _auctionFileXML.ipCount = s;

        s = _auctionDBXML.sataliteID;
        _auctionFileXML.sataliteID = s;

        s = _auctionDBXML.auctionState;
        _auctionFileXML.auctionState = s;

        s = _auctionDBXML.auctionXML;
        _auctionFileXML.auctionXML = s;

        s = _auctionDBXML.path;
        _auctionFileXML.path = s;

        s = _auctionDBXML.status;
        _auctionFileXML.status = s;

        s = _auctionDBXML.isoTime;
        _auctionFileXML.isoTime = s;

    }

    private function updateAuctionDB(obj:Object):Object {

        obj.auctionId = _auctionFileXML.id.toString();
        obj.auctionName = _auctionFileXML.name.toString();
        obj.auctionCategory = _auctionFileXML.auctionCategory.toString();
        obj.userId = _auctionFileXML.sataliteID.toString();
        obj.auctionStatus = _auctionFileXML.status.toString();
        obj.endTime = _auctionFileXML.endTime.toString();
        obj.isoTime = _auctionFileXML.isoTime.toString();
        obj.auctionState = _auctionFileXML.auctionState.toString();
        obj.auctionXML = _auctionFileXML.auctionXML.toString();
        obj.auctionView = _auctionFileXML.auctionView.toString();
        obj.path = _auctionFileXML.path.toString();

        obj.table1 = "Update";

        return obj;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    private function saveFileAuctionObj(obj:Object):Object {

        var node:XML = new XML();
        node = <auctions></auctions>;
        node.appendChild(_auctionFileXML);

        var s:String = "<?xml version=" + '"' + "1.0" + '"' + " encoding=" + '"' + "UTF-8" + '"' + "?>\n";

        var FileSend:String;
        FileSend = s + node.toXMLString();


        obj.fileXML = FileSend;
        obj.auctionId = _auctionFileXML.id.toString();
        obj.auctionXML = _auctionFileXML.auctionXML.toString();
        obj.path = _auctionFileXML.path.toString();
        obj.table1 = "Save";

        return obj;
    }

    private function createAuctionObj(obj:Object):Object {

        obj.auctionId = "";
        obj.auctionName = _auctionFileXML.name.toString();
        obj.auctionCategory = _auctionFileXML.auctionCategory.toString();
        obj.userId = _auctionFileXML.sataliteID.toString();
        obj.auctionStatus = "Inactive";
        obj.endTime = _auctionFileXML.endTime.toString();
        obj.isoTime = _auctionFileXML.isoTime.toString();
        obj.auctionState = _auctionFileXML.auctionState.toString();
        obj.auctionXML = "";
        obj.path = "";

        obj.fileXML = "";

        obj.table1 = "Add";

        return(obj);


    }


    /////////////////////////////////////////////////////////////////////////////////////////////////


    private function loadAuctionObj(obj:Object):Object {
        obj.searchVar = _auctionID;
        obj.table1 = "Load";

        return obj;
    }

    private function deleteAuctionObj(obj:Object):Object {
        obj.path = _auctionDBXML.path.toString();
        obj.searchVar = _auctionDBXML.id.toString();
        obj.table1 = "Delete";

        return obj;
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function activateAuctionObj(obj:Object):Object {
        var status:String;

        status = _auctionFileXML.status.toString();
        status;

        if (status == "Active") {
            obj.auctionStatus = "Inactive";
        }

        else if (status == "Inactive" || status == "") {
            obj.auctionStatus = "Active";
        }

        obj.searchVar = _auctionDBXML.id.toString();
        obj.table1 = "activateAuction";

        return obj;
    }

    private function auctionXMLFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, auctionXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionXMLFail);

        this.dispatchEvent(event);

        FlexGlobals.topLevelApplication.enabled = true;
    }

    private function auctionXMLVerify(event:ResultEvent):void {

        var obj:Object;

        obj = XML(event.result);
        xmlService.removeEventListener(ResultEvent.RESULT, auctionXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionXMLFail);

        var node:XML;
        node = obj.auction[0] as XML;

        FlexGlobals.topLevelApplication.enabled = true;

        if (node != null) {
            _auctionFileXML = node;
            synchronizeDBwithFile();
            this.dispatchEvent(event);
            return;
        }

        this.dispatchEvent(event);


    }

    private function auctionDBXMLFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        xmlService.removeEventListener(ResultEvent.RESULT, auctionDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionDBXMLFail);


    }

    private function auctionDBXMLVerify(event:ResultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        xmlService.removeEventListener(ResultEvent.RESULT, auctionDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionDBXMLFail);

        var node:XML;
        node = obj.auctionDB[0] as XML;

        if (node != null) {
            _auctionDBXML = node;
            synchronizeDBwithFile();
            saveAuctionXMLFile();
        }


    }





    private function auctionDBXMLLoadFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        xmlService.removeEventListener(ResultEvent.RESULT, auctionDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionDBXMLFail);


    }

    private function auctionDBXMLLoadVerify(event:ResultEvent):void {
        var obj:Object;
        var url:String;

        obj = XML(xmlService.lastResult);
        xmlService.removeEventListener(ResultEvent.RESULT, auctionDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionDBXMLFail);

        var node:XML;
        node = obj.auctionDB[0] as XML;

        if (node != null) {
            _auctionDBXML = node;
            url = _auctionDBXML.auctionXML;
            loadAuctionFileXML(url);
        }


    }


    private function auctionXMLFileFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        xmlService.removeEventListener(ResultEvent.RESULT, auctionXMLFileVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionXMLFileFail);

        var e:Event = new Event("fault");
        this.dispatchEvent(e);
        FlexGlobals.topLevelApplication.enabled = true;
    }

    private function auctionXMLFileVerify(event:ResultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        var status:String;

        FlexGlobals.topLevelApplication.enabled = true;

        if (obj != null) {
            status = obj.toString();

            if (status == "Auction Saved") {
                xmlService.removeEventListener(ResultEvent.RESULT, auctionXMLFileVerify);
                xmlService.removeEventListener(FaultEvent.FAULT, auctionXMLFileFail);

                this.dispatchEvent(event);
                return;
            }

            if (status == "Delete OK") {
                xmlService.removeEventListener(ResultEvent.RESULT, auctionXMLFileVerify);
                xmlService.removeEventListener(FaultEvent.FAULT, auctionXMLFileFail);

                this.dispatchEvent(event);
                return;
            }

            if (status == "Auction Active") {
                xmlService.removeEventListener(ResultEvent.RESULT, auctionXMLFileVerify);
                xmlService.removeEventListener(FaultEvent.FAULT, auctionXMLFileFail);

                this.dispatchEvent(event);
                return;
            }
        }

        this.dispatchEvent(event);
    }

}
}