package components {
import auctionFunctionsClass.fileLoaderClass;

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
import spark.events.GridSelectionEvent;
import spark.events.IndexChangeEvent;

public class userEdit extends userEditLayout {
    public function userEdit() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, editUserCom_creationCompleteHandler);
    }

    private var userInfoXML:XML = new XML();
    private var usersListXML:XML = new XML();
    private var userTypeXML:XML = new XML();
    private var userStatusXML:XML = new XML();
    private var usStatesXML:XML = new XML();
    private var xc:XMLListCollection = new XMLListCollection;
    private var xc2:XMLListCollection = new XMLListCollection;
    private var xc3:XMLListCollection = new XMLListCollection;
    private var xc4:XMLListCollection = new XMLListCollection;
    private var xmlStatesLoader:HTTPService = new HTTPService();
    private var stateFileLoader:fileLoaderClass = new fileLoaderClass();
    private var xmlFileLoader:HTTPService = new HTTPService();
    private var fileLoader:fileLoaderClass = new fileLoaderClass();

    private var _loginUserID:String = new String();

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _loginUserType:String = new String();

    public function get loginUserType():String {
        return _loginUserType;
    }

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    private var _loginUserXML:XML = new XML();

    public function get loginUserXML():XML {
        return _loginUserXML;
    }

    public function set loginUserXML(value:XML):void {
        _loginUserXML = value;
    }

    public function loadAllUsers():void {

        var obj:Object = new Object();

        obj.userSearch = "AllUsers";
        obj.userType = _loginUserType;
        obj.searchVar = "";


        loadUserLists(obj);
    }

    private function userEditClear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        loadUserData(_loginUserXML);

    }

    private function clearUserAdminEditTab():void {

        var obj:Object = new Object();

        userTypeEdit.dataProvider = xc2.list;
        userStatusEdit.dataProvider = xc3.list;

        assignStates();

        userEditSerch.text = "";
        nameEdit.text = "";
        nameEdit.enabled = true;
        nameEdit.errorString = "";
        emailEdit.text = "";
        userEditID.text = "";
        userEditServerPath.text = "";
        userEditPass.text = "***********";
        userEditPass.enabled = false;
        userEditPass.errorString = "";
        userEditResetPassEmailcheck.enabled = true;
        userEditResetPassEmailcheck.selected = true;

        userTypeEdit.enabled = true;
        userStatusEdit.enabled = true;
        userStateEdit.enabled = true;

        userEditError.text = "Warning, Changes are Immediate!"

        editUserBtnError.text = "";

        editUsersTally.text = "";

        housePassReset.selected = true;

        loadSelectedUserData()


    }

    private function assignUserEditEvents():void {

        if (this.currentState == "allUserInfo") {
            userSearchBtn.addEventListener(MouseEvent.CLICK, adminClickFunction);
            userEditType.addEventListener(IndexChangeEvent.CHANGE, userDropDownSearch_changeHandler);
            userEditStatus.addEventListener(IndexChangeEvent.CHANGE, userDropDownSearch_changeHandler);

            allUserDataLoader.addEventListener(GridSelectionEvent.SELECTION_CHANGE, allUserDataLoader_selectionChangeHandler);
            removeUserEdit.addEventListener(MouseEvent.CLICK, removeUserEdit_clickHandler);

            editUserBtn.addEventListener(MouseEvent.CLICK, editUserBtn_clickHandler);
        }
        else if (this.currentState == "updateUserInfo") {

            userInfoUpdate.addEventListener(MouseEvent.CLICK, adminClickFunction);
            userUpdatePnl.addEventListener(CloseEvent.CLOSE, userUpdatePnl_closeHandler);
            userEditResetPass.addEventListener(MouseEvent.CLICK, passWordClickFunction);

        }
        else if (this.currentState == "deleteUser") {
            deleteUserAdminPnl.addEventListener(CloseEvent.CLOSE, deleteUserAdminPnl_closeHandler);
            deleteSelectedUserAdmin.addEventListener(MouseEvent.CLICK, adminClickFunction);
            yesDeleteUserBtn.addEventListener(MouseEvent.CLICK, yesDeleteUserBtn_clickHandler);
        }
    }

    private function getDeleteUserInfoXML():XML {
        var node:XML = userInfoXML;
        return userInfoXML;
    }

    private function clearDeleteUser():void {
        yesDeleteUserBtn.enabled = true;
        yesDeleteUserBtn.selected = false;
        deleteSelectedUserAdmin.enabled = false;
    }

    private function loadUserData(node:XML):void {

        this.currentState = "allUserInfo";

        _loginUserXML = node;

        loadUsersList(node);
        loadStatusTypeList();
        loadUserListsXML();
    }

    private function loadUsersList(node:XML):void {

        var productAttributes:XMLList = node.children();
        var xl:XMLList = XMLList(productAttributes);
        xc4 = new XMLListCollection(xl);

        allUserDataLoader.dataProvider = xc4.list;

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


        userEditType.dataProvider = xc2.list;

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


        userEditStatus.dataProvider = xc3.list;


    }

    private function usersSearchXMLData():void {
        var obj:Object = new Object();

        obj = userSearchVariables();
        loadUserLists(obj);


    }

    private function userSearchVariables():Object {

        var obj:Object = new Object();

        if (radioIDadmin.selected == true)
            obj.userSearch = "userId";
        else if (radioEmailadmin.selected == true)
            obj.userSearch = "userEmail";
        else if (radioNameadmin.selected == true)
            obj.userSearch = "userStatus";
        else if (radioLoadAll.selected == true)
            obj.userSearch = "AllUsers";

        obj.searchVar = userEditSerch.text;
        obj.userType = _loginUserType;

        return obj;

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

    }

    private function assignStates():void {

        userStateEdit.dataProvider = xc.list;

    }

    private function loadSelectedUserData():void {
        var s:String;

        userInfoXML = allUserDataLoader.selectedItem as XML;
        nameEdit.text = userInfoXML.userName;
        emailEdit.text = userInfoXML.userEmail;
        userEditID.text = userInfoXML.userId;
        userEditServerPath.text = userInfoXML.userPath;
        userEditPass.text = userInfoXML.userPass;

        userTypeEdit.selectedIndex = valueTabSearch(userTypeEdit, userInfoXML.userType.toString());
        userStatusEdit.selectedIndex = valueTabSearch(userStatusEdit, userInfoXML.userStatus.toString());
        userStateEdit.selectedIndex = valueTabSearch(userStateEdit, userInfoXML.userState.toString());

        s = userInfoXML.userType.toString();
        if (s == "House") {
            housePassReset.visible = true;
        }
        else {
            housePassReset.visible = false;
        }

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

    private function loadUserLists(obj:Object):void {

        var url:String;
        url = "searchUserList.php";

        xmlFileLoader = fileLoader.xmlFileLoader;
        xmlFileLoader.addEventListener(ResultEvent.RESULT, loadUserInfoXMLVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, loadUserInfoXMLFail);

        fileLoader.loadXML(url, obj);

    }

    private function verifyloadUserInfoXMLValid():void {
        var i:int;

        userInfoLoadData();


    }

    private function userInfoLoadData():void {


        loadUserData(userInfoXML);
    }

    private function updateUserXMLInfo():void {

        var node:XML = new XML();
        var obj:Object = new Object();


        obj.username = "";
        obj.password = "";
        obj.userType = "";
        obj.userEmail = "";
        obj.userStatus = "";
        obj.userPath = "";
        obj.userState = "";
        obj.userXML = "";
        obj.userCreator = "";
        obj.userCreatorID = "";
        obj.updateHouse = "";

        node = getuserInfoXML();


        obj.searchVar = "";
        obj.table1 = "users";


        updateUserInfo(node);

    }

    private function getuserInfoXML():XML {


        userInfoXML.userName = nameEdit.text;
        userInfoXML.userEmail = emailEdit.text;
        userInfoXML.userId = userEditID.text;
        userInfoXML.userPath = userEditServerPath.text;
        userInfoXML.userPass = userEditPass.text;

        userInfoXML.userType = userTypeEdit.selectedItem.toString();
        userInfoXML.userStatus = userStatusEdit.selectedItem.toString();
        userInfoXML.userState = userStateEdit.selectedItem.toString();

        return userInfoXML;


    }


    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function updateUserInfo(node:XML):void {

        var obj:Object = new Object();


        obj.username = node.userName;
        obj.password = node.userPass;
        obj.userType = node.userType;
        obj.userEmail = node.userEmail;
        obj.userStatus = node.userStatus;
        obj.userPath = node.userPath;
        obj.userState = node.userState;
        obj.userXML = node.userXML;
        obj.userCreator = "";
        obj.userCreatorID = "";

        if (housePassReset.selected == true && node.userType.toString() == "House") {
            obj.updateHouse = "All";
            obj.userCreatorID = node.userCreatorID.toString();
        }


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

    private function deleteUser():void {
        var node:XML = new XML();
        var obj:Object = new Object();
        var t:String;
        var path:String;


        obj.username = "";
        obj.password = "";
        obj.userType = "";
        obj.userEmail = "";
        obj.userStatus = "";
        obj.userPath = "";
        obj.userState = "";
        obj.userXML = "";
        obj.userCreator = "";
        obj.userCreatorID = "";
        obj.updateHouse = "";

        node = getDeleteUserInfoXML();


        path = node.userPath.toString();

        t = node.userType.toString();

        obj.searchVar = node.userId.toString();
        obj.table1 = "userDelete";

        if (t != "House")
            obj.userPath = path;


        updateUserDatabase(obj);


    }

    public function editUserCom_creationCompleteHandler(event:FlexEvent):void {
        assignUserEditEvents();
        userEditClear();
        this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, editUserComState);
        loadStatesXML();
    }

    protected function passWordClickFunction(event:MouseEvent):void {
        userEditPass.editable = true;
        userEditPass.enabled = true;
    }

    private function editUserComState(event:StateChangeEvent):void {

        assignUserEditEvents();


        if (this.currentState == "updateUserInfo") {

            clearUserAdminEditTab();

            assignStates();
        }
    }

    private function editUserBtn_clickHandler(event:MouseEvent):void {
        // TODO Auto-generated method stub
        this.currentState = "updateUserInfo";

    }

    private function removeUserEdit_clickHandler(event:MouseEvent):void {
        // TODO Auto-generated method stub
        this.currentState = "deleteUser";
        clearDeleteUser();

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function adminClickFunction(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;

        if (name == "userSearchBtn") {

            usersSearchXMLData();

        }

        if (name == "userInfoUpdate") {
            updateUserXMLInfo();
        }


        if (name == "deleteSelectedUserAdmin") {

            deleteUser();
        }


        if (name == "userSearchBtn") {

            //searchPrivateUserList();

        }


    }

    private function userDropDownSearch_changeHandler(event:IndexChangeEvent):void {
        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var currSelected:String = currBtn.selectedItem.toString();


        var obj:Object = new Object();

        if (name == "userEditType")
            obj.userSearch = "userType";
        else if (name == "userEditStatus")
            obj.userSearch = "userStatus";

        obj.userType = _loginUserType;
        obj.searchVar = currSelected;
        loadUserLists(obj);

    }

    private function allUserDataLoader_selectionChangeHandler(event:GridSelectionEvent):void {
        if (allUserDataLoader.selectedIndex == -1)
            return;

        else {
            removeUserEdit.enabled = true;
            editUserBtn.enabled = true;
        }
        userInfoXML = allUserDataLoader.selectedItem as XML;
    }

    private function deleteUserAdminPnl_closeHandler(event:CloseEvent):void {
        this.currentState = "allUserInfo";
        clearDeleteUser();
    }

    private function userUpdatePnl_closeHandler(event:CloseEvent):void {
        this.currentState = "allUserInfo";

    }

    private function yesDeleteUserBtn_clickHandler(event:MouseEvent):void {
        if (yesDeleteUserBtn.enabled = true) {

            deleteSelectedUserAdmin.enabled = true;
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

        loadStates();
    }

    private function loadUserInfoXMLFail(event:Event):void {


        _loginUserXML.userXML = "";

    }

    private function loadUserInfoXMLVerify(event:Event):void {

        userInfoXML = XML(xmlFileLoader.lastResult);

        verifyloadUserInfoXMLValid();

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, loadUserInfoXMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, loadUserInfoXMLFail);

    }

    private function updateUserInfoVerify(event:Event):void {

        var responseXML:XML = XML(xmlFileLoader.lastResult);
        xmlFileLoader.removeEventListener(ResultEvent.RESULT, updateUserInfoVerify);
        xmlFileLoader.removeEventListener(ResultEvent.RESULT, updateUserInfoFail);

        var response:String = responseXML.toString();


        if (response == "error") {

            userEditError.text = "Error Updating Field";


        }
        else if (response == "ok") {

            loadUserData(_loginUserXML);
            loadAllUsers();

        }

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function updateUserInfoFail(event:Event):void {


    }

}
}