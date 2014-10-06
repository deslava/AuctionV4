package auctionFunctionsClass {
import mx.rpc.AbstractInvoker;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]

public class auctionsListClass extends AbstractInvoker {
    public function auctionsListClass() {
    }

    public var _xmlFileLoader:fileLoaderClass;
    public var xmlService:HTTPService;

    private var _loginUserID:String;

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _auctionListsDBXML:XML;

    public function get auctionListsDBXML():XML {
        return _auctionListsDBXML;
    }

    public function set auctionListsDBXML(value:XML):void {
        _auctionListsDBXML = value;
    }

    public function loadAuctionList(obj:Object = null):void {
        var url:String;

        url = "AuctionXML.php";

        if (obj == null) {
            obj = blankOutAuctionVar(obj);
        }

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;

        xmlService.addEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        xmlService.addEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);

        _xmlFileLoader.loadXML(url, obj);

    }

    public function loadAuctionsListObj(obj:Object):Object {
        obj.table1 = "LoadAll";
        obj.searchVar = _loginUserID;

        return obj;
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

    /////////////////////////////////////////////////////////////////////////////////////////////////

    protected function auctionsListDBXMLFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        xmlService.removeEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);
        this.dispatchEvent(event);

    }

    protected function auctionsListDBXMLVerify(event:ResultEvent):void {
        var obj:Object;

        obj = XML(xmlService.lastResult);
        _auctionListsDBXML = obj as XML;
        xmlService.removeEventListener(ResultEvent.RESULT, auctionsListDBXMLVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, auctionsListDBXMLFail);
        this.dispatchEvent(event);

    }
}
}