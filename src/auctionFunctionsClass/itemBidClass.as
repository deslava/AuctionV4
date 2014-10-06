package auctionFunctionsClass {
import flash.events.Event;

import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class itemBidClass {

    public function itemBidClass() {

        _auctionID = 0;
        _itemID = 0;
        _bidDBXML = new XML();

        xmlFileLoader = new fileLoaderClass();

        xmlService = new HTTPService();


    }

    public var xmlFileLoader:fileLoaderClass;
    [Bindable]
    public var xmlService:HTTPService;
    protected var _bidHistoryXML:XML;

    protected var _fileURL:String;

    protected var _auctionID:Number;

    public function set auctionID(num:Number):void {

        _auctionID = num;
    }

    protected var _itemID:Number;

    public function set itemID(num:Number):void {


    }

    protected var _bidDBXML:XML;

    public function get bidDBXML():XML {

        return _bidDBXML;
    }

    public function loadBidDBXML(auctionId:Number = 0, itemId:Number = 0, url:String = "bidFunctions.php"):void {
        var obj:Object = new Object();

        _auctionID = auctionId;
        _itemID = itemId;

        _fileURL = url;

        xmlService = new HTTPService();

        xmlService = xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, loadBidDBXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, loadBidDBXMLFail);

        obj = blankOutItemVar(obj);
        obj.table1 = "currentItemTopBid";
        obj.auctionID = _auctionID;
        obj.itemID = _itemID;
        obj.searchVar = _itemID;

        xmlFileLoader.loadXML(_fileURL, obj);


    }

    public function sendBidDB(objBid:Object, url:String = "bidFunctions.php"):void {
        var obj:Object = new Object();

        _fileURL = url;

        blankOutItemVar(obj);

        obj.auctionID = objBid.auctionID;
        obj.itemID = objBid.itemID;
        obj.userID = objBid.userID;
        obj.userState = objBid.userState;
        obj.userCurrBid = objBid.userCurrBid;
        obj.userBidIncrement = objBid.userBidIncrement;
        obj.extendtime = objBid.extendtime;
        obj.userMaxBid = objBid.userMaxBid;
        obj.searchVar = objBid.searchVar;
        obj.userType = objBid.userType;

        obj.table1 = objBid.table1;


        xmlService = xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, loadBidDBXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, loadBidDBXMLFail);

        xmlFileLoader.loadXML(_fileURL, obj);

    }

    public function loadBidHistoryXML(auctionId:Number = 0, itemId:Number = 0, url:String = "bidFunctions.php"):void {
        var obj:Object = new Object();

        _auctionID = auctionId;
        _itemID = itemId;

        _fileURL = url;

        xmlService = xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, loadBidDBXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, loadBidDBXMLFail);

        obj = blankOutItemVar(obj);
        obj.table1 = "bidHistory";
        obj.auctionID = _auctionID;
        obj.itemID = _itemID;
        obj.searchVar = _itemID;
        obj.userType = "";

        xmlFileLoader.loadXML(_fileURL, obj);


    }

    protected function blankOutItemVar(obj:Object):Object {


        obj.userID = "";
        obj.userCurrBid = "";
        obj.userMaxBid = "";
        obj.userBidIncrement = "";
        obj.userState = "";
        obj.extendtime = "";
        obj.userType = "";

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

    public function loadBidDBXMLFail(event:Event):void {

        var obj:Object;

        obj = XML(xmlService.lastResult);
        obj;


    }

    public function loadBidDBXMLVerify(event:Event):void {

        _bidDBXML = XML(xmlService.lastResult);
        _bidDBXML;

    }

    public function loadBidHistoryXMLFail(event:Event):void {

        var obj:Object;

        obj = XML(xmlService.lastResult);
        obj;


    }

    public function loadBidHistoryXMLVerify(event:Event):void {

        _bidHistoryXML = XML(xmlService.lastResult);
        _bidHistoryXML;

    }
}
}