/**
 * Created by Daniel Eslava on 4/25/2014.
 */
package auctionFunctionsClass {
import mx.managers.CursorManager;
import mx.rpc.AbstractInvoker;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class userBidderClass extends AbstractInvoker {

    public function userBidderClass() {


    }

    private var _userBidderListDB:XML;
    private var _xmlFileLoader:fileLoaderClass;
    private var xmlService:HTTPService;

    private var _loginUserID:String;

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _loginUserType:String;

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    public function searchBidderList():void {
        var url:String;
        var obj:Object = new Object();

        obj = blankOutObj(obj);
        obj = userBidderSearch(obj);

        url = "searchUserList.php";

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, userBidderListDBVerify);
        xmlService.addEventListener(FaultEvent.FAULT, userBidderListDBFail);

        _xmlFileLoader.loadXML(url, obj);

    }

    private function userBidderSearch(obj:Object):Object {

        obj.userSearch = "HouseNumbers";
        obj.userType = _loginUserType;
        obj.searchVar = _loginUserID;

        return obj;
    }

    private function blankOutObj(obj:Object):Object {

        obj.userSearch = "";
        obj.userType = "";
        obj.searchVar = "";

        return obj;
    }

    private function userBidderListDBVerify(event:ResultEvent):void {

        var obj:Object;

        CursorManager.removeBusyCursor();

        obj = XML(event.result);
        _userBidderListDB = obj as XML;

        xmlService.removeEventListener(ResultEvent.RESULT, userBidderListDBVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, userBidderListDBFail);

        this.dispatchEvent(event);
    }

    private function userBidderListDBFail(event:FaultEvent):void {

        var obj:Object;

        CursorManager.removeBusyCursor();

        obj = XML(event.fault);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, userBidderListDBVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, userBidderListDBFail);

        this.dispatchEvent(event);

    }
}
}
