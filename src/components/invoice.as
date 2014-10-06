package components {
import auctionFunctionsClass.fileLoaderClass;
import auctionFunctionsClass.sellerClass;

import flash.events.Event;

import mx.collections.XMLListCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class invoice extends invoiceLayout {
    public function invoice() {
        super();
    }

    private var _invoiceTotal:int = 0;
    private var _invoicePremiumAmount:int = 0;
    private var _invoiceSubtotalAmount:int = 0;
    private var _invoiceTax:Number = 0;
    private var _invoiceTaxAmountCharge:Number = 0;
    private var _invoiceFinalAmount:Number = 0;
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
    private var _auctionFileURL:String = new String();
    private var xc8:XMLListCollection = new XMLListCollection();
    private var auctionsxmlFileLoader:HTTPService = new HTTPService();
    private var auctionsfileLoader:fileLoaderClass = new fileLoaderClass();
    private var xmlFileLoader:HTTPService = new HTTPService();
    private var fileLoader:fileLoaderClass = new fileLoaderClass();
    private var xmlFileLoader2:HTTPService = new HTTPService();
    private var fileLoader2:fileLoaderClass = new fileLoaderClass();
    private var sellerXmlFileLoader:HTTPService = new HTTPService();
    private var sellerFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _seller:sellerClass = new sellerClass();
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

    public function clear():void {

        companyInfo.text = "";
        bidderInfo.text = "";

        auctionItemFeeHolder.dataProvider = null;

        bidTotalTxt.text = "";
        premiumTotalTxt.text = "";
        subtotalTxt.text = "";
        taxAmountTxt.text = "";
        totalAmount.text = "";

    }

    public function loadItemData():void {

        loadAuctionSellerInfo();
        //loadBuyerUsers();

        //addFinalBid();
        //calculateFinalBidTotal();
        //calculateFinalBidPreimum();
        //calculateFinalBidSubTotal();
        // calculateTaxAmount();

        //loadFeeXML();
    }

    public function loadBuyerData():void {

        loadAuctionSellerInfo();
        loadBuyerUsers();
    }

    public function loadFeeXML():void {


        tempXML = _auctionItemFileXML.copy();

        var xl:XMLList = XMLList(tempXML.auctionFees.children());
        xc8 = new XMLListCollection(xl);
        auctionItemFeeHolder.dataProvider = xc8.list;
        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();

    }

    public function loadAdminUsers():void {

        var obj:Object = new Object();

        obj.userSearch = "userId";
        obj.userType = "Admin";
        obj.searchVar = _loginUserID;


        loadUserLists(obj);
    }

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

    public function sumTotalsInvoice():void {


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

    public function loaditemSellerList(obj:Object):void {
        var url:String;
        url = "sellersListXML.php";

        sellerXmlFileLoader = sellerFileLoader.xmlFileLoader;
        sellerXmlFileLoader.addEventListener(ResultEvent.RESULT, loaditemSellerListVerify);
        sellerXmlFileLoader.addEventListener(FaultEvent.FAULT, loaditemSellerListFail);

        sellerFileLoader.loadXML(url, obj);
    }

    public function loadSellerListValid():void {

        loadItemSellerSelected(_sellerID);

    }

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

    public function loadSellerXML():void {


    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadAuctionSellerInfo():void {
        loadAdminUsers();

    }

    private function calculateTaxAmount():void {
        _invoiceTaxAmountCharge = _invoiceTax * Number(_invoiceSubtotalAmount);
        taxAmountTxt.text = _invoiceTaxAmountCharge.toString();
        _invoiceTax;

        calculateFinalTotalAmount();
    }

    private function calculateFinalTotalAmount():void {
        _invoiceFinalAmount = _invoiceTaxAmountCharge + Number(_invoiceSubtotalAmount);
        totalAmount.text = _invoiceFinalAmount.toFixed(2);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function calculateFinalBidSubTotal():void {
        _invoiceSubtotalAmount = _invoiceTotal + _invoicePremiumAmount;

        subtotalTxt.text = _invoiceSubtotalAmount.toString();
    }

    private function calculateFinalBidPreimum():void {
        _invoicePremiumAmount = _invoiceTotal * .10;
        premiumTotalTxt.text = _invoicePremiumAmount.toString();
    }

    private function calculateFinalBidTotal():void {
        var node:XML = XML(_auctionItemFileXML.auctionFees);

        var total:Number = 0;
        var totalMD:Number = 0;
        var i:int;
        var x:int = node.length();

        for (i = 0; i < x; i++) {
            total += Number(node.fee[i].@amount.toString());
        }

        _invoiceTotal = total;

        bidTotalTxt.text = total.toString();
    }

    private function addFinalBid():void {
        _auctionDBXML;
        _auctionItemFileXML;

        _auctionItemFileXML.item[0].auctionFees = new XML();

        var node:XML = new XML();
        node = <fee idBidder="" description="" id="" type="" amount="" display="" applyTo="" quantity=""/>;

        _currBid =_auctionItemDBXML.start_bid;

        node.@idBidder = _bidderID;
        node.@amount = _currBid;
        node.@id = _auctionItemFileXML.item[0].itemId;
        node.@quantity = _auctionItemFileXML.item[0].quantity;
        node.@description = _auctionItemFileXML.item[0].description;
        node.@display = "$" + node.@amount;
       node.@applyTo = "Item";

        _auctionItemFileXML.item[0].auctionFees.appendChild(node);


        //_auctionFileURL = _auctionDBXML.auctionXML;
        //loadAuctionFileXML(_auctionFileURL);

        addTaxes();

    }

    private function addTaxes():void {

        tempXML = _auctionItemFileXML.item[0].copy();


        var xl:XMLList = XMLList(tempXML.auctionFees.children());
        var XMLString:String = xl.toXMLString();

        var node:XML = new XML(XMLString);

        _invoiceTax = Number(node.@amount.toString());

        xc8.addItem(node);

        auctionItemFeeHolder.dataProvider = xc8.list;
        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();

        //calculateTaxAmount();
    }

    private function loadAuctionFileXML(_auctionURL:String):void {
        auctionsxmlFileLoader = new HTTPService();
        auctionsfileLoader = new fileLoaderClass();

        auctionsxmlFileLoader = auctionsfileLoader.xmlFileLoader;

        auctionsxmlFileLoader.addEventListener(ResultEvent.RESULT, auctionXMLVerify);
        auctionsxmlFileLoader.addEventListener(FaultEvent.FAULT, auctionXMLFail);


        auctionsfileLoader.loadXML(_auctionURL);


    }

    private function loadUserLists(obj:Object):void {

        var url:String;
        url = "searchUserList.php";

        xmlFileLoader = fileLoader.xmlFileLoader;
        xmlFileLoader.addEventListener(ResultEvent.RESULT, loadUserInfoXMLVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, loadUserInfoXMLFail);

        fileLoader.loadXML(url, obj);

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

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

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

    private function loadBuyerUserLists(obj:Object):void {

        var url:String;
        url = "searchUserList.php";

        xmlFileLoader2 = fileLoader2.xmlFileLoader;
        xmlFileLoader2.addEventListener(ResultEvent.RESULT, loadBuyerUserDBXMLVerify);
        xmlFileLoader2.addEventListener(FaultEvent.FAULT, loadBuyerUserDBXMLFail);

        fileLoader2.loadXML(url, obj);

    }

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

    public function loaditemSellerListFail(event:FaultEvent):void {


    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function loaditemSellerListVerify(event:ResultEvent):void {

        var responseXML:XML = XML(event.result);
        _auctionSellerLists = responseXML;

        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, loaditemSellerListVerify);
        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, loaditemSellerListFail);

        loadSellerListValid();

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

    protected function saveSellerXMLFail(event:FaultEvent):void {
        this.enabled = true;

        _seller.removeEventListener(ResultEvent.RESULT, saveSellerXMLVerify);
        _seller.removeEventListener(FaultEvent.FAULT, saveSellerXMLFail);
    }

    private function auctionXMLFail(event:Event):void {

        var obj:Object;

        obj = XML(auctionsxmlFileLoader.lastResult);
        obj;

    }

    private function auctionXMLVerify(event:Event):void {

        _auctionItemFileXML = XML(auctionsxmlFileLoader.lastResult);
        _auctionItemFileXML;


        xmlPrint.text = _auctionItemFileXML.toString();

        addFinalBid();
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

    private function loadBuyerUserDBXMLFail(event:Event):void {


        _loginUserXML.userXML = "";

    }

    private function loadBuyerUserDBXMLVerify(event:Event):void {

        _bidderUserDBXML = XML(xmlFileLoader2.lastResult);

        verifyloadBuyerUserDBXMLValid();

        xmlFileLoader2.removeEventListener(ResultEvent.RESULT, loadBuyerUserDBXMLVerify);
        xmlFileLoader2.removeEventListener(FaultEvent.FAULT, loadBuyerUserDBXMLFail);

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

    public function set auctionsItemListDBXML(value:XML):void {
        _auctionsItemListDBXML = value;
    }


    public function loadItemListData():void{

        xmlPrint.text = _auctionsItemListDBXML.toString();

        _auctionItemDBXML = _auctionsItemListDBXML.item[_itemID-1];

        _auctionItemFileXML;

        _auctionFileURL = _auctionItemDBXML.info_xml;

        _auctionFileURL;
        //addFinalBid();
        loadAuctionFileXML(_auctionFileURL);
    }
}
}