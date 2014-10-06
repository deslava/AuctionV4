package components {
import auctionFunctionsClass.fileLoaderClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.events.GridSelectionEvent;

public class invoiceSelector extends invoiceSelectorLayout {

    public function invoiceSelector() {
        super();
    }

    private var _sellerID:String;
    private var sellerXmlFileLoader:HTTPService = new HTTPService();
    private var sellerFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _auctionSellerLists:XML = new XML();
    private var _auctionSellerXML:XML = new XML();
    private var _auctionSellerFileXML:XML = new XML();
    private var itemCategoriesXML:XML = new XML();
    private var _auctionItemFileXML:XML = new XML();
    private var _sellerItemDBXML:XML = new XML();
    private var tempUpdateXML:XML = new XML();
    private var xmlItemFileLoader:HTTPService = new HTTPService();
    private var fileItemLoader:fileLoaderClass = new fileLoaderClass();
    private var xmlFileLoader:HTTPService = new HTTPService();
    private var xc1:XMLListCollection = new XMLListCollection();
    private var xc3:XMLListCollection = new XMLListCollection();

    private var _loginUserID:String;

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _auctionID:Number = -1;

    public function get auctionID():Number {
        return _auctionID;
    }

    public function set auctionID(value:Number):void {
        _auctionID = value;
    }

    private var _itemID:Number = -1;

    public function get itemID():Number {
        return _itemID;
    }

    public function set itemID(value:Number):void {
        _itemID = value;
    }

    public function clearAuction():void {


        itemSeller.selectedIndex = -1;
        itemSeller.dataProvider = null;

        itemsListHolder.selectedIndex = -1;
        itemSeller.dataProvider = null;

        assignUserInvoiceEvents();
    }

    public function loadSellersLists():void {

        if (_auctionID == -1)
            return;

        var obj:Object = new Object();
        obj = blankOutSellerVar(obj);
        obj.searchVar = _auctionID;
        obj.table1 = "Load";
        loaditemSellerList(obj);

    }

    public function loadItemSellerSelected(i:int):void {
        var url:String = "";
        var node:XML = new XML();

        if (i == -1)
            return;

        node = _auctionSellerXML.Seller[i];

        url = node.info_xml;

        loadSellerFile(url);


    }


    /////////////////////////////////////////////////////////////////////////////////////////////////

    public function loadSellerFile(url:String):void {

        sellerXmlFileLoader = sellerFileLoader.xmlFileLoader;
        sellerXmlFileLoader.addEventListener(ResultEvent.RESULT, loadSellerFileVerify);
        sellerXmlFileLoader.addEventListener(FaultEvent.FAULT, loadSellerFileFail);

        sellerFileLoader.loadXML(url);


    }

    public function loadSellerXML():void {

        loadAuctionFeeType();


        _auctionSellerFileXML.normalize();


        /*	nameP9.text = _auctionSellerFileXML.name.toString();
         emailP9.text = _auctionSellerFileXML.email.toString();
         streetAuctionTab.text = _auctionSellerFileXML.address.toString();
         cityAuctionTab.text = _auctionSellerFileXML.city.toString();
         zipAuctionTab.text = _auctionSellerFileXML.zipcode.toString();
         feeAmountItem.text ="";

         tempXML  = _auctionSellerFileXML.copy();

         var xl:XMLList = XMLList(tempXML.auctionFees.children());
         xc8 = new XMLListCollection( xl  );
         auctionItemFeeHolder.dataProvider = xc8.list;
         auctionItemFeeHolder.validateNow();
         auctionItemFeeHolder.validateDisplayList();

         editSeller = true;
         assignStates();
         houseIDstates.selectedIndex  =valueTabSearch(houseIDstates, _auctionSellerFileXML.state);*/
    }

    public function sellersXML(obj:Object):void {
        var url:String;

        url = "sellersListXML.php";

        sellerXmlFileLoader = sellerFileLoader.xmlFileLoader;
        sellerXmlFileLoader.addEventListener(ResultEvent.RESULT, sellersXMLVerify);
        sellerXmlFileLoader.addEventListener(FaultEvent.FAULT, sellersXMLFail);

        sellerFileLoader.loadXML(url, obj);

    }

    public function sellersXMLValid():void {

        if (_auctionSellerXML.toString() == "ok") {
            _auctionSellerFileXML = tempUpdateXML;
            _auctionSellerFileXML.userId = _auctionSellerXML.@id;
            _auctionSellerFileXML.path = _auctionSellerXML.@path;
            _auctionSellerFileXML.info_xml = _auctionSellerXML.@info_xml;

            //	saveSellerXMLFile();
            loadSellersLists();

        }
        else if (itemCategoriesXML.toString() == "Error") {

        }

        else if (this.currentState == "AddItem") {

            loadSellersLists();
        }

        if (_auctionSellerXML.toString() == "Update") {

            //	_auctionSellerFileXML = tempUpdateXML;
            //			saveSellerXMLFile();
            loadSellersLists();
            //		editSeller = false;
        }


    }

    public function loadAuctionFeeType():void {
        var auctionFeeTypesXML:XML = <Types>
            <type id="$">$ Dollar</type>
            <type id="%">% Percent</type>
        </Types>;

        var productAttributes:XMLList = auctionFeeTypesXML.type.children();
        var xl:XMLList = XMLList(productAttributes);
        //xc5 = new XMLListCollection( xl  );

        //feeTypeDropDown.dataProvider = xc5.list;
        //feeTypeDropDown.selectedIndex = -1;


    }

    protected function loadAuctionItemsBtn_clickFunction():void {

        if (_auctionID == 0)
            return;
        // TODO Auto-generated method stub
        var obj:Object = new Object();

        obj = blankOutItemVar(obj);
        obj.searchVar = _sellerID;
        obj.auctionID = _auctionID;
        obj.table1 = "LoadUserSelected";

        itemsXML(obj);
    }

    protected function blankOutSellerVar(obj:Object):Object {


        obj.auctionId = "";
        obj.sellerId = "";
        obj.sellerPass = "";
        obj.sellerEmail = "";
        obj.sellerType = "";
        obj.sellerName = "";
        obj.itemsSelling = "";
        obj.path = "";
        obj.sellerXML = "";

        obj.fileXML = "";

        obj.searchVar = "";
        obj.table1 = "";

        return(obj);

    }


///////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignUserInvoiceEvents():void {
        invoiceLoadBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);
        viewAllItemsBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);
        loadItemInvoice.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);

        itemSeller.addEventListener(GridSelectionEvent.SELECTION_CHANGE, sellerListHolder_selectionChangeHandler);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////

    private function loaditemSellerList(obj:Object):void {
        var url:String;
        url = "sellersListXML.php";

        sellerXmlFileLoader = sellerFileLoader.xmlFileLoader;
        sellerXmlFileLoader.addEventListener(ResultEvent.RESULT, loaditemSellerListVerify);
        sellerXmlFileLoader.addEventListener(FaultEvent.FAULT, loaditemSellerListFail);

        sellerFileLoader.loadXML(url, obj);
    }

    private function loadSellerListValid():void {
        var node:XML = new XML();
        var node2:XML = new XML();

        loadSellerLists(_auctionSellerXML);


    }

    private function loadSellerLists(xml:XML):void {


        assignSellerLists();

    }

    private function assignSellerLists():void {

        if (_auctionSellerXML == null)
            return;

        var productAttributes:XMLList = _auctionSellerXML.Seller;
        var xl:XMLList = XMLList(productAttributes);
        xc3 = new XMLListCollection(xl);

        itemSeller.dataProvider = xc3.list;
        xc3;

        if (_auctionItemFileXML != null) {
            //itemSeller.selectedIndex  = valueTabSearch(itemSeller, _auctionItemFileXML.dropDown);

            //var i:int = itemSeller.selectedIndex;

            //loadItemSellerSelected(i);

        }
    }

    private function itemsXML(obj:Object):void {

        var url:String;

        url = "itemsXML.php";

        xmlItemFileLoader = new HTTPService();
        fileItemLoader = new fileLoaderClass();

        xmlItemFileLoader = fileItemLoader.xmlFileLoader;
        xmlItemFileLoader.addEventListener(ResultEvent.RESULT, itemsXMLVerify);
        xmlItemFileLoader.addEventListener(FaultEvent.FAULT, itemsXMLFail);
        fileItemLoader.loadXML(url, obj);
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////

    private function itemsXMLValid():void {

        var obj:Object = new Object();
        var node:XML = new XML();
        var node2:XML = new XML();
        var s:String = new String();
        var id:int = -1;

        node = _sellerItemDBXML;
        node;


        loadItemsList(_sellerItemDBXML);

    }

    private function loadItemsList(items:XML):void {
        _sellerItemDBXML = items;

        var productAttributes:XMLList = _sellerItemDBXML.children();
        var xl:XMLList = XMLList(productAttributes);
        xc1 = new XMLListCollection(xl);

        itemsListHolder.dataProvider = xc1.list;

    }

    private function blankOutItemVar(obj:Object):Object {


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

    public function loadSellerFileFail(event:Event):void {

        var obj:Object = new Object();
        obj = sellerXmlFileLoader.lastResult;


    }

    public function loadSellerFileVerify(event:Event):void {

        var responseXML:XML = XML(sellerXmlFileLoader.lastResult);
        _auctionSellerFileXML = responseXML.seller[0];

        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, sellersXMLVerify);
        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, sellersXMLFail);

    }


    /////////////////////////////////////////////////////////////////////////////////////////////////

    public function sellersXMLFail(event:Event):void {

        var obj:Object = new Object();
        obj = sellerXmlFileLoader.lastResult;

    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function sellersXMLVerify(event:Event):void {

        var responseXML:XML = XML(sellerXmlFileLoader.lastResult);
        _auctionSellerXML = responseXML;

        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, sellersXMLVerify);
        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, sellersXMLFail);

        sellersXMLValid();
    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }

    private function loaditemSellerListFail(event:Event):void {


    }

    private function loaditemSellerListVerify(event:Event):void {
        var node:XML;


        var responseXML:XML = XML(sellerXmlFileLoader.lastResult);
        _auctionSellerXML = responseXML;

        node = _auctionSellerXML;

        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, loaditemSellerListVerify);
        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, loaditemSellerListFail);

        loadSellerListValid();

    }

    private function sellerListHolder_selectionChangeHandler(event:GridSelectionEvent):void {

        var obj:Object = new Object();
        var s:String;


        obj = itemSeller.selectedItem;
        _sellerID = obj.userId;


        loadAuctionItemsBtn_clickFunction();

    }


    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function itemsXMLFail(event:Event):void {

        xmlItemFileLoader.removeEventListener(ResultEvent.RESULT, itemsXMLVerify);
        xmlItemFileLoader.removeEventListener(ResultEvent.RESULT, itemsXMLFail);

    }

    private function itemsXMLVerify(event:Event):void {
        var obj:Object = new Object();
        var t:String;
        var i:int = 0;
        var node:XML = new XML();
        var node2:XML = new XML()

        _sellerItemDBXML = XML(xmlItemFileLoader.lastResult);
        xmlItemFileLoader.removeEventListener(ResultEvent.RESULT, itemsXMLVerify);
        xmlItemFileLoader.removeEventListener(ResultEvent.RESULT, itemsXMLFail);

        i = _sellerItemDBXML.auction.length();

        node = _sellerItemDBXML;

        itemsXMLValid();

    }


}
}