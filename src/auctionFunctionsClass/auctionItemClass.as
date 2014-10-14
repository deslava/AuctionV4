package auctionFunctionsClass {
import mx.core.FlexGlobals;
import mx.rpc.AbstractInvoker;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]

public class auctionItemClass extends AbstractInvoker {
    public function auctionItemClass() {
        _auctionFileXML = new XML();

    }

    public var _xmlFileLoader:fileLoaderClass;
    public var xmlService:HTTPService;
    private var _auctionItemDBXML:XML;
    private var _auctionItemsFeesXML:XML;

    private var _currentEditState:String = "New";

    public function get currentEditState():String {
        return _currentEditState;
    }

    public function set currentEditState(value:String):void {
        _currentEditState = value;
    }

    private var _auctionFileXML:XML;

    public function get auctionFileXML():XML {
        return _auctionFileXML;
    }

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;
    }

    private var _auctionID:int;

    public function get auctionID():int {
        return _auctionID;
    }

    public function set auctionID(value:int):void {
        _auctionID = value;
    }

    private var _itemID:int;

    public function get itemID():int {
        return _itemID;
    }

    public function set itemID(value:int):void {
        _itemID = value;
    }

    private var _auctionItemFileXML:XML;

    public function get auctionItemFileXML():XML {
        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
    }

    public function createItem():void {

        var url:String;

        url = "auctionItem.xml";
        loadItemFileXML(url);

    }


    public function saveItem(_xml:XML):void {
        var url:String;
        var obj:Object = new Object();

        _auctionItemFileXML = _xml;

        url = "itemsXML.php";
        obj = blankOutItemVar(obj);

        if (_currentEditState == "New") {
            obj = createItemObj(obj);
        }

        else {
            obj = updateItemDB(obj);
        }

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, itemDBXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, itemDBXMLFail);

        _xmlFileLoader.loadXML(url, obj);

        FlexGlobals.topLevelApplication.enabled = false;

    }


    public function loadItemFileXML(_auctionURL:String):void {
        var url:String = "fileRead.php";
        var obj:Object = new Object();
        obj.fileName = _auctionURL;

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, itemXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, itemXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);


    }


    public function loadItemWithID(aID:int=0, iID:int=0):void{
        _auctionID = aID;
        _itemID = iID;

        loadItemDBXML();
    }

    private function loadItemDBXML():void{

        var obj:Object = new Object();
        var url:String;

        url = "itemsXML.php";
        obj = blankOutItemVar(obj);
        obj = loadItemObj(obj);

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, itemDBXMLLoadVerify);
        xmlService.addEventListener(FaultEvent.FAULT, itemDBXMLLoadFail);

        _xmlFileLoader.loadXML(url, obj);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    public function updateItemDB(obj:Object):Object {
        var sellerID:String;
        sellerID = _auctionItemFileXML.dropDown.@id.toString();

        obj.sellerID = sellerID;
        obj.auctionID = _auctionID;
        obj.itemID = _auctionItemFileXML.itemId.toString();
        obj.userType = _auctionItemFileXML.sellerType.toString();
        obj.auction_path = _auctionFileXML.path.toString();
        obj.item_name = _auctionItemFileXML.itemName.toString();
        obj.item_type = _auctionItemFileXML.category.toString();
        obj.info_xml = _auctionItemFileXML.info_xml.toString();
        obj.item_status = "Active";
        obj.start_bid = _auctionItemFileXML.initialDollarBid + "." + _auctionItemFileXML.initialCentsBid;
        obj.max_bid = _auctionItemFileXML.reserveDollar + "." + _auctionItemFileXML.reserveCents;
        obj.quantity = _auctionItemFileXML.quantity.toString();
        obj.max_house_or_buynow = _auctionItemFileXML.buyNow.toString();
        obj.close_time = _auctionFileXML.isoTime.toString();
        obj.open_time = _auctionFileXML.auctionStagerEnding.@min.toString();
        obj.numitems_permin = _auctionFileXML.auctionStagerEnding.@numpermin.toString();
        obj.extend_time = _auctionFileXML.extendTime.toString();

        obj.table1 = "Update";

        return (obj);

    }

    protected function createItemObj(obj:Object):Object {
        var sellerID:String;
        sellerID = _auctionItemFileXML.dropDown.@id.toString();

        obj.sellerID = sellerID;
        obj.auctionID = _auctionID;
        obj.userType = _auctionItemFileXML.sellerType.toString();
        obj.auction_path = _auctionFileXML.path.toString();
        obj.item_name = _auctionItemFileXML.itemName.toString();
        obj.item_type = _auctionItemFileXML.category.toString();
        obj.item_status = "Active";
        obj.start_bid = _auctionItemFileXML.initialDollarBid + "." + _auctionItemFileXML.initialCentsBid;
        obj.max_bid = _auctionItemFileXML.reserveDollar + "." + _auctionItemFileXML.reserveCents;
        obj.quantity = _auctionItemFileXML.quantity.toString();
        obj.max_house_or_buynow = _auctionItemFileXML.buyNow.toString();
        obj.close_time = _auctionFileXML.isoTime.toString();
        obj.open_time = _auctionFileXML.auctionStagerEnding.@min.toString();
        obj.numitems_permin = _auctionFileXML.auctionStagerEnding.@numpermin.toString();
        obj.extend_time = _auctionFileXML.extendTime.toString();
        obj.table1 = "Add";

        return(obj);


    }

    protected function blankOutItemVar(obj:Object):Object {


        obj.sellerID = "";
        obj.userType = "";
        obj.auctionID = "";
        obj.auction_path = "";
        obj.itemID = "";
        obj.item_name = "";
        obj.item_description = "";
        obj.quantity = "";
        obj.item_type = "";
        obj.bid_increment = "";
        obj.start_bid = "";
        obj.current_bid = "";
        obj.max_bid = "";
        obj.max_house_or_buynow = "";
        obj.open_time = "";
        obj.close_time = "";
        obj.extend_time = "";
        obj.numitems_permin = "";
        obj.item_status = "";
        obj.created_date = "";
        obj.path = "";
        obj.info_xml = "";
        obj.bidhistory_xml = "";
        obj.thumbnail = "";

        obj.fileXML = "";

        obj.searchVar = "";
        obj.table1 = "";

        return(obj);

    }

    private function synchronizeDBwithFile():void {

        _auctionItemFileXML.sellerId = _auctionItemDBXML.sellerId.toString();
        _auctionItemFileXML.auctionId = _auctionItemDBXML.auctionId.toString();
        _auctionItemFileXML.itemId = _auctionItemDBXML.itemId.toString();
        _auctionItemFileXML.path = _auctionItemDBXML.path.toString();
        _auctionItemFileXML.info_xml = _auctionItemDBXML.info_xml.toString();
        _auctionItemFileXML.auctionId = _auctionItemDBXML.auctionId.toString();
        _auctionItemFileXML.category = _auctionItemDBXML.category.toString();


        /*
         _auctionItemFileXML.auctionId = _auctionItemDBXML.max_bid.toString();
         _auctionItemFileXML.auctionId = _auctionItemDBXML.currentBid.toString();
         _auctionItemFileXML.auctionId = _auctionItemDBXML.max_house_or_buynow.toString();
         _auctionItemFileXML.auctionId = _auctionItemDBXML.currBidWinner.toString();
         _auctionItemFileXML.auctionId = _auctionItemDBXML.currBidType.toString();
         _auctionItemFileXML.auctionId = _auctionItemDBXML.image[0].@file.toString();
         _auctionItemFileXML.auctionId = _auctionItemDBXML.isoTime.toString();
         _auctionItemFileXML.auctionId = _auctionItemDBXML.extendTime.toString();
         */

    }

///////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadItemObj(obj:Object):Object{
        obj.auctionID = _auctionID;
        obj.itemID = _itemID;
        obj.table1 = "Update";

        return (obj);

    }

///////////////////////////////////////////////////////////////////////////////////////////////////////


    private function saveItemXMLFile():void {
        var url:String;
        var obj:Object = new Object();

        url = "itemsXML.php";
        obj = blankOutItemVar(obj);
        obj = saveItemObj(obj);


        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, itemXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, itemXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);

        FlexGlobals.topLevelApplication.enabled = false;

    }

    private function saveItemObj(obj:Object):Object {

        var obj:Object = new Object();
        var node:XML = new XML();
        var url:String;

        node = new XML();
        node = <items></items>;
        node.appendChild(_auctionItemFileXML);


        var s:String = "<?xml version=" + '"' + "1.0" + '"' + " encoding=" + '"' + "UTF-8" + '"' + "?>\n";

        var FileSend:String;
        FileSend = s + node.toXMLString();

        obj.fileXML = FileSend;
        obj.path = _auctionItemFileXML.path.toString();
        obj.info_xml = _auctionItemFileXML.info_xml.toString();
        obj.auction_path = _auctionItemFileXML.auction_path.toString();

        node = _auctionItemFileXML.auctionImages.image[0];

        if (node != null) {
            obj.thumbnail = _auctionItemFileXML.auctionImages.image[0].@file.toString();
        }

        obj.table1 = "Save";

        return (obj);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    public function itemXMLFileFail(event:FaultEvent):void {

        var obj:Object = new Object();

        obj = XML(event.fault);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, itemXMLFileVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, itemXMLFileFail);

        FlexGlobals.topLevelApplication.enabled = true;
    }

    public function itemXMLFileVerify(event:ResultEvent):void {

        var obj:Object = new Object();
        var status:String;

        obj = XML(event.result);

        FlexGlobals.topLevelApplication.enabled = true;

        if (obj != null) {
            status = obj.toString();

            if (status == "Item Saved") {
                xmlService.removeEventListener(ResultEvent.RESULT, itemXMLFileVerify);
                xmlService.removeEventListener(FaultEvent.FAULT, itemXMLFileFail);

                this.dispatchEvent(event);
                return;
            }
        }

        this.dispatchEvent(event);

    }

    protected function itemDBXMLFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(event.fault);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, itemDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, itemDBXMLFail);

        this.dispatchEvent(event);

    }

    protected function itemDBXMLVerify(event:ResultEvent):void {
        var obj:Object;

        obj = XML(event.result);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, itemDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, itemDBXMLFail);

        var node:XML;
        node = obj.item[0] as XML;

        if (node != null) {
            _auctionItemDBXML = node;
            synchronizeDBwithFile();
            saveItemXMLFile();
        }
    }





    protected function itemDBXMLLoadFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(event.fault);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, itemDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, itemDBXMLFail);

        this.dispatchEvent(event);

    }

    protected function itemDBXMLLoadVerify(event:ResultEvent):void {
        var obj:Object;
        var url:String;

        obj = XML(event.result);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, itemDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, itemDBXMLFail);

        var node:XML;
        node = obj.item[0] as XML;

        if (node != null) {
            _auctionItemDBXML = node;
            url = _auctionItemDBXML.info_xml;
            loadItemFileXML(url);
        }
    }
}
}