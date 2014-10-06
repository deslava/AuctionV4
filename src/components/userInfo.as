package components {
import auctionFunctionsClass.fileLoaderClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.components.DropDownList;

public class userInfo extends userInfoLayout {

    public function userInfo() {
        //TODO: implement function
        super();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, adminUserInfoCom_creationCompleteHandler);
    }

    public var xmlFileLoader:HTTPService = new HTTPService();
    public var fileLoader:fileLoaderClass = new fileLoaderClass();
    private var statesXML:XML = new XML();
    private var ccXML:XML = new XML();
    private var xc:XMLListCollection = new XMLListCollection;
    private var xc2:XMLListCollection = new XMLListCollection;
    private var usStatesXML:XML = new XML();
    private var xmlStatesLoader:HTTPService = new HTTPService();
    private var stateFileLoader:fileLoaderClass = new fileLoaderClass();

    private var _loginUserID:String = new String();

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _userXML:XML = new XML();

    public function get userXML():XML {
        return _userXML;
    }

    public function set userXML(value:XML):void {
        _userXML = value;
    }

    private var _userFileXML:XML;

    public function get userFileXML():XML {
        return _userFileXML;
    }

    public function set userFileXML(value:XML):void {
        _userFileXML = value;
    }

    private var _userDBXML:XML

    public function get userDBXML():XML {
        return _userDBXML;
    }

    public function set userDBXML(value:XML):void {
        _userDBXML = value;
    }

    public function clearStaticInfo():void {

        userNameLabel.text = "";
        userIdLabel.text = "";
        userPassLabel.text = "";
        userEmailLabel.text = "";
        userTypeLabel.text = "";
        userCurrStateLabel.text = "";

        nameTxtLabel.text = "";
        addressTxtLabel.text = "";
        stateTxtLabel.text = "";
        zipocodeTxtLabel.text = "";
        phoneTxtLabel.text = "";

        name1TxtLabel.text = "";
        address1TxtLabel.text = "";
        state1TxtLabel.text = "";
        zipcode2TxtLabel.text = "";
        phone2TxtLabel.text = "";


        CCTxtLabel.text = "";
        ccNumTxtLabel.text = "";
        experationTxtLabel.text = "";
        cscTxtLabel.text = "";
        accountStatusTxtLabel.text = "";

    }

    public function userInfoDisplay():void {
        var node:XML = new XML;
        var i:int;


        userNameLabel.text = _userDBXML.userName;
        userIdLabel.text = _userDBXML.userId;
        userPassLabel.text = "************";
        userEmailLabel.text = _userDBXML.userEmail;
        userTypeLabel.text = _userDBXML.userType;
        userCurrStateLabel.text = _userDBXML.userState;

        accountStatusTxtLabel.text = _userDBXML.userStatus;

        nameTxtLabel.text = _userFileXML.Personal.name;
        addressTxtLabel.text = _userFileXML.Personal.address;
        stateTxtLabel.text = _userFileXML.Personal.state;
        zipocodeTxtLabel.text = _userFileXML.Personal.zipcode;
        phoneTxtLabel.text = _userFileXML.Personal.phone;

        name1TxtLabel.text = _userFileXML.Business.name;
        address1TxtLabel.text = _userFileXML.Business.address;
        state1TxtLabel.text = _userFileXML.Business.state;
        zipcode2TxtLabel.text = _userFileXML.Business.zipcode;
        phone2TxtLabel.text = _userFileXML.Business.phone;


        if (_userXML.userType == "Admin" || _userXML.userType == "Satellite") {
            CreditCardBox1.visible = false;
            return;
        }


        if (_userFileXML.Personal.CC.@type != "")
            node = _userFileXML.Personal.CC;
        else if (_userFileXML.Business.CC.@type != "")
            node = _userFileXML.Business.CC;
        else
            return;

        CCTxtLabel.text = node.type;
        ccNumTxtLabel.text = node.number;
        experationTxtLabel.text = node.expMonth + "/" + node.expYear;
        cscTxtLabel.text = node.csc;
        accountStatusTxtLabel.text = _userXML.userStatus;

    }

    public function loadUserInfoXML():void {
        var obj:Object = new Object;
        var url:String;
        var s:String;
        var users:int;
        var node:XML = new XML();

        xmlFileLoader = new HTTPService();
        fileLoader = new fileLoaderClass();

        users = userXML.length();
        node = userDBXML;

        s = node.userXML;

        if (s == "") {
            url = "userInfo.xml";
            obj = new Object();
        }
        else {

            url = node.userPath.toString() + node.userXML.toString();
            obj = new Object();
        }


        xmlFileLoader = fileLoader.xmlFileLoader;
        xmlFileLoader.addEventListener(ResultEvent.RESULT, loadUserInfoXMLVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, loadUserInfoXMLFail);

        fileLoader.loadXML(url);
    }

    private function userInfoClear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        clearStaticInfo();


    }

    private function assignUserInfoEvents():void {

        if (this.currentState == "StaticInfo") {

            editUserInfoBtn.addEventListener(MouseEvent.CLICK, infoBtn_clickHandler);
        }
        if (this.currentState == "EditInfo") {
            saveUserInfoBtn.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);
            saveUserInfoBtn.addEventListener(MouseEvent.CLICK, saveUserInfoBtn_clickHandler);
        }

    }

    private function clearEditUserInfo():void {

        userNameLabel0.text = "";
        userIdLabel0.text = "";
        userPassLabel0.text = "";
        userEmailLabel0.text = "";
        states1.selectedIndex = -1
        userTypeLabel0.text = "";

        nameTxtLabel0.text = "";
        addressTxtLabel0.text = "";
        states2.selectedIndex = -1;
        zipocodeTxtLabel0.text = "";
        phoneTxtLabel0.text = "";

        name1.text = "";
        address1.text = "";
        states3.selectedIndex = -1;
        zipcode1.text = "";
        phone1.text = "";


        cc1.selectedIndex = -1;
        ccNumTxtLabel0.text = "";
        mmCC.text = "";
        yyCC.text = "";
        slashTxt.text = "";
        cscTxtLabel0.text = "";

    }

    private function mmText_clear():void {

        mmCC.text = "";

    }

    private function yyText_clear():void {

        yyCC.text = "";

    }

    private function loadUserData(node:XML, node2:XML):void {

        _userXML = node;
        _userDBXML = node2;

        if (_userXML.userXML == "") {
            _userXML.userXML = "userInfo.xml";
        }

        this.currentState = "StaticInfo";
        clearStaticInfo();
        userInfoDisplay();
    }

    private function userUpdateDisplay():void {
        var node:XML = new XML;
        var i:int;

        creditCardType();
        cc1.dataProvider = xc2.list;

        userNameLabel0.text = _userXML.userName;
        userIdLabel0.text = _userXML.userId;
        userPassLabel0.text = _userXML.userPass;
        userEmailLabel0.text = _userXML.userEmail;
        userTypeLabel0.text = _userXML.userType;


        nameTxtLabel0.text = _userFileXML.Personal.name;
        addressTxtLabel0.text = _userFileXML.Personal.address;
        zipocodeTxtLabel0.text = _userFileXML.Personal.zipcode;
        phoneTxtLabel0.text = _userFileXML.Personal.phone;

        name1.text = _userFileXML.Business.name;
        address1.text = _userFileXML.Business.address;
        zipcode1.text = _userFileXML.Business.zipcode;
        phone1.text = _userFileXML.Business.phone;


        if (_userXML.userType == "Admin" || _userXML.userType == "Satellite") {
            CreditCardBox2.visible = true;
            return;
        }

        if (_userFileXML.Personal.CC.@type != "")
            node = _userFileXML.Personal.CC;
        else if (_userFileXML.Business.CC.@type != "")
            node = _userFileXML.Business.CC;
        else
            return;

        cc1.selectedIndex = valueTabSearch(cc1, node.type);
        ccNumTxtLabel0.text = node.number;
        mmCC.text = node.expMonth;
        yyCC.text = node.expUear;
        cscTxtLabel0.text = node.csc;


    }

    private function saveUserInfo():void {
        var node:XML = new XML;
        var i:int;

        var state:String = "";

        _userXML.userName = userNameLabel0.text;
        _userXML.userPass = userPassLabel0.text;
        _userXML.userState = states1.selectedItem;

        _userFileXML.userId = _userXML.userId;
        _userFileXML.userEmail = _userXML.userEmail;
        _userFileXML.userPath = _userXML.userPath;
        _userFileXML.userXML = _userXML.userXML;
        _userFileXML.userState = _userXML.userState;


        _userFileXML.Personal.name = nameTxtLabel0.text;
        _userFileXML.Personal.address = addressTxtLabel0.text;

        if (states2.selectedIndex != -1)
            state = states2.selectedItem;
        else
            state = "";
        _userFileXML.Personal.state = state;
        _userFileXML.Personal.zipcode = zipocodeTxtLabel0.text;
        _userFileXML.Personal.phone = phoneTxtLabel0.text;

        _userFileXML.Business.name = name1.text;
        _userFileXML.Business.address = address1.text;

        if (states3.selectedIndex != -1)
            state = states3.selectedItem;
        else
            state = "";

        _userFileXML.Business.state = state;
        _userFileXML.Business.zipcode = zipcode1.text;
        _userFileXML.Business.phone = phone1.text;


        if (_userXML.userType == "Admin" || _userXML.userType == "Satellite") {
            saveXMLFile(_userFileXML);
            return;
        }

        if (_userFileXML.Personal.CC.@type != "")
            node = _userFileXML.Personal.CC;
        else if (_userFileXML.Business.CC.@type != "")
            node = _userFileXML.Business.CC;

        //cc1.selectedIndex =  valueTabSearch(cc1, node.type);
        node.number = ccNumTxtLabel0.text;
        node.expMonth = mmCC.text;
        node.expUear = yyCC.text;
        node.csc = cscTxtLabel0.text;


        saveXMLFile(_userFileXML);
    }

    private function userInfoValidate():Boolean {
        var pass:Boolean = true;

        return pass;

    }

    private function creditCardType():void {
        var customSizeList:XML;

        customSizeList = <creditCards>
            <cc data="Visa" label="Visa">Visa</cc>
            <cc data="MasterCard" label="MasterCard">MasterCard</cc>
            <cc data="Discover" label="Discover">Discover</cc>
            <cc data="American Express" label="American Express">American Express</cc>
        </creditCards>;

        var xl:XMLList = XMLList(customSizeList.children());
        xc2 = new XMLListCollection(xl);


    }

    private function verifyloadUserInfoXMLValid():void {

        userInfoDisplay();

    }

    private function saveXMLFile(xml:XML):void {
        var obj:Object = new Object();
        var url:String;

        var fileName:String;

        url = "saveXML.php";

        var s:String = "<?xml version=" + '"' + "1.0" + '"' + " encoding=" + '"' + "UTF-8" + '"' + "?>\n";

        var FileSend:String;
        FileSend = s + xml.toXMLString();

        fileName = xml.userXML.toString();

        if (fileName == "" || fileName == null) {
            fileName = "userInfo.xml";
            userXML.userXML = fileName;
        }

        obj.fileXML = FileSend;
        obj.fileName = fileName;
        obj.path = xml.userPath.toString();

        xmlFileLoader = fileLoader.xmlFileLoader;

        xmlFileLoader.addEventListener(ResultEvent.RESULT, saveXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, saveXMLFail);

        fileLoader.loadXML(url, obj);
    }

    private function updateUserDBXML():void {


        updateUserInfo(userXML);


    }

    private function updateUserInfo(node:XML):void {

        var obj:Object = new Object();


        obj.username = node.userName;
        obj.password = node.userPass;
        obj.userType = "";
        obj.userEmail = "";
        obj.userStatus = "";
        obj.userPath = "";
        obj.userState = "";
        obj.userXML = node.userXML;
        obj.userCreator = "";
        obj.userCreatorID = "";


        obj.searchVar = node.userId;
        obj.table1 = "users";

        updateUserDatabase(obj);

    }

    private function updateUserDatabase(obj:Object):void {

        var url:String;
        url = "updateUser.php";

        xmlFileLoader = fileLoader.xmlFileLoader;
        xmlFileLoader.addEventListener(ResultEvent.RESULT, updateUserInfoVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, loadUserInfoXMLFail);

        fileLoader.loadXML(url, obj);


    }

    private function loadStatesXML():void {

        var url:String = "UsStates.xml";

        xmlStatesLoader = stateFileLoader.xmlFileLoader;

        xmlStatesLoader.addEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        xmlStatesLoader.addEventListener(FaultEvent.FAULT, loadStatesXMLFail);

        stateFileLoader.loadXML(url);


    }

    private function loadStates():void {

        var productAttributes:XMLList = usStatesXML.state.attribute("label");
        var xl:XMLList = XMLList(productAttributes);
        xc = new XMLListCollection(xl);

        assignStates();

    }

    private function assignStates():void {
        states1.dataProvider = xc.list;
        states2.dataProvider = xc.list;
        states3.dataProvider = xc.list;

        states1.selectedIndex = valueTabSearch(states1, userXML.userState);
        states2.selectedIndex = valueTabSearch(states1, userXML.userState);
        states2.selectedIndex = valueTabSearch(states1, userXML.userState);
    }

    private function valueTabSearch(list:DropDownList, searchVar:String):int {
        var x:int = 0;
        var obj:Object = list.dataProvider;
        var xl:XMLList = obj.source as XMLList;
        var s:String;

        for (x = 0; x < xl.length(); x++) {
            s = xl[x].toString();

            if (s == searchVar)
                return x;

        }

        return (-1);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function adminUserInfoCom_creationCompleteHandler(event:FlexEvent):void {
        userInfoClear();
        assignUserInfoEvents();
        this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, adminUserInfoComState);

    }

    private function saveUserInfoBtn_clickHandler(event:MouseEvent):void {
        saveUserInfo();
    }

    private function adminUserInfoComState(event:StateChangeEvent):void {

        if (this.currentState == "StaticInfo") {

            editUserInfoBtn.addEventListener(MouseEvent.CLICK, infoBtn_clickHandler);

        }
        if (this.currentState == "EditInfo") {
            loadStatesXML();

            saveUserInfoBtn.addEventListener(MouseEvent.CLICK, saveUserInfoBtn_clickHandler);
            updateInfoPanel.addEventListener(CloseEvent.CLOSE, titlewindow1_closeHandler);
            mmCC.addEventListener(MouseEvent.CLICK, mmText_clear);
            yyCC.addEventListener(MouseEvent.CLICK, yyText_clear);
        }

    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function infoBtn_clickHandler(event:MouseEvent):void {
        if (this.currentState == "StaticInfo") {
            this.currentState = "EditInfo";
            clearEditUserInfo();
            userUpdateDisplay();

        }
        else if (this.currentState == "EditInfo") {
            this.currentState = "StaticInfo";
            assignUserInfoEvents();
            clearStaticInfo();
            userInfoDisplay();
        }
    }

    private function titlewindow1_closeHandler(event:CloseEvent):void {
        this.currentState = "StaticInfo";
        clearStaticInfo();
        loadUserInfoXML();
    }

    private function loadUserInfoXMLVerify(event:Event):void {


        _userFileXML = XML(xmlFileLoader.lastResult);

        verifyloadUserInfoXMLValid();

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, loadUserInfoXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, loadUserInfoXMLFail);

    }

    private function loadUserInfoXMLFail(event:Event):void {


        userXML.userXML = "";

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function saveXMLFail(event:Event):void {

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, saveXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, saveXMLFail);

    }

    private function saveXMLVerify(event:Event):void {
        var url:String;
        var obj:Object;
        obj = new Object();

        var responseXML:XML = XML(xmlFileLoader.lastResult);

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, saveXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, saveXMLFail);

        var response:String = responseXML.toString();


        this.currentState = "StaticInfo";

        updateUserDBXML();


    }

    private function updateUserInfoVerify(event:Event):void {

        var responseXML:XML = XML(xmlFileLoader.lastResult);
        xmlFileLoader.removeEventListener(ResultEvent.RESULT, updateUserInfoVerify);
        xmlFileLoader.removeEventListener(ResultEvent.RESULT, updateUserInfoFail);

        var response:String = responseXML.toString();


        if (response == "error") {

            //userEditError.text = "Error Updating Field";


        }
        else if (response == "ok") {

            loadUserInfoXML();

        }

    }

    private function updateUserInfoFail(event:Event):void {


    }

    private function loadStatesXMLFail(event:Event):void {

        var obj:Object = new Object();

        obj = xmlStatesLoader.lastResult;

        xmlStatesLoader.removeEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        xmlStatesLoader.removeEventListener(FaultEvent.FAULT, loadStatesXMLFail);

    }

    private function loadStatesXMLVerify(event:Event):void {


        usStatesXML = new XML();
        var s:String
        usStatesXML = XML(xmlStatesLoader.lastResult);

        xmlStatesLoader.removeEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        xmlStatesLoader.removeEventListener(FaultEvent.FAULT, loadStatesXMLFail);

        loadStates();
    }


}
}