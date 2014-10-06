package components {
import auctionFunctionsClass.fileLoaderClass;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.events.IndexChangeEvent;

public class userAdd extends userAddLayout {
    public function userAdd() {
        super();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, userAdd_creationCompleteHandler);
    }

    private var userXML:XML = new XML();
    private var userTypeXML:XML = new XML();
    private var userStatusXML:XML = new XML();
    private var usStatesXML:XML = new XML();
    private var _createUserID:String = new String();
    private var _createUserEmail:String = new String();
    private var _createUserPass:String = new String();
    private var _loginUserType:String = new String();
    private var _loginUserID:String = new String();
    private var xc:XMLListCollection = new XMLListCollection;
    private var xc2:XMLListCollection = new XMLListCollection;
    private var xc3:XMLListCollection = new XMLListCollection;
    private var xmlStatesLoader:HTTPService = new HTTPService();
    private var stateFileLoader:fileLoaderClass = new fileLoaderClass();
    private var xmlFileLoader:HTTPService = new HTTPService();
    private var fileLoader:fileLoaderClass = new fileLoaderClass();

    public function clear():void {

        UserAddClear();
    }

    public function assignUserAddEvents():void {

        if (this.currentState == "createUser") {
            CreateUserBtn.addEventListener(MouseEvent.CLICK, page3AdminClickFunction);
        }
        if (this.currentState == "registeredUser") {
            goToCreateUserBtn.addEventListener(MouseEvent.CLICK, page3AdminClickFunction);
        }


    }

    public function clearUserAdminCreateTab():void {

        this.currentState = "createUser";

        userType.enabled = true;

        nameUser.text = "";
        nameUser.errorString = "";
        nameUser.enabled = false;
        emailUser.text = "";
        emailUser.enabled = false;
        emailUser.errorString = "";

        statusUser.enabled = false;
        houseIDstates.enabled = false;

        emailUserCreate.selected = true;
        emailUserCreate.enabled = false;
        CreateUserBtn.enabled = false;

        houseIDstates.dataProvider = xc.list;
        houseIDstates.selectedIndex = -1;

        userType.dataProvider = xc2.list;
        userType.selectedIndex = -1;

        statusUser.dataProvider = xc3.list;
        statusUser.selectedIndex = -1;

        createUserAdminPanelError.text = "Create a User Fill Available fields";


    }

    public function clearUserAdminVerifyTab():void {

        userName.text = "";
        userId.text = "";
        userPass.text = "";


    }

    public function displayCreatedUser(id:String, email:String, pass:String):void {

        this.currentState = "registeredUser";

        userName.text = id;
        userId.text = email;
        userPass.text = pass;

    }

    public function loadUserData(node:XML):void {
        this.currentState = "createUser";
        _loginUserType = node.userType;
        _loginUserID = node.userId;


        loadUserListsXML();
        loadStatusTypeList();

    }

    public function userCreateValidate():Boolean {

        var pass:Boolean = false;

        pass = true;

        return (pass);
    }

    public function saveUser():Object {
        var obj:Object = new Object;

        var s:String = userType.selectedItem.toString();

        obj = clearRegisterObj(obj);

        if (s != "House") {
            obj.username = nameUser.text;
            obj.userEmail = emailUser.text;
            obj.password = createRandomPassword();
            obj.activeCode = createRandomPassword();

            obj.userState = houseIDstates.selectedItem.toString();
            obj.userType = userType.selectedItem.toString();
            obj.userStatus = statusUser.selectedItem.toString();
            ;
            obj.userCreator = _loginUserType;
            obj.userCreatorID = _loginUserID;
            obj.userRegister = "Register";

        }
        else {
            obj.username = "House";
            obj.userEmail = "House";
            obj.password = "***********";
            obj.userState = houseIDstates.selectedItem.toString();
            obj.userType = userType.selectedItem.toString();
            obj.userStatus = "Active";
            obj.userCreator = "House";
            obj.userCreatorID = _loginUserID;
            obj.userRegister = "Register";
        }

        return obj;

    }

    public function userRegister(obj:Object):void {

        var url:String;
        url = "register.php";

        xmlFileLoader = new HTTPService();

        xmlFileLoader = fileLoader.xmlFileLoader;
        xmlFileLoader.addEventListener(ResultEvent.RESULT, userRegisterVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, userRegisterFail);

        fileLoader.loadXML(url, obj);
    }

    public function userRegistered():void {


        displayCreatedUser(_createUserID, _createUserEmail, _createUserPass);


    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public function userNotRegistered():void {


        emailUser.errorString = "Email Already Exists";

    }

    protected function UserAddClear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        if (this.currentState == "createUser") {
            _createUserID = "";
            _createUserEmail = "";
            _createUserPass = "";

            clearUserAdminCreateTab();
        }
        else if (this.currentState == "registeredUser") {

            clearUserAdminVerifyTab();

        }
    }

    private function loadStatesXML():void {

        var url:String = "UsStates.xml";
        ;

        xmlStatesLoader = stateFileLoader.xmlFileLoader;

        xmlStatesLoader.addEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        xmlStatesLoader.addEventListener(FaultEvent.FAULT, loadStatesXMLFail);

        stateFileLoader.loadXML(url);


    }

    private function loadStates():void {

        var productAttributes:XMLList = usStatesXML.state.attribute("label");
        var xl:XMLList = XMLList(productAttributes);
        xc = new XMLListCollection(xl);

        houseIDstates.dataProvider = xc.list;

    }

    private function loadUserListsXML():void {
        if (_loginUserType == "Admin") {
            userTypeXML = <userType>
                <uu>Admin</uu>
                <uu>Satellite</uu>
                <uu>Bidder</uu>
                <uu>House</uu>
            </userType>;
        }
        else if (_loginUserType == "Satellite") {

            userTypeXML = <userType>
                <uu>Bidder</uu>
                <uu>House</uu>
            </userType>;
        }

        var productAttributes:XMLList = userTypeXML.uu.children();
        var xl:XMLList = XMLList(productAttributes);
        xc2 = new XMLListCollection(xl);


    }

    private function loadStatusTypeList():void {


        userStatusXML = <userType>
            <uu>Active</uu>
            <uu>Inactive</uu>
            <uu>Pending</uu>
            <uu>Blocked</uu>
        </userType>;

        var productAttributes:XMLList = userStatusXML.uu.children();
        var xl:XMLList = XMLList(productAttributes);
        xc3 = new XMLListCollection(xl);


    }

    private function createRandomPassword():String {

        var time:Date = new Date();
        var day:uint = time.getDay();
        var mill:uint = time.getMilliseconds();
        var seconds:uint = time.getSeconds();
        var minutes:uint = time.getMinutes();
        var hours:uint = time.getHours();
        var dd:Number = time.getDate();
        var mm:Number = time.getMonth();
        var yyyy:Number = time.getFullYear();
        time.setFullYear(yyyy, mm, dd);
        var fullDate:String = time.toDateString();

        var randomPass:String = "PSWD" + mill + seconds + minutes + day + hours;

        return(randomPass);

    }

    private function randomRange(max:Number, min:Number = 0):Number {
        return Math.random() * (max - min) + min;
    }

    private function clearRegisterObj(obj:Object):Object {
        obj.username = "";
        obj.password = "";
        obj.userEmail = "";
        obj.userState = "";
        obj.activeCode = "";

        obj.userRegister = "";

        obj.userType = "";
        obj.userStatus = "";
        obj.userCreator = "";
        obj.userCreatorID = "";

        obj.userFullName = "";
        obj.userAddress = "";
        obj.userZipcode = "";
        obj.userPhone = "";
        obj.userCell = "";
        obj.cc1 = "";
        obj.ccNum = "";
        obj.mmcc = "";
        obj.yycc = "";
        obj.csc = "";
        return obj;
    }

    public function userAdd_creationCompleteHandler(event:FlexEvent):void {

        assignUserAddEvents();
        this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, addUserComState);
        userType.addEventListener(IndexChangeEvent.CHANGE, adminTabchange_changeHandler);
        UserAddClear();

        loadStatesXML();
    }

    public function addUserComState(event:StateChangeEvent):void {

        assignUserAddEvents();
        UserAddClear();

    }

    public function page3AdminClickFunction(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;


        if (name == "CreateUserBtn") {
            pass = userCreateValidate();
            if (pass == true) {
                var obj:Object = new Object;

                obj = saveUser();


                _createUserID = "";
                _createUserEmail = obj.userEmail;
                _createUserPass = obj.password;

                userRegister(obj);

            }
        }

        if (name == "goToCreateUserBtn") {
            this.currentState = "createUser";
            UserAddClear();

        }


    }

    public function userRegisterVerify(event:Event):void {

        var obj:Object;
        obj = new Object();

        var responseXML:XML = XML(xmlFileLoader.lastResult);
        xmlFileLoader.addEventListener(ResultEvent.RESULT, userRegisterVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, userRegisterFail);


        var response:String = responseXML.toString();

        if (response == "ok") {
            obj = responseXML;
            _createUserID = obj.@id;
            userRegistered();
        }
        if (response == "error") {
            userNotRegistered();
        }


    }

    public function userRegisterFail(event:Event):void {


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

    private function adminTabchange_changeHandler(event:IndexChangeEvent):void {
        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.selectedItem;


        if (name == "Admin") {
            nameUser.enabled = true;
            emailUser.enabled = true;
            statusUser.enabled = true;
            adminPanelUserId.enabled = false;
            houseIDstates.enabled = true;
            emailUserCreate.enabled = true;

            CreateUserBtn.enabled = true;
        }
        else if (name == "Satellite") {


            nameUser.enabled = true;
            emailUser.enabled = true;
            statusUser.enabled = true;
            adminPanelUserId.enabled = false;
            houseIDstates.enabled = true;
            emailUserCreate.enabled = true;

            CreateUserBtn.enabled = true;


        }
        else if (name == "Seller") {
            nameUser.enabled = false;
            emailUser.enabled = false;
            statusUser.enabled = false;
            adminPanelUserId.enabled = false;
            houseIDstates.enabled = false;
            emailUserCreate.enabled = false;
            emailUserCreate.enabled = false;

            CreateUserBtn.enabled = false;


        }
        else if (name == "Bidder") {
            nameUser.enabled = true;
            emailUser.enabled = true;
            statusUser.enabled = true;
            adminPanelUserId.enabled = false;
            houseIDstates.enabled = true;
            emailUserCreate.enabled = true;

            CreateUserBtn.enabled = true;


        }
        else if (name == "House") {

            nameUser.enabled = false;
            emailUser.enabled = false;
            statusUser.enabled = false;
            adminPanelUserId.enabled = false;
            houseIDstates.enabled = true;
            houseIDstates.selectedIndex = randomRange(49);
            emailUserCreate.enabled = false;
            emailUserCreate.selected = false;

            CreateUserBtn.enabled = true;

        }
    }
}
}