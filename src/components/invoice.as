package components {
import auctionFunctionsClass.auctionClass;
import auctionFunctionsClass.auctionItemClass;
import auctionFunctionsClass.fileLoaderClass;
import auctionFunctionsClass.sellerClass;

import flash.events.Event;

import mx.collections.XMLListCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.RpcClassAliasInitializer;

public class invoice extends invoiceLayout {
    public function invoice() {
        super();
    }

    private var _sellerUserDBXML:XML;
    private var _sellerUserFileXML:XML;
    private var _bidderUserDBXML:XML;
    private var _bidderUserFileXML:XML;
    private var tempXML:XML;
    private var _auctionSellerLists:XML = new XML();
    private var _loginUserXML:XML = new XML();
    private var _auctionFileXML:XML;
    private var _auctionItemDBXML:XML;
    private var _auctionsItemListDBXML:XML;
    private var _auctionSellerFileXML:XML = new XML();
    private var xc8:XMLListCollection = new XMLListCollection();
    private var xmlFileLoader:HTTPService = new HTTPService();
    private var fileLoader:fileLoaderClass = new fileLoaderClass();
    private var xmlFileLoader2:HTTPService = new HTTPService();
    private var fileLoader2:fileLoaderClass = new fileLoaderClass();
    private var sellerXmlFileLoader:HTTPService = new HTTPService();
    private var sellerFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _seller:sellerClass = new sellerClass();
    private var _itemFeesXML:XML = new XML();


    private var auctionLoader:auctionClass = new auctionClass();
    private var itemLoader:auctionItemClass = new auctionItemClass();

    private var _sellerID:Number = 0;

    public function set sellerID(value:Number):void {
        _sellerID = value;
    }

    private var _bidderID:Number = 0;

    public function set bidderID(value:Number):void {
        _bidderID = value;
    }

    private var _currBid:Number = 0;

    public function set currBid(value:Number):void {
        _currBid = value;
    }

    private var _buyerID:Number = 0;

    public function set buyerID(value:Number):void {
        _buyerID = value;
    }

    private var _loginUserID:String = new String();

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _loginUserType:String = new String();

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    private var _auctionID:Number = 0;

    public function set auctionID(value:Number):void {
        _auctionID = value;
    }

    private var _itemID:Number = 0;

    public function set itemID(value:Number):void {
        _itemID = value;
    }

    private var _auctionDBXML:XML;

    public function set auctionDBXML(value:XML):void {
        _auctionDBXML = value;
    }

    private var _auctionItemFileXML:XML;

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value.item[0];
        _auctionItemFileXML;
    }

    private var _invoiceType:String = new String();

    public function set invoiceType(value:String):void {
        _invoiceType = value;
    }


    public function set auctionsItemListDBXML(value:XML):void {
        _auctionsItemListDBXML = value;
    }

    public function clear():void {

        companyInfo.text = "";
        bidderInfo.text = "";

        xc8 = new XMLListCollection();
        auctionItemFeeHolder.dataProvider = null;

        bidTotalTxt.text = "";
        premiumTotalTxt.text = "";
        subtotalTxt.text = "";
        taxAmountTxt.text = "";
        totalAmount.text = "";


        auctionItemFeeHolder.dataProvider = null;
        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();

        auctionLoader.auctionID = _auctionID;
        auctionLoader.loadAuctionByID(_auctionID);

        auctionLoader.addEventListener(ResultEvent.RESULT, auctionFileVerify);
        auctionLoader.addEventListener(FaultEvent.FAULT, auctionFileFail);

    }

  public function loadFeeXML():void {

        tempXML = _auctionItemFileXML.copy();

        var xl:XMLList = XMLList(tempXML.auctionFees.children());
        xc8 = new XMLListCollection(xl);
        auctionItemFeeHolder.dataProvider = xc8.list;
        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();

    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function loadAdminUsers():void {

        var obj:Object = new Object();

        obj.userSearch = "userId";
        obj.userType = "Admin";
        obj.searchVar = _loginUserID;


        loadUserLists(obj);
    }


    private function loadUserLists(obj:Object):void {

        var url:String;
        url = "searchUserList.php";

        xmlFileLoader = fileLoader.xmlFileLoader;
        xmlFileLoader.addEventListener(ResultEvent.RESULT, loadUserInfoXMLVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, loadUserInfoXMLFail);

        fileLoader.loadXML(url, obj);

    }

    private function loadUserInfoXMLFail(event:Event):void {


        _loginUserXML.userXML = "";

    }

    private function loadUserInfoXMLVerify(event:Event):void {

        _sellerUserDBXML = XML(xmlFileLoader.lastResult);

        verifyLoadUserInfoXMLValid();

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, loadUserInfoXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, loadUserInfoXMLFail);

    }

    private function verifyLoadUserInfoXMLValid():void {

        var urlPath:String;
        var node:XML = _sellerUserDBXML.user[0];
        urlPath = node.userPath.toString() + "userInfo.xml";

        xmlFileLoader = fileLoader.xmlFileLoader;
        xmlFileLoader.addEventListener(ResultEvent.RESULT, loadSellerUserInfoXMLVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, loadSellerUserInfoXMLFail);

        fileLoader.loadXML(urlPath);
    }

    private function loadSellerUserInfoXMLVerify(event:Event):void {


        _sellerUserFileXML = XML(xmlFileLoader.lastResult);

        verifyloadSellerUserInfoXMLValid();

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, loadSellerUserInfoXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, loadSellerUserInfoXMLFail);

    }

    private function loadSellerUserInfoXMLFail(event:Event):void {

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, loadSellerUserInfoXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, loadSellerUserInfoXMLFail);

    }


    private function verifyloadSellerUserInfoXMLValid():void {
        var node:XML = _sellerUserFileXML.Business[0];
        var fullTextSeller:String;
        var businessName:String;
        var businessAddress:String;
        var businessPhone:String;

        _sellerUserFileXML;
        businessName = node.name.toString();
        businessAddress = node.address.toString() + ", " + node.state.toString() + " " + node.zipcode.toString();
        businessPhone = "Phone: " + node.phone.toString();

        fullTextSeller = businessName + "\n" + businessAddress + "\n" + businessPhone;

        companyInfo.text = fullTextSeller;
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function loadBuyerUsers():void {

        var obj:Object = new Object();

        obj.userSearch = "userId";
        obj.userType = "Admin";

        if (_bidderID != 0) {
            obj.searchVar = _bidderID;
            loadBuyerUserLists(obj);
        }
        else {
            obj.searchVar = _sellerID;
            loadSellersLists();
        }


    }

    public function loadSellersLists():void {

        if (_auctionID == -1)
            return;

        var obj:Object = new Object();
        obj = blankOutObjVar(obj);
        obj.searchVar = _auctionID;
        obj.table1 = "Load";
        loaditemSellerList(obj);

    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function loaditemSellerList(obj:Object):void {
        var url:String;
        url = "sellersListXML.php";

        sellerXmlFileLoader = sellerFileLoader.xmlFileLoader;
        sellerXmlFileLoader.addEventListener(ResultEvent.RESULT, loaditemSellerListVerify);
        sellerXmlFileLoader.addEventListener(FaultEvent.FAULT, loaditemSellerListFail);

        sellerFileLoader.loadXML(url, obj);
    }



    public function loaditemSellerListFail(event:FaultEvent):void {

        var responseXML:XML = XML(event.fault);

        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, loaditemSellerListVerify);
        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, loaditemSellerListFail);

    }

    public function loaditemSellerListVerify(event:ResultEvent):void {

        var responseXML:XML = XML(event.result);
        _auctionSellerLists = responseXML;


        loadSellerListValid();

    }


    public function loadSellerListValid():void {

        loadItemSellerSelected(_sellerID);

    }



    private function loadBuyerUserLists(obj:Object):void {

        var url:String;
        url = "searchUserList.php";

        xmlFileLoader2 = fileLoader2.xmlFileLoader;
        xmlFileLoader2.addEventListener(ResultEvent.RESULT, loadBuyerUserDBXMLVerify);
        xmlFileLoader2.addEventListener(FaultEvent.FAULT, loadBuyerUserDBXMLFail);

        fileLoader2.loadXML(url, obj);

    }

    private function loadBuyerUserDBXMLFail(event:Event):void {


        _loginUserXML.userXML = "";

    }

    private function loadBuyerUserDBXMLVerify(event:Event):void {

        _bidderUserDBXML = XML(xmlFileLoader2.lastResult);

        verifyloadBuyerUserDBXMLValid();

        xmlFileLoader2.removeEventListener(ResultEvent.RESULT, loadBuyerUserDBXMLVerify);
        xmlFileLoader2.removeEventListener(FaultEvent.FAULT, loadBuyerUserDBXMLFail);

    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function verifyloadBuyerUserDBXMLValid():void {

        var urlPath:String;
        var node:XML = _bidderUserDBXML.user[0];

        if (node == null)
            return;

        urlPath = node.userPath.toString() + "userInfo.xml";

        xmlFileLoader2 = fileLoader2.xmlFileLoader;
        xmlFileLoader2.addEventListener(ResultEvent.RESULT, loadBuyerUserInfoXMLVerify);
        xmlFileLoader2.addEventListener(FaultEvent.FAULT, loadBuyerUserInfoXMLFail);

        fileLoader2.loadXML(urlPath);

    }

    private function loadBuyerUserInfoXMLVerify(event:Event):void {


        _bidderUserFileXML = XML(xmlFileLoader2.lastResult);

        verifyLoadBuyerUserInfoXMLValid();

        xmlFileLoader2.removeEventListener(ResultEvent.RESULT, loadBuyerUserInfoXMLVerify);
        xmlFileLoader2.removeEventListener(FaultEvent.FAULT, loadBuyerUserInfoXMLFail);

    }

    private function loadBuyerUserInfoXMLFail(event:Event):void {


        _bidderUserFileXML.userXML = "";

    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function verifyLoadBuyerUserInfoXMLValid():void {
        var node:XML = _bidderUserFileXML.Personal[0];
        var fullTextSeller:String;
        var businessName:String;
        var businessAddress:String;
        var businessPhone:String;

        _bidderUserFileXML;
        businessName = node.name.toString();
        businessAddress = node.address.toString() + ", " + node.state.toString() + " " + node.zipcode.toString();
        businessPhone = "Phone: " + node.phone.toString();

        fullTextSeller = businessName + "\n" + businessAddress + "\n" + businessPhone;

        bidderInfo.text = fullTextSeller;
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
    private function blankOutObjVar(obj:Object):Object {

        obj.searchVar = "";
        obj.table1 = "";


        return(obj);

    }

    private function searchNode(i:int):String {
        var url:String = "";

        var node:XMLList = _auctionSellerLists.Seller.(userId == i);
        url = node.info_xml;

        return url;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function loadItemSellerSelected(i:int):void {
        var url:String = "";
        var node:XML = new XML();

        if (i == -1)
            return;

        url = searchNode(i);
        _seller.auctionID = _auctionID;
        _seller.auctionSellerDBXML = node;
        _seller.loadSellerFile(url);

        _seller.addEventListener(ResultEvent.RESULT, saveSellerXMLVerify);
        _seller.addEventListener(FaultEvent.FAULT, saveSellerXMLFail);


    }

    protected function saveSellerXMLFail(event:FaultEvent):void {
        this.enabled = true;

        _seller.removeEventListener(ResultEvent.RESULT, saveSellerXMLVerify);
        _seller.removeEventListener(FaultEvent.FAULT, saveSellerXMLFail);
    }

    public function saveSellerXMLVerify(event:ResultEvent):void {

        this.enabled = true;

        var obj:Object;

        obj = XML(event.result);

        var node:XML;
        node = obj.seller[0] as XML;

        if (node != null) {
            _auctionSellerFileXML = node;
        }

        _seller.removeEventListener(ResultEvent.RESULT, saveSellerXMLVerify);
        _seller.removeEventListener(FaultEvent.FAULT, saveSellerXMLFail);

        sellerXMLValid();

    }

    private function sellerXMLValid():void {
        var node:XML = _auctionSellerFileXML;
        var fullTextSeller:String;
        var businessName:String;
        var businessAddress:String;
        var businessPhone:String;

        businessName = node.userName.toString();
        businessAddress = node.address.toString() + ", " + node.state.toString() + " " + node.zipcode.toString();
        businessPhone = "Phone: " + node.phone.toString();

        fullTextSeller = businessName + "\n" + businessAddress + "\n" + businessPhone;

        bidderInfo.text = fullTextSeller;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////


    public function loadItemListData():void{

        xmlPrint.text = _auctionsItemListDBXML.toString();

        if(_invoiceType == "loadSelectedInvoices")
        {
            loadItemData();
        }

    }

    private function loadItemData():void {

        itemLoader.loadItemWithID(_auctionID, _itemID);
        itemLoader.addEventListener(ResultEvent.RESULT, itemFileVerify);
        itemLoader.addEventListener(FaultEvent.FAULT, itemFileFail);
    }

    private function itemFileVerify(event:ResultEvent):void {
            var obj:Object;
            obj = XML(event.result);
            var node:XML = new XML();

            node = obj as XML;
            _auctionItemFileXML = node.item[0];
            _auctionItemDBXML = itemLoader.auctionItemDBXML;

            itemLoader.removeEventListener(ResultEvent.RESULT, itemFileVerify);
            itemLoader.removeEventListener(FaultEvent.FAULT, itemFileFail);

        addFinalBid();

    }

    private function itemFileFail(event:ResultEvent):void {
            var obj:Object;
            obj = XML(event.result);

            itemLoader.removeEventListener(ResultEvent.RESULT, itemFileVerify);
            itemLoader.removeEventListener(FaultEvent.FAULT, itemFileFail);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionFileVerify(event:ResultEvent):void {
        var obj:Object;
        obj = XML(event.result);
        var node:XML = new XML();

        node = obj as XML;
        _auctionFileXML = node.auction[0];
        _auctionDBXML = auctionLoader.auctionDBXML;

        auctionLoader.removeEventListener(ResultEvent.RESULT, auctionFileVerify);
        auctionLoader.removeEventListener(FaultEvent.FAULT, auctionFileFail);

    }

    private function auctionFileFail(event:ResultEvent):void {
        var obj:Object;
        obj = XML(event.result);

        auctionLoader.removeEventListener(ResultEvent.RESULT, auctionFileVerify);
        auctionLoader.removeEventListener(FaultEvent.FAULT, auctionFileFail);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function addFinalBid():void {
        _auctionDBXML;
        _auctionItemFileXML;
        var obj:Object = new Object();
        var xl:XMLList= new XMLList();

        obj = _auctionItemFileXML.auctionFees;
        _itemFeesXML = obj as XML;

        xl = _itemFeesXML.fee.(@id=="Reserve Fee");


        _auctionItemFileXML.auctionFees = new XML();

        var node:XML = new XML();
        node = <fee idBidder="" description="" id="" type="" amount="" display="" applyTo="" quantity="" ReserveMet="" BuyNow="" Winner="" ReserveFee="" Tax=""/>;

        _currBid =_auctionItemDBXML.start_bid;
        var _buyNow:String;
        var _reserveFee:String;
        var _reserveInit:String;
        var _reserve:int;
        var _sellerType:String;

        _sellerType = _bidderUserDBXML.user[0].userType;

        node.@BuyNow = _buyNow;
        _reserveInit = _auctionItemFileXML.reserveDollar;
        _reserve = int(_reserveInit);

        if(_reserve == 0 && _sellerType == "Bidder")
        {node.@ReserveMet = "true";}
        else if(_reserve > _currBid && _sellerType != "Bidder")
        {node.@ReserveMet = "false";}
        else
        {
            node.@ReserveMet = "true";
        }

        node.@Winner = _sellerType;
        node.@idBidder = _bidderID;
        node.@amount = _currBid;
        node.@id = _auctionItemFileXML.itemId;
        node.@quantity = _auctionItemFileXML.quantity;
        node.@description = _auctionItemFileXML.description;
        node.@display = "$" + node.@amount;
        node.@applyTo = "Item";

        _auctionItemFileXML.auctionFees.appendChild(node);

        addTaxes();

    }

    private function addTaxes():void {

        tempXML = _auctionItemFileXML.copy();


        var xl:XMLList = XMLList(tempXML.auctionFees.children());
        var XMLString:String = xl.toXMLString();

        var node:XML = new XML(XMLString);

        //_invoiceTax = Number(node.@amount.toString());

        xc8.addItem(node);

        auctionItemFeeHolder.dataProvider = xc8.list;
        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();

    }


/////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
}