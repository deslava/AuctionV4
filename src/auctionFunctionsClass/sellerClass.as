package auctionFunctionsClass {
import mx.rpc.AbstractInvoker;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]


public class sellerClass extends AbstractInvoker {
    public function sellerClass() {
        _auctionSellerFileXML = new XML();

    }

    public var _xmlFileLoader:fileLoaderClass;
    public var xmlService:HTTPService;

    private var _auctionFileXML:XML;

    public function get auctionFileXML():XML {
        return _auctionFileXML;
    }

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;
    }

    private var _auctionSellerFileXML:XML;

    public function get auctionSellerFileXML():XML {
        return _auctionSellerFileXML;
    }

    public function set auctionSellerFileXML(value:XML):void {
        _auctionSellerFileXML = value;
    }

    private var _auctionSellerDBXML:XML;

    public function get auctionSellerDBXML():XML {
        return _auctionSellerDBXML;
    }

    public function set auctionSellerDBXML(value:XML):void {
        _auctionSellerDBXML = value;
    }

    private var _auctionID:int;

    public function get auctionID():int {
        return _auctionID;
    }

    public function set auctionID(value:int):void {
        _auctionID = value;
    }

    private var _currentEdit:Boolean;

    public function get currentEdit():Boolean {
        return _currentEdit;
    }

    public function set currentEdit(value:Boolean):void {
        _currentEdit = value;
    }

    public function createSeller():void {
        createNewSellerXML();
    }

    public function saveSeller():void {
        var obj:Object = new Object();
        var url:String;

        url = "sellersListXML.php";
        obj = blankOutSellerVar(obj);


        if (_currentEdit == false) {
            obj = createSellerObj(obj);
        }

        else {
            obj = updateSellerObj(obj);
        }


        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, sellerDBXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, sellerDBXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);

    }

    public function loadSellerFile(_sellerURL:String):void {

        var url:String = "fileRead.php";
        var obj:Object = new Object();
        obj.fileName = _sellerURL;

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, sellerXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, sellerXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);


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

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function createSellerObj(obj:Object):Object {
        _auctionSellerFileXML.auctionId = _auctionID;
        _auctionSellerFileXML.userType = "Seller";
        _auctionSellerFileXML.userState = "Active";
        _auctionSellerFileXML.items = "0";
        _auctionSellerFileXML.path = "";


        obj.auctionId = _auctionID;
        obj.sellerId = _auctionSellerFileXML.userId.toString();
        obj.sellerName = _auctionSellerFileXML.userName.toString();
        obj.sellerPass = "";
        obj.sellerEmail = _auctionSellerFileXML.email.toString();
        obj.sellerType = _auctionSellerFileXML.userType.toString();

        obj.itemsSelling = _auctionSellerFileXML.items.toString();

        var path:String = _auctionFileXML.path.toString();

        obj.path = path + "sellers/";
        obj.sellerXML = _auctionSellerFileXML.info_xml.toString();
        obj.fileXML = _auctionSellerFileXML.path.toString();

        obj.searchVar = "";
        obj.table1 = "Add";

        return(obj);

    }

    protected function updateSellerObj(obj:Object):Object {


        obj.auctionId = _auctionID;
        obj.sellerId = _auctionSellerFileXML.userId.toString();
        obj.sellerPass = "";
        obj.sellerEmail = _auctionSellerFileXML.email.toString();
        obj.sellerType = _auctionSellerFileXML.userType.toString();
        obj.sellerName = _auctionSellerFileXML.userName.toString();
        obj.itemsSelling = _auctionSellerFileXML.items.toString();
        obj.path = _auctionSellerFileXML.path.toString();
        obj.sellerXML = _auctionSellerFileXML.info_xml.toString();

        obj.searchVar = "";
        obj.table1 = "Update";

        return(obj);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function saveSellerObj(obj:Object):Object {

        var url:String;

        var node:XML = new XML();
        node = <Sellers></Sellers>;
        node.appendChild(_auctionSellerFileXML);


        var s:String = "<?xml version=" + '"' + "1.0" + '"' + " encoding=" + '"' + "UTF-8" + '"' + "?>\n";

        var FileSend:String;
        FileSend = s + node.toXMLString();

        obj.fileXML = FileSend;
        obj.sellerId = _auctionSellerFileXML.userId.toString();
        obj.sellerXML = _auctionSellerFileXML.info_xml.toString();
        obj.path = _auctionSellerFileXML.path.toString();
        obj.table1 = "Save";

        return(obj);

    }

    private function createNewSellerXML():void {


        _auctionSellerFileXML = <seller>
            <auctionId/>
            <userId/>
            <userState/>
            <email/>
            <address/>
            <city/>
            <state/>
            <zipcode/>
            <phone/>
            <userType/>
            <userName/>
            <items/>
            <path/>
            <info_xml/>
            <auctionFees/>
        </seller>;

    }

    private function saveSellerXMLFile():void {
        var obj:Object = new Object();
        var url:String;

        url = "sellersListXML.php";
        obj = blankOutSellerVar(obj);
        obj = saveSellerObj(obj);

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, sellerXMLFileVerify);
        xmlService.addEventListener(FaultEvent.FAULT, sellerXMLFileFail);

        _xmlFileLoader.loadXML(url, obj);
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////

    private function sycronizeDBwithFile():void {
        _auctionSellerFileXML.userId = _auctionSellerDBXML.userId.toString();
        _auctionSellerFileXML.email = _auctionSellerDBXML.email.toString();
        _auctionSellerFileXML.userType = _auctionSellerDBXML.userType.toString();
        _auctionSellerFileXML.userName = _auctionSellerDBXML.userName.toString();
        _auctionSellerFileXML.items = _auctionSellerDBXML.items.toString();
        _auctionSellerFileXML.path = _auctionSellerDBXML.path.toString();
        _auctionSellerFileXML.info_xml = _auctionSellerDBXML.info_xml.toString();

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////

    protected function sellerDBXMLFileFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        xmlService.removeEventListener(ResultEvent.RESULT, sellerDBXMLFileVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, sellerDBXMLFileFail);

    }

    protected function sellerDBXMLFileVerify(event:ResultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        xmlService.removeEventListener(ResultEvent.RESULT, sellerDBXMLFileVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, sellerDBXMLFileFail);

        var node:XML;
        node = obj.Seller[0] as XML;

        if (node != null) {
            _auctionSellerDBXML = node;
            sycronizeDBwithFile();
            saveSellerXMLFile();
        }
    }

    protected function sellerXMLFileFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(event.fault);

        xmlService.removeEventListener(ResultEvent.RESULT, sellerXMLFileVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, sellerXMLFileFail);

        this.dispatchEvent(event);


    }

    protected function sellerXMLFileVerify(event:ResultEvent):void {
        var obj:Object;

        obj = XML(event.result);

        xmlService.removeEventListener(ResultEvent.RESULT, sellerXMLFileVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, sellerXMLFileFail);

        var status:String;

        if (obj != null) {
            status = obj.toString();

            if (status == "Seller Saved") {

                this.dispatchEvent(event);
                return;
            }

            var node:XML;
            node = obj.seller[0] as XML;
            _auctionSellerFileXML = node;

        }

        this.dispatchEvent(event);
    }
}
}