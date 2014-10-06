package components {
import auctionFunctionsClass.fileLoaderClass;
import auctionFunctionsClass.userClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.validators.EmailValidator;
import mx.validators.StringValidator;

import spark.events.IndexChangeEvent;
import spark.events.TextOperationEvent;
import spark.validators.NumberValidator;

public class logInComponentDisplay extends logInComponentLayout {
    public function logInComponentDisplay() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, logInCom_creationCompleteHandler);
    }

    public var xmlFileLoader:HTTPService = new HTTPService();
    public var fileLoader:fileLoaderClass = new fileLoaderClass();
    private var _saveFile:Boolean = false;
    private var _randomCode:String;
    private var usStatesXML:XML = new XML();
    private var userLogIn:userClass = new userClass();
    private var xmlStatesLoader:HTTPService = new HTTPService();
    private var stateFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _loggedIn:Boolean;

    private var _loginUserXML:XML = new XML();

    private var xmlRegisterLoader:HTTPService = new HTTPService();
    private var registerFileLoader:fileLoaderClass = new fileLoaderClass();

    private var xc:XMLListCollection = new XMLListCollection;

    private var emailxmlFileLoader:HTTPService = new HTTPService();
    public var emailfileLoader:fileLoaderClass = new fileLoaderClass();


    public function get loggedIn():Boolean {
        return _loggedIn;
    }

    public function set loggedIn(value:Boolean):void {
        _loggedIn = value;
    }

    private var _loginUserID:String;

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _loginUserEmail:String

    public function get loginUserEmail():String {
        return _loginUserEmail;
    }

    public function set loginUserEmail(value:String):void {
        _loginUserEmail = value;
    }

    private var _loginUserPass:String;

    public function get loginUserPass():String {
        return _loginUserPass;
    }

    public function set loginUserPass(value:String):void {
        _loginUserPass = value;
    }

    private var _loginUserType:String;

    public function get loginUserType():String {
        return _loginUserType;
    }

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    private var _loginUserStatus:String;

    public function get loginUserStatus():String {
        return _loginUserStatus;
    }

    private var _loginUserState:String;

    public function get loginUserState():String {
        return _loginUserState;
    }

    private var _userFileXML:XML;

    public function get userFileXML():XML {
        return _userFileXML;
    }

    public function set userFileXML(value:XML):void {
        _userFileXML = value;
    }

    private var _userDBXML:XML;

    public function get userDBXML():XML {
        return _userDBXML;
    }

    public function clear():void {
        addLogInEvents();
        clearLogInTab();
    }
    private function clearLoginPage():void{

        userLogInID.text = "";
        userLogInID.errorString ="";
        userLogInPassword.text = "";
        userLogInPassword.errorString ="";
        userLogInID.restrict="a-z,0-9,@,_,\-,.";

        errorSignIn.text = "Please enter your info";

        if( _loggedIn == false)
            this.currentState = "Login";
        else if( _loggedIn == true && _loginUserStatus == "Active")
            this.currentState = "Logout";
        else if( _loggedIn == true && _loginUserStatus == "Inactive")
            this.currentState = "activateAccount";

    }
    private function clearRegisterPage():void{

        emailVerify.text = "";
        emailVerify.errorString ="";
        regPass1.text = "";
        regPass1.errorString ="";
        regPass2.text = "";
        regPass2.errorString ="";
        regState.errorString ="";
        regState.enabled = false;
        regState.selectedIndex = -1;
        RegistrationBtn.enabled = false;

        errorRegister.text = "Please Add Your Email and Desired Password" + '\n' + "Password Characters Restricted to: a-z, A-Z, ! , . , * ";

    }
    private function clearLogOutPage():void{


    }

    private function clearLogInViewDisplay():void
    {
        _loggedIn = false;
        _loginUserID = "";
        _loginUserEmail = "";
        _loginUserPass ="";
        _loginUserType = "";
        _loginUserStatus = "";

        _loginUserXML = new XML();

        usStatesXML = new XML();

        setUpValidators();

        this.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, logInCom_creationCompleteHandler);

    }
    private function clearLogInTab():void {

        userLogInID.text = "";
        userLogInID.errorString = "";
        userLogInPassword.text = "";
        userLogInPassword.errorString = "";
        userLogInID.restrict = "a-z,0-9,@,_,\-,.";

        errorSignIn.text = "Please enter your info";

        if (_loggedIn == false)
            this.currentState = "Login";
        else if (_loggedIn == true && _loginUserStatus == "Active")
            this.currentState = "Logout";
        else if (_loggedIn == true && _loginUserStatus == "Inactive")
            this.currentState = "activateAccount";
    }

    private function clearActivateAccountPage():void
    {
        creditCardType();

        nameTxtLabel0.text = "";
        addressTxtLabel0.text = "";
        zipocodeTxtLabel0.text = "";
        phoneTxtLabel0.text = "";
        cellphoneTxt.text = "";
        cc1.selectedIndex = -1;
        ccNumTxtLabel0.text="";
        mmCC.text = "";
        yyCC.text = "";
        cscTxtLabel0.text = "";

        cc1.dataProvider = xc.list;

        activationCodeTxt.text = "";

        errorCode.text = "";


        tosCheck.selected = false;
    }
    private function verifyLogInUser():void {
        var userID:String;
        var userEmail:String;

        userID = _userDBXML.userId;
        userEmail = _userDBXML.userEmail;
        _loginUserID = userLogIn.loginUserID;
        _loginUserEmail = userLogIn.loginUserEmail;
        _loginUserType = _userDBXML.userType;
        _loginUserStatus = _userDBXML.userStatus;
        _loginUserPass = _userDBXML.password;

        if (userID == _loginUserID) {

            userLogInDisplay();
        }
        else if (userEmail == _loginUserEmail) {
            userLogInDisplay();
        }

        else {
            _loggedIn = false;
        }

    }

    private function userLogInDisplay():void {

        if (_loginUserStatus == "Active") {
            _loggedIn = true;
            this.currentState = "Logout";
        }
        else if (_loginUserStatus == "Inactive") {
            _loggedIn = false;
            this.currentState = "activateAccount";
            addLogInEvents();
        }
        else {
            _loggedIn = false;
            errorSignIn.text = "Error, Incorrect Username Password"
        }

        userLoginFileLoad();

    }

    private function addLogInEvents():void {

        if (this.currentState == "Login") {

            goToRegisterIn.addEventListener(MouseEvent.CLICK, buttonClickFunction);
            userLogInPassword.addEventListener(KeyboardEvent.KEY_DOWN, userEnterUpdate);
            logInBtn.addEventListener(MouseEvent.CLICK, userLogInSend);
            clearLoginPage();

        }
        else if (this.currentState == "Register") {

            setUpValidators();
            RegistrationBtn.addEventListener(MouseEvent.CLICK, userRegistration);
            goToLogIn.addEventListener(MouseEvent.CLICK, buttonClickFunction);
            regPass1.addEventListener(TextOperationEvent.CHANGE, checkPasswordsMatch);
            regPass2.addEventListener(TextOperationEvent.CHANGE, checkPasswordsMatch);
            regState.addEventListener(IndexChangeEvent.CHANGE, regState_changeHandler);
            clearRegisterPage();
        }
        else if (this.currentState == "Logout") {

            logOutBtn.addEventListener(MouseEvent.CLICK, buttonClickFunction);
            accountInfoBtn.addEventListener(MouseEvent.CLICK, buttonClickFunction);

        }

        else if (this.currentState == "activateAccount") {
            resendEmailBtn.addEventListener(MouseEvent.CLICK, activateEmailResend_handler)
            activateAccountBtn.addEventListener(MouseEvent.CLICK, activateUserAccount);
            tosCheck.addEventListener(MouseEvent.CLICK, tosCheck_handler);
            clearActivateAccountPage();
        }

    }

    private function loadStatesXML():void {

        var url:String = "UsStates.xml";

        xmlStatesLoader = stateFileLoader.xmlFileLoader;

        xmlStatesLoader.addEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        xmlStatesLoader.addEventListener(FaultEvent.FAULT, loadStatesXMLFail);

        stateFileLoader.loadXML(url);


    }

    private function loadStates(xml:XML):void {

        var productAttributes:XMLList = xml.state.attribute("label");
        var xl:XMLList = XMLList(productAttributes);
        var xc:XMLListCollection = new XMLListCollection(xl);

        regState.dataProvider = xc.list;
        regState.selectedIndex = -1;
        regState.validateDisplayList();
        regState.validateNow();
    }

    private function activateUserAccount(event:MouseEvent):void
    {	var pass:Boolean = false;
        var obj:Object = new Object();

        obj = clearRegisterObj(obj);

        pass = activateValidation();

        if(pass == false)
            return;

        errorCode.text = "";

        obj.username = _loginUserID ;
        obj.password = "";
        obj.userEmail = "";
        obj.userState = "";
        obj.activeCode = activationCodeTxt.text;

        obj.userRegister = "Verify";

        obj.userType = "";
        obj.userStatus = "";
        obj.userCreator = "";
        obj.userCreatorID = "";


        obj.userFullName = nameTxtLabel0.text;
        obj.userAddress = addressTxtLabel0.text;
        obj.userZipcode = zipocodeTxtLabel0.text;
        obj.userPhone = phoneTxtLabel0.text;
        obj.userCell = cellphoneTxt.text;
        obj.cc1 = cc1.selectedItem;
        obj.ccNum = ccNumTxtLabel0.text;
        obj.mmcc = mmCC.text;
        obj.yycc = yyCC.text;
        obj.csc = cscTxtLabel0.text;




        userActivate(obj);

    }

    private function activateValidation():Boolean{

        var pass:Boolean=true;

        nameTxtLabel0.errorString ="";
        addressTxtLabel0.errorString ="";
        zipocodeTxtLabel0.errorString ="";
        phoneTxtLabel0.errorString ="";
        cellphoneTxt.errorString  =""

        ccNumTxtLabel0.errorString ="";
        mmCC.errorString = "";
        yyCC.errorString = "";
        cscTxtLabel0.errorString ="";
        activationCodeTxt.errorString ="";

        cc1.errorString = "";

        //errorRegister.text = "Please Add Your Email and Desired Password" + '\n' + "Password Characters Restricted to: a-z, A-Z, ! , . , * ";

        if(nameTxtLabel0.text =="")
        {
            nameTxtLabel0.errorString="Required";
            pass = false;
        }

        if(addressTxtLabel0.text =="")
        {
            addressTxtLabel0.errorString="Required";
            pass = false;
        }

        if(zipocodeTxtLabel0.text =="")
        {
            zipocodeTxtLabel0.errorString="Required";
            pass = false;
        }

        if(phoneTxtLabel0.text ==""&& cellphoneTxt.text =="" )
        {
            phoneTxtLabel0.errorString="One Number Required";
            cellphoneTxt.errorString = "One Number Required";
            pass = false;
        }


        if(ccNumTxtLabel0.text =="")
        {
            ccNumTxtLabel0.errorString="Required";
            pass = false;
        }

        if(mmCC.text =="")
        {
            mmCC.errorString="Required";
            pass = false;
        }

        if(yyCC.text =="")
        {
            yyCC.errorString="Required";
            pass = false;
        }


        if(cscTxtLabel0.text =="")
        {
            cscTxtLabel0.errorString="Required";
            pass = false;
        }

        if(activationCodeTxt.text =="")
        {
            activationCodeTxt.errorString="Required";
            pass = false;
        }

        if(cc1.selectedIndex == -1)
        {cc1.errorString="Required";
            pass = false;
        }

        return pass;
    }

    private  function logOutValidation():Boolean{


        return true;
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function userActivate(obj:Object):void{


        var url:String = "register.php";

        xmlRegisterLoader =  registerFileLoader.xmlFileLoader;

        xmlRegisterLoader.addEventListener(ResultEvent.RESULT, userActivateVerify);
        xmlRegisterLoader.addEventListener(FaultEvent.FAULT, userActivateFail);

        registerFileLoader.loadXML(url, obj);

    }


    private function userActivateVerify(event:Event):void{

        var obj:Object;
        obj = new Object();


        var responseXML:XML = XML(xmlRegisterLoader.lastResult);
        xmlRegisterLoader.removeEventListener(ResultEvent.RESULT, userActivateVerify);
        xmlRegisterLoader.removeEventListener(ResultEvent.RESULT, userActivateFail);

        var response:String = responseXML.toString();

        if(response == "ok")
        {
            _saveFile = true;
            userActivateAccountLogIn();
            this.currentState = "Logout";
            errorCode.text = "";
        }
        if(response == "error")
        {
            this.currentState = "activateAccount";
            errorCode.text = "Activation Code Failed";
            addLogInEvents();
        }
    }

    private function userActivateAccountLogIn():void
    {   userLogIn.loginString = _loginUserID;
        userLogIn.loginUserPass = _loginUserPass;

        userLogIn.logInUser();

        userLogIn.addEventListener(ResultEvent.RESULT, userLogInVerify);
        userLogIn.addEventListener(FaultEvent.FAULT, userLogInFail);

    }

    private function userActivateFail(event:Event):void{

        	var obj:Object = event;

    }


    private function userRegistered():void {
        sendEmailPHP();
        this.currentState = "activateAccount";
        addLogInEvents();

    }

    private function userNotRegistered():void {

        errorRegister.text = "Email Already Exists";
        errorCode.text = "Activation Code Failed";


    }

    private function regState_changeHandler(event:IndexChangeEvent):void {
        if (regState.selectedIndex != -1)
            regState.errorString = "";
    }

    private function logInCom_creationCompleteHandler(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, logInCom_creationCompleteHandler);
        this.dispatchEvent(event);
    }

    private function userLogInSend(event:Event):void {

        userLogIn.loginString = userLogInID.text.toString();
        userLogIn.loginUserPass = userLogInPassword.text.toString();

        userLogIn.logInUser();

        userLogIn.addEventListener(ResultEvent.RESULT, userLogInVerify);
        userLogIn.addEventListener(FaultEvent.FAULT, userLogInFail);

    }

    private function userLogInVerify(event:ResultEvent):void {
        var obj:Object;

        obj = XML(event.result);

        _userDBXML = obj as XML;

        verifyLogInUser();
    }

    private function userLogInFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);
    }

    private function userEnterUpdate(event:KeyboardEvent):void {
        event.keyCode;
        var test:int;
    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }

    private function buttonClickFunction(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;

        if (name == "goToLogIn") {

            this.currentState = "Login";
            addLogInEvents();
        }
        if (name == "goToRegisterIn") {
            this.currentState = "Register";
            addLogInEvents();
        }

        if (name == "logOutBtn") {
            bubbleMouseEvent(event);
        }
        if (name == "accountInfoBtn") {
            bubbleMouseEvent(event);
        }


    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function checkPasswordsMatch(event:TextOperationEvent):void {
        if (regPass1.text.length > 6)
            regPass1.errorString = "";
        if (regPass2.text.length > 6)
            regPass2.errorString = "";


        if (regPass1.text == "" || regPass2.text == "") {
            regState.selectedIndex = -1
            regState.enabled = false;
            RegistrationBtn.enabled = false;
            return;

        }


        if (regPass1.text == regPass2.text) {
            RegistrationBtn.enabled = true;
            regState.enabled = true;

            loadStatesXML();
        }

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

        loadStates(usStatesXML);
    }

    private function userRegistration(event:Event):void {


        var pass:Boolean = false;

        pass = registerValidation();

        if (pass == false)
            return;

        createRandomPassword();


        var obj:Object = new Object();


        obj = clearRegisterObj(obj);

        _loginUserID = this.emailVerify.text;
        _loginUserEmail = this.emailVerify.text;
        _loginUserPass = this.regPass1.text;
        _loginUserState = this.regState.selectedItem;

        obj.username = _loginUserID;
        obj.password = _loginUserPass;
        obj.userEmail = _loginUserID;
        obj.userState = _loginUserState;
        obj.activeCode = _randomCode;

        obj.userRegister = "Register";

        obj.userType = "Bidder";
        obj.userStatus = "Inactive";
        obj.userCreator = "Online";
        obj.userCreatorID = "0000";

        userRegister(obj);
    }

    private function userRegister(obj:Object):void {


        var url:String = "register.php";

        xmlRegisterLoader = registerFileLoader.xmlFileLoader;

        xmlRegisterLoader.addEventListener(ResultEvent.RESULT, userRegisterVerify);
        xmlRegisterLoader.addEventListener(FaultEvent.FAULT, userRegisterFail);

        registerFileLoader.loadXML(url, obj);

    }

    private function userRegisterVerify(event:Event):void {

        var obj:Object;
        obj = new Object();


        var responseXML:XML = XML(xmlRegisterLoader.lastResult);
        xmlRegisterLoader.removeEventListener(ResultEvent.RESULT, userRegisterVerify);
        xmlRegisterLoader.removeEventListener(ResultEvent.RESULT, userRegisterFail);

        var response:String = responseXML.toString();

        if (response == "ok") {
            obj = responseXML;
            _loginUserID = obj.@id;
            userRegistered();
            userLoginFileLoad();
        }
        if (response == "error") {
            userNotRegistered();
        }
    }


    private function userRegisterFail(event:Event):void {

        //	var obj:Object = event;

    }

    private function userLoginFileLoad():void
    {
        if(_userDBXML == null)
            _userDBXML = new XML();

        var userFile:String = _userDBXML.userXML.toString();
        var url:String;

        if(userFile == "" && _saveFile == false)
        {
            url = "userInfo.xml";

            loadUserFileXML(url);
        }
        else if(userFile != "" && _saveFile == false){

            url = userFile;

            loadUserFileXML(url);
        }
        else if(userFile != "" && _saveFile == true)
        {
            syncronizeUserFile();
            saveXMLFile();
        }


    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function syncronizeUserFile():void
    {
        _userFileXML.userId = _loginUserID;
        _userFileXML.userEmail = _loginUserEmail;
        _userFileXML.userPath = _userDBXML.userPath;
        _userFileXML.userXML = _userDBXML.userXML;
        _userFileXML.userState = _loginUserState;


        _userFileXML.Personal.name = nameTxtLabel0.text;
        _userFileXML.Personal.address = addressTxtLabel0.text;

        _userFileXML.Personal.state = _loginUserState;
        _userFileXML.Personal.zipcode = zipocodeTxtLabel0.text;
        _userFileXML.Personal.phone = phoneTxtLabel0.text;
        _userFileXML.Personal.cellphone = cellphoneTxt.text;

        _userFileXML.Business.address = addressTxtLabel0.text;
        _userFileXML.Business.zipcode = zipocodeTxtLabel0.text;
        _userFileXML.Business.phone = phoneTxtLabel0.text;
        _userFileXML.Business.cellphone = cellphoneTxt.text;

        _userFileXML.Personal.CC.@number = ccNumTxtLabel0.text;
        _userFileXML.Personal.CC.@expMonth = mmCC.text;
        _userFileXML.Personal.CC.@expYear = yyCC.text;

    }




    public function saveXMLFile():void{
        var obj:Object = new Object();
        var url:String;

        url = "saveXML.php";

        var s:String = "<?xml version=" + '"' + "1.0" + '"' + " encoding=" + '"' +"UTF-8" + '"' +"?>\n";

        var FileSend:String;
        FileSend = s + _userFileXML.toXMLString();

        obj.fileXML = FileSend;
        obj.fileName = _userDBXML.userXML.toString();
        obj.path = _userDBXML.userPath.toString();


        xmlFileLoader =  fileLoader.xmlFileLoader;
        xmlFileLoader.addEventListener(ResultEvent.RESULT, saveXMLFileVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, saveXMLFileFail);
        fileLoader.loadXML(url, obj);

    }


    private function saveXMLFileVerify(event:Event):void{
        var obj:Object = new Object();

        var responseXML:XML = XML(xmlFileLoader.lastResult);
        var response:String = responseXML.toString();

        _saveFile = false;

        if(response == "ok")
        {obj = responseXML;}
        if(response == "error")
            return;

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, saveXMLFileVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT,  saveXMLFileFail);
    }

    private function saveXMLFileFail(event:Event):void{

        var obj:Object;

        _saveFile = false;

        obj =  XML(xmlFileLoader.lastResult);
        obj;

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, saveXMLFileVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT,  saveXMLFileFail);


    }

    private function saveXMLFileXMLValid():void{



    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////////////

    private function loadUserFileXML(_auctionURL:String):void
    {

        xmlFileLoader =  fileLoader.xmlFileLoader;

        xmlFileLoader.addEventListener(ResultEvent.RESULT, userXMLVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, userXMLFail);

        fileLoader.loadXML(_auctionURL);



    }


    private function userXMLFail(event:Event):void{

        var obj:Object;

        obj =  XML(xmlFileLoader.lastResult);
        obj;

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, userXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, userXMLFail);
    }

    private function userXMLVerify(event:Event):void{

        _userFileXML = new XML();
        _userFileXML = XML(xmlFileLoader.lastResult);

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, userXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, userXMLFail);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////
    public function sendEmailPHP():void{
        var url:String;

        url= "http://winning-bidder.com/Email.php";

        var fullComment:String = "Here is your username and password" + "\n" + "userID: " + _loginUserID + "\n" + "userEmail: " + _loginUserEmail + "\n" + "Password: " + _loginUserPass + "\n" + "Activation Code: " + _randomCode + "\n" + "http://winning-bidder.com" + "\n"  + "\n" + "*Note: Activation code and Credit Card required to Activate Account. When you register or log in fill out all fields. Call (952)688-6798 for any Issues." ;

        var obj:Object = new Object();
        obj.email = "mark@winning-bidder.com";
        obj.emailF = _loginUserEmail;
        obj.message = fullComment;
        obj.subject = "New Username and Password";


        emailxmlFileLoader =  emailfileLoader.xmlFileLoader;

        emailxmlFileLoader.addEventListener(ResultEvent.RESULT, sendEmailPHPVerify);
        emailxmlFileLoader.addEventListener(FaultEvent.FAULT, sendEmailPHPFail);

        emailfileLoader.loadXML(url, obj);


    }

    private function sendEmailPHPVerify(event:Event):void{

        var obj:Object;
        obj = new Object();


        var responseXML:XML = XML(emailxmlFileLoader.lastResult);
        emailxmlFileLoader.removeEventListener(ResultEvent.RESULT, sendEmailPHPVerify);
        emailxmlFileLoader.removeEventListener(FaultEvent.FAULT, sendEmailPHPFail);
        var response:String = responseXML.toString();

        if(response == "ok")
        {obj = responseXML;}
        if(response == "error")
            return;

    }

    private function sendEmailPHPFail(event:Event):void{

        var obj:Object;
        obj =  XML(emailxmlFileLoader.lastResult);
        obj;

        emailxmlFileLoader.removeEventListener(ResultEvent.RESULT, sendEmailPHPVerify);
        emailxmlFileLoader.removeEventListener(FaultEvent.FAULT, sendEmailPHPFail);
    }



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function registerValidation():Boolean{

        var pass:Boolean=false;

        emailVerify.errorString ="";
        regPass1.errorString ="";
        regPass2.errorString ="";
        regState.errorString ="";

        errorRegister.text = "Please Add Your Email and Desired Password" + '\n' + "Password Characters Restricted to: a-z, A-Z, ! , . , * ";

         textBoxName = emailVerify;
        pass = emailVerifyFunction();

        if(pass == false)
            return pass;

        textBoxName = regPass1;
        pass = passwordVerifyFunction();

        if(pass == false)
        {
            regPass1.text ="";
            regPass2.text ="";
            return pass;}

        textBoxName = regPass2;
        pass = passwordVerifyFunction();

        if(pass == false)
        {
            regPass1.text ="";
            regPass2.text ="";
            return pass;}

        if(regState.selectedIndex == -1)
        {regState.errorString="Required";
            return pass;}

        pass = true;
        return pass;
    }

    private function clearRegisterObj(obj:Object):Object
    {
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
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////


    private function creditCardType():void{
        var customSizeList:XML;

        customSizeList = <creditCards>
            <cc data="Visa" label="Visa">Visa</cc>
            <cc data="MasterCard" label="MasterCard">MasterCard</cc>
            <cc data="Discover" label="Discover">Discover</cc>
            <cc data="American Express" label="American Express">American Express</cc>
        </creditCards>;

        var xl:XMLList = XMLList( customSizeList.children() );
        xc = new XMLListCollection( xl  );


    }

    private function createRandomPassword():void{

        var time:Date = new Date();
        var day:uint = time.getDay();
        var mill:uint = time.getMilliseconds();
        var seconds:uint = time.getSeconds();
        var minutes:uint = time.getMinutes();
        var hours:uint = time.getHours();
        var dd:Number = time.getDate();
        var mm:Number = time.getMonth();
        var yyyy:Number = time.getFullYear();
        time.setFullYear(yyyy,mm,dd);
        var fullDate:String = time.toDateString();

        _randomCode = "PSWD" +  mill +  seconds + minutes + day + hours;
    }
    protected function activateEmailResend_handler(event:MouseEvent):void
    {
        sendEmailPHP();
    }

    private function tosCheck_handler(event:MouseEvent):void
    {
        if(tosCheck.selected == true)
        {

            activateAccountBtn.enabled = true;
        }
        else
        {
            activateAccountBtn.enabled = false;
        }

    }

    private function setUpValidators():void
    {
        emailValidator = new EmailValidator();
        emailValidator.required = true;
        emailValidator.addEventListener(ValidationResultEvent.VALID, Validator_valid);
        emailValidator.addEventListener(ValidationResultEvent.INVALID,Validator_invalid);


        numberValidator = new NumberValidator();
        numberValidator.minValue = 1000;
        numberValidator.maxValue = 100000;
        numberValidator.required = true;
        numberValidator.addEventListener(ValidationResultEvent.VALID, Validator_valid);
        numberValidator.addEventListener(ValidationResultEvent.INVALID,Validator_invalid);


        userIdValidator = new StringValidator();
        userIdValidator.required = true;
        userIdValidator.addEventListener(ValidationResultEvent.VALID, Validator_valid);
        userIdValidator.addEventListener(ValidationResultEvent.INVALID,Validator_invalid);

        passwordValidator = new StringValidator();
        passwordValidator.minLength = 7;
        passwordValidator.required = true;
        passwordValidator.addEventListener(ValidationResultEvent.VALID, Validator_valid);
        passwordValidator.addEventListener(ValidationResultEvent.INVALID,Validator_invalid);
    }
}
}