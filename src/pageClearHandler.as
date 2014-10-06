public function addAuctionClearLoad():void {

    currentEditState = "New";
    auctionFileXML = new XML();
    auctionDBXML = new XML();
    fromAdminPage = "no";

}

public function logInClearLoad():void {
    loggedIn = false;
    loginUserID = "0";
    loginUserPass = "0";
    loginUserType = "";
    loginUserStatus = "";

    logInCom.loggedIn = false;
    logInCom.loginUserEmail = "";
    logInCom.loginUserID = "0";
    logInCom.loginUserPass = "0";
    logInCom.loginUserType = "";
}