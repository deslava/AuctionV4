package components {
import flash.events.Event;

import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;

public class bidderNavTab extends bidderNavTabLayout {

    public function bidderNavTab() {
        super();
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

    private var _userFileXML:XML;

    public function set userFileXML(value:XML):void {
        _userFileXML = value;
    }

    public function clear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;


        clearTab();
    }

    private function clearTab():void {
        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        bidderNavClear();
    }

    private function bidderNavClear():void {

        var selectedTab:int = bidderTabNav.selectedIndex;

        bidderTabNav.selectedIndex = 0;
        _previousTab = -1;

        bidderBidCom.addEventListener(FlexEvent.CREATION_COMPLETE, tab0_creationComplete);
        clearTab0();

        bidderTabNav.addEventListener(Event.CHANGE, tabNav_changeHandler);
    }

    private function clearTab0():void {

        bidderBidCom.loginUserID = _loginUserID;
        bidderBidCom.loginUserType = _loginUserType;
        bidderBidCom.userFileXML = _userDBFile;
        bidderBidCom.clear();

    }

    private function clearTab1():void {

        var active:Boolean;
        if (bidderUserInfoCom == null)
            return;
        active = bidderUserInfoCom.initialized;
        if (active == false)
            return;

        bidderUserInfoCom.clearStaticInfo();
        bidderUserInfoCom.loginUserID = _loginUserID;
        bidderUserInfoCom.userDBXML = _userDBFile;
        bidderUserInfoCom.userXML = _userDBFile;
        bidderUserInfoCom.userFileXML = _userFileXML;
        bidderUserInfoCom.userInfoDisplay();
        bidderUserInfoCom.loadUserInfoXML();
    }

    protected function tabNav_changeHandler(event:IndexChangedEvent):void {
        var currItem:Object = event.currentTarget;
        var name:String = currItem.selectedChild.label;

        _previousTab = _currentTab;
        _currentTab = bidderTabNav.selectedIndex;

        if (name == "Bidder Info") {
            bidderUserInfoCom.addEventListener(FlexEvent.CREATION_COMPLETE, tab1_creationComplete);
            clearTab1();
        }
    }

    private function tab0_creationComplete(event:FlexEvent):void {
        bidderBidCom.removeEventListener(FlexEvent.CREATION_COMPLETE, tab0_creationComplete);
        clearTab0();
    }

    private function tab1_creationComplete(event:FlexEvent):void {
        bidderUserInfoCom.removeEventListener(FlexEvent.CREATION_COMPLETE, tab1_creationComplete);
        clearTab1();
    }


}
}
