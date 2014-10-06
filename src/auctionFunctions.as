import auctionFunctionsClass.serverTime;

public var currTime:Date;
public var serverTimeLoaderItem:serverTime = new serverTime();


public function init():void {

    pageLoader();
}


public function synchronizeUserLogIn():void {

    loggedIn = logInCom.loggedIn;
    loginUserID = logInCom.loginUserID;
    loginUserPass = logInCom.loginUserPass;
    loginUserType = logInCom.loginUserType;
    loginUserStatus = logInCom.loginUserStatus;
    userDBFile = logInCom.userDBXML;
    userFileXML = logInCom.userFileXML;
}

public function synchronizeAuctionCreateNew():void {

    currentEditState = AdminTabNav.auctionLoaderCom.currentEditState;
    auctionDBXML = AdminTabNav.auctionLoaderCom.auctionDBXML;
    auctionFileXML = AdminTabNav.auctionLoaderCom.auctionFileXML;
    fromAdminPage = "yes";

}


public function synchronizeAuctionAdminViewRenderer():void {

    if (AdminTabNav.auctionLoaderCom.auctionListHolder.selectedIndex == -1)
        return;

    auctionID = AdminTabNav.auctionLoaderCom.auctionID;
    auctionFileXML = AdminTabNav.auctionLoaderCom.auctionFileXML;
    auctionDBXML = AdminTabNav.auctionLoaderCom.auctionDBXML;
    fromAdminPage = "yes";

    this.currentState = "PreviewAuction";
    pageLoader();

}

public function synchronizeAuctionItemRenderer():void {


    auctionItemFileXML = AdminTabNav.auctionLoaderCom.auctionItemFileXML;
    auctionItemDBXML = AdminTabNav.auctionLoaderCom.auctionItemDBXML;
    auctionID = AdminTabNav.auctionLoaderCom.auctionID;
    fromAdminPage = "yes";


}


public function loadSelectedAuction():void {
    var selectedAuction:int = AdminTabNav.auctionLoaderCom.auctionListHolder.selectedIndex;
    if (selectedAuction == -1)
        return;
    this.currentState = "AddAuction";
    currentEditState = "Edit"
    fromAdminPage = "yes";
    pageLoader();
}
