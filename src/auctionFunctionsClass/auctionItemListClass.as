package auctionFunctionsClass {
import mx.rpc.AbstractInvoker;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]

public class auctionItemListClass extends AbstractInvoker {
    public function auctionItemListClass() {
    }

    public var _xmlFileLoader:fileLoaderClass;
    public var xmlService:HTTPService;
    private var _itemID:int;
    private var _currItem:int = 0;
    private var _currLength:int = 0;
    private var _auctionItemsDBXML:XML;
    private var _auctionItemsListXML:XML;
    private var _item:auctionItemClass = new auctionItemClass();

    private var _auctionItemDBXML:XML;

    public function get auctionItemDBXML():XML {
        return _auctionItemDBXML;
    }

    public function set auctionItemDBXML(value:XML):void {
        _auctionItemDBXML = value;
    }

    private var _auctionID:int;

    public function get auctionID():int {
        return _auctionID;
    }

    public function set auctionID(value:int):void {
        _auctionID = value;
    }

    public function loadAuctionItemList(obj:Object = null):void {
        var url:String;

        url = "itemsXML.php";

        if (obj == null) {
            obj = new Object();
            obj = blankOutItemVar(obj);
            obj = itemsListDB(obj);
        }

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, itemDBXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, itemDBXMLFail);

        _xmlFileLoader.loadXML(url, obj);
    }


    public function deleteItemFromList(_value:int):void {
        var url:String;
        var obj:Object = new Object();

        _itemID = _value;

        url = "itemsXML.php";
        obj = blankOutItemVar(obj);
        obj = deleteItemDB(obj);

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, itemXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, itemXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    public function blankOutItemVar(obj:Object):Object {


        obj.sellerID = "";
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

    public function loadAllItemsListXML():void {
        var url:String;

        _currLength = _auctionItemsDBXML.item.length();


        if (_currItem < _currLength) {

            if (_currItem == 0) {
                _auctionItemsListXML = new XML();
                _auctionItemsListXML = <invoice></invoice>;
            }
            url = _auctionItemsDBXML.item[_currItem].info_xml.toString();
            loadAllItemsLoop(url);
        }
        else {
            _currItem = 0;
            _currLength = 0;
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    private function itemsListDB(obj:Object):Object {
        // TODO Auto Generated method stub
        obj.searchVar = _auctionID;
        obj.table1 = "LoadAll";

        return obj;
    }

    private function deleteItemDB(obj:Object):Object {
        obj.auctionID = _auctionID;
        obj.itemID = _itemID.toString();
        obj.auction_path = _auctionItemDBXML.path.toString();
        obj.table1 = "Delete";

        return obj;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadAllItemsLoop(url:String):void {

        _item = new auctionItemClass();
        _item.loadItemFileXML(url);
        _item.addEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.addEventListener(FaultEvent.FAULT, auctionItemXMLFail);

    }

    private function checkCount():void {
        _currItem++;

        loadAllItemsListXML();
    }

    public function itemXMLFileFail(event:FaultEvent):void {

        var obj:Object = new Object();

        obj = XML(event.fault);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, itemXMLFileVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, itemXMLFileFail);


    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    public function itemXMLFileVerify(event:ResultEvent):void {

        var obj:Object = new Object();
        var status:String;

        obj = XML(event.result);


        if (obj != null) {
            status = obj.toString();

            if (status == "delete ok") {
                xmlService.removeEventListener(ResultEvent.RESULT, itemXMLFileVerify);
                xmlService.removeEventListener(FaultEvent.FAULT, itemXMLFileFail);

                this.dispatchEvent(event);
                return;
            }
        }

    }

    protected function itemDBXMLFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(event.fault);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, itemDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, itemDBXMLFail);

        this.dispatchEvent(event);
        return;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function itemDBXMLVerify(event:ResultEvent):void {
        var obj:Object;

        obj = XML(event.result);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, itemDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, itemDBXMLFail);

        var node:XML;
        node = obj as XML;

        //i =_auctionItemDBXML.auction.length();

        _auctionItemsDBXML = node;

        this.dispatchEvent(event);
        return;

    }

    private function auctionItemXMLFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);

        _item.removeEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.removeEventListener(FaultEvent.FAULT, auctionItemXMLFail);

    }

    private function auctionItemXMLVerify(event:ResultEvent):void {

        var obj:Object;
        obj = new Object();

        obj = XML(event.result);
        _item.removeEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _item.removeEventListener(FaultEvent.FAULT, auctionItemXMLFail);

        var node:XML;
        node = obj.item[0] as XML;

        if (node != null)
            _auctionItemsListXML.appendChild(node);

        if (_currItem == (_currLength - 1))
            this.dispatchEvent(event);

        checkCount();
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
}