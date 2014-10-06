/**
 * Created by Daniel Eslava on 4/22/2014.
 */
package auctionFunctionsClass {

import mx.managers.CursorManager;
import mx.rpc.AbstractInvoker;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class userClass extends AbstractInvoker {

    public function userClass() {

    }

    public var _xmlFileLoader:fileLoaderClass;
    public var xmlService:HTTPService;
    private var _loggedIn:Boolean;
    private var _loginUserType:String;
    private var _loginUserStatus:String;

    private var _userDBXML:XML;

    private var _loginString:String;

    public function get loginString():String {
        return _loginString;
    }

    public function set loginString(value:String):void {
        _loginString = value;
    }

    private var _loginUserID:String;

    public function get loginUserID():String {
        return _loginUserID;
    }

    private var _loginUserEmail:String

    public function get loginUserEmail():String {
        return _loginUserEmail;
    }

    private var _loginUserPass:String;

    public function set loginUserPass(value:String):void {
        _loginUserPass = value;
    }

    private var _loginUserState:String;

    public function get loginUserState():String {
        return _loginUserState;
    }

    public function logInUser():void {
        var obj:Object = new Object();
        var url:String;

        url = "login.php";

        logInValidator();

        obj = blankOutUserVar(obj);
        obj = logInUserObj(obj);

        xmlService = new HTTPService();
        _xmlFileLoader = new fileLoaderClass();

        xmlService = _xmlFileLoader.xmlFileLoader;
        xmlService.addEventListener(ResultEvent.RESULT, userDBVerify);
        xmlService.addEventListener(FaultEvent.FAULT, userDBFail);

        _xmlFileLoader.loadXML(url, obj);

        CursorManager.setBusyCursor();

    }

    private function logInValidator():void {
        var checkEmail:Boolean;
        var t:int;

        t = _loginString.search("@");

        if (t == -1) {
            checkEmail = false;
            _loginUserID = _loginString;
            _loginUserEmail = "";
            _loginUserType = "id";
        }
        else {
            checkEmail = true;
            _loginUserID = "";
            _loginUserEmail = _loginString;
            _loginUserType = "email";
        }
    }

    private function blankOutUserVar(obj:Object):Object {

        obj.username = "";
        obj.password = "";
        obj.type = "";

        return obj;
    }

    private function logInUserObj(obj:Object):Object {

        if (_loginUserEmail == "")
            obj.username = _loginUserID;
        else
            obj.username = _loginUserEmail;

        obj.password = _loginUserPass;
        obj.type = _loginUserType;

        return obj;
    }

    private function userDBVerify(event:ResultEvent):void {

        CursorManager.removeBusyCursor();

        _userDBXML = XML(event.result);


        xmlService.removeEventListener(ResultEvent.RESULT, userDBVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, userDBFail);

        updateUserInfo();

        this.dispatchEvent(event);
    }

    private function userDBFail(event:FaultEvent):void {

        var obj:Object;

        CursorManager.removeBusyCursor();

        obj = XML(event.fault);
        obj;

        xmlService.removeEventListener(ResultEvent.RESULT, userDBVerify);
        xmlService.removeEventListener(FaultEvent.FAULT, userDBFail);

        this.dispatchEvent(event);

    }

    private function  updateUserInfo():void{

        _loggedIn = true;
        _loginUserID = _userDBXML.userId;
        _loginUserEmail = _userDBXML.userEmail;
        _loginUserStatus = _userDBXML.userStatus;
        _loginUserType = _userDBXML.userType;
        _loginUserState = _userDBXML.userState;
    }

}
}
