package auctionFunctionsClass {
import flash.events.Event;

import mx.collections.XMLListCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class auctionItemsListClass {
    public function auctionItemsListClass() {

        _auctionFileXML = new XML();
        _auctionDBXML = new XML();
        _auctionID = 0;


        _auctionItemsFile = new XML();
        _auctionItemDBXML = new XML();
        _auctionItemsFeesXML = new XML();
        _auctionItemsDBListXML = new XML();

        _itemObject = new Object();

        xmlFileLoader = new fileLoaderClass();
        xmlService = new HTTPService();

    }

    public var xmlFileLoader:fileLoaderClass;
    public var xmlService:HTTPService;
    private var _auctionFileXML:XML;
    private var _auctionDBXML:XML;
    private var _auctionID:int;
    private var _itemURL:String;
    private var _auctionItemsFile:XML;
    private var _auctionItemDBXML:XML;
    private var _auctionItemsFeesXML:XML;
    private var _itemObject:Object;

    private var _auctionItemsDBListXML:XML;

    public function set auctionItemsDBListXML(xml:XML):void {


        _auctionItemsDBListXML = xml;

    }


    public function loadItemsListDBXML(itemURL:String = "itemsXML.php", auctionID:int = 0):void {


        _auctionID = auctionID;

        _itemURL = itemURL;
        _itemObject = blankOutItemVar(_itemObject);
        _itemObject.searchVar = _auctionID;
        _itemObject.table1 = "LoadAll";

        xmlService = xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, itemsListXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, itemsListXMLVerify);

        xmlFileLoader.loadXML(_itemURL, _itemObject);
    }

    public function auctionItemsCollectionList():XMLListCollection {

        var xl:XMLList = XMLList(_auctionItemsDBListXML.children());
        var xc:XMLListCollection = new XMLListCollection(xl);
        return xc;
    }

    protected function blankOutItemVar(obj:Object):Object {


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

    protected function itemsListXMLFail(event:Event):void {

        var obj:Object;

        obj = XML(xmlService.lastResult);
        obj;


    }

    protected function itemsListXMLVerify(event:Event):void {
        _auctionItemDBXML = XML(xmlService.lastResult);
        _auctionItemDBXML;

    }
}
}