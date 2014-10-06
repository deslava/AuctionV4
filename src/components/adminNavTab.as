package components {
import flash.events.Event;

import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;

public class adminNavTab extends adminNavTabLayout {

    public function adminNavTab() {
        super();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, adminNavTab_creationComplete);
    }

    private var _previousTab:int;
    private var _currentTab:int;

    private var _loginUserType:String;

    public function set loginUserType(value:String):void {
        _loginUserType = value;
    }

    private var _loginUserID:String;

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _userDBFile:XML;

    public function set userDBFile(value:XML):void {
        _userDBFile = value;
    }

    public function clear():void {

        clearTab();
    }

    private function clearTab():void {
        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        adminNavClear();
    }

    private function adminNavClear():void {
        var selectedTab:int = AdminTabNav.selectedIndex;

        AdminTabNav.selectedIndex = 0;
        _previousTab = -1;

        adminUserInfoCom.addEventListener(FlexEvent.CREATION_COMPLETE, tab0_creationComplete);
        clearTab0();

        AdminTabNav.addEventListener(Event.CHANGE, tabNav_changeHandler);
    }

    private function clearTab0():void {

        adminUserInfoCom.clearStaticInfo();
        adminUserInfoCom.loginUserID = _loginUserID;
        adminUserInfoCom.userXML = _userDBFile;
        adminUserInfoCom.userFileXML = _userDBFile;
        adminUserInfoCom.userDBXML = _userDBFile;
        adminUserInfoCom.userInfoDisplay();
        adminUserInfoCom.loadUserInfoXML();
    }

    private function clearTab1():void {

        addUserCom.loadUserData(_userDBFile);
        addUserCom.clear();
    }

    private function clearTab2():void {


        editUserCom.loginUserID = _loginUserID;
        editUserCom.loginUserType = _loginUserType;
        editUserCom.loginUserXML = _userDBFile;

        editUserCom.loadAllUsers();
    }

    private function clearTab4():void {

        auctionLoaderCom.loginUserID = _loginUserID;
        auctionLoaderCom.loadUserData(_userDBFile);
        auctionLoaderCom.clear();
    }

    private function clearTab6():void {

        adminHouseBidCom.loginUserID = _loginUserID;
        adminHouseBidCom.loginUserType = _loginUserType;
        adminHouseBidCom.userFileXML = _userDBFile;
        adminHouseBidCom.clear();

    }

    private function clearTab7():void {

        adminUserInvoice.loginUserID = _loginUserID;
        adminUserInvoice.loginUserType = _loginUserType;
        adminUserInvoice.clear();
    }

    protected function adminNavTab_creationComplete(event:FlexEvent):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, adminNavTab_creationComplete);
    }

    protected function tabNav_changeHandler(event:IndexChangedEvent):void {
        var currItem:Object = event.currentTarget;
        var name:String = currItem.selectedChild.label;

        _previousTab = _currentTab;
        _currentTab = AdminTabNav.selectedIndex;

        if (name == "Admin Info") {
            adminUserInfoCom.addEventListener(FlexEvent.CREATION_COMPLETE, tab0_creationComplete);
            clearTab0();
        }
        if (name == "Add User") {
            addUserCom.addEventListener(FlexEvent.CREATION_COMPLETE, tab1_creationComplete);
            clearTab1();
        }
        if (name == "Edit Users") {
            editUserCom.addEventListener(FlexEvent.CREATION_COMPLETE, tab2_creationComplete);
            clearTab2();

        }
        if (name == "Auctions") {
            auctionLoaderCom.addEventListener(FlexEvent.CREATION_COMPLETE, tab4_creationComplete);
            clearTab4();
        }
        if (name == "Taxes &amp; Fees") {
        }
        if (name == "Global Options") {
        }
        if (name == "HouseBids") {
            adminHouseBidCom.addEventListener(FlexEvent.CREATION_COMPLETE, tab6_creationComplete);
            clearTab6();
        }
        if (name == "Invoices") {
            adminUserInvoice.addEventListener(FlexEvent.CREATION_COMPLETE, tab7_creationComplete);
            clearTab7();
        }

    }

    private function tab0_creationComplete(event:FlexEvent):void {
        addUserCom.removeEventListener(FlexEvent.CREATION_COMPLETE, tab0_creationComplete);
        clearTab0();
    }

    private function tab1_creationComplete(event:FlexEvent):void {
        addUserCom.removeEventListener(FlexEvent.CREATION_COMPLETE, tab1_creationComplete);
        clearTab1();
    }

    private function tab2_creationComplete(event:FlexEvent):void {
        editUserCom.removeEventListener(FlexEvent.CREATION_COMPLETE, tab2_creationComplete);
        clearTab2();
    }

    private function tab4_creationComplete(event:FlexEvent):void {
        auctionLoaderCom.removeEventListener(FlexEvent.CREATION_COMPLETE, tab4_creationComplete);
        clearTab4();

    }

    private function tab6_creationComplete(event:FlexEvent):void {
        adminHouseBidCom.removeEventListener(FlexEvent.CREATION_COMPLETE, tab6_creationComplete);
        clearTab6();
    }

    private function tab7_creationComplete(event:FlexEvent):void {
        adminUserInvoice.removeEventListener(FlexEvent.CREATION_COMPLETE, tab7_creationComplete);
        clearTab7();
    }


}
}
