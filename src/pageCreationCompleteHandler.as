// ActionScript file

import flash.events.MouseEvent;

import mx.events.FlexEvent;

public function logInCom_creationCompleteHandler(event:FlexEvent):void {
    logInCreationLoad();
}


public function AdminTabNav_creationCompleteHandler(event:FlexEvent):void {
    AdminTabNavCreationLoad();
}

public function BidderTabNav_creationCompleteHandler(event:FlexEvent):void {
    BidderTabNavCreationLoad();
}


public function auctionadmintabnav1_creationCompleteHandler(event:FlexEvent):void {
    addAuctionCreateLoad();
}

public function auctionAdminPreviewCom_creationCompleteHandler(event:FlexEvent):void {

    auctionPublicViewDisplayComplete();
}


public function auctionitemadmintabnav1_creationCompleteHandler(event:FlexEvent):void {
    addAuctionItemCreateLoad();
}


public function itemAdminPreviewCom_creationCompleteHandler(event:FlexEvent):void {
    itemPublicViewDisplayComplete();
}


public function invoicePrintOut_creationCompleteHandler(event:FlexEvent):void {

    invoiceItemsViewDisplayComplete();
}

public function AdminTabNavCreationLoad():void {

    var active:Boolean;
    if (AdminTabNav == null)
        return;
    active = AdminTabNav.initialized;
    AdminTabNav.addEventListener(FlexEvent.CREATION_COMPLETE, AdminTabNav_creationCompleteHandler);
    if (active == false)
        return;

    AdminTabNav.addEventListener(MouseEvent.CLICK, AdminTabNav_clickHandler);
    AdminTabNav.loginUserID = loginUserID;
    AdminTabNav.loginUserType = loginUserType;
    AdminTabNav.userDBFile = userDBFile;
    AdminTabNav.clear();
}

public function BidderTabNavCreationLoad():void {

    var active:Boolean;
    if (bidderTabNav == null)
        return;
    active = bidderTabNav.initialized;
    bidderTabNav.addEventListener(FlexEvent.CREATION_COMPLETE, BidderTabNav_creationCompleteHandler);

    if (active == false)
        return;


    bidderTabNav.addEventListener(MouseEvent.CLICK, AdminTabNav_clickHandler);
    bidderTabNav.loginUserID = loginUserID;
    bidderTabNav.loginUserType = loginUserType;
    bidderTabNav.userDBFile = userDBFile;
    bidderTabNav.userFileXML = userFileXML;
    bidderTabNav.clear();

}

public function logInCreationLoad():void {
    var active:Boolean;
    if (logInCom == null)
        return;
    active = logInCom.initialized;
    logInCom.addEventListener(FlexEvent.CREATION_COMPLETE, logInCom_creationCompleteHandler);
    if (active == false)
        return;

    logInCom.addEventListener(MouseEvent.CLICK, logIn_clickHandler);
    logInCom.clear();
}


public function addAuctionCreateLoad():void {
    var active:Boolean;
    if (auctionadmintabnav1 == null)
        return;

    active = auctionadmintabnav1.initialized;
    auctionadmintabnav1.addEventListener(FlexEvent.CREATION_COMPLETE, auctionadmintabnav1_creationCompleteHandler);
    if (active == false)
        return;

    auctionadmintabnav1.removeEventListener(FlexEvent.CREATION_COMPLETE, auctionadmintabnav1_creationCompleteHandler);
    auctionadmintabnav1.addEventListener(MouseEvent.CLICK, auctionadmintabnav1_clickHandler);

    auctionadmintabnav1.currentEditState = currentEditState;
    auctionadmintabnav1.auctionFileXML = auctionFileXML;
    auctionadmintabnav1.auctionDBXML = auctionDBXML;
    auctionadmintabnav1.loginUserID = loginUserID;
    auctionadmintabnav1.loginUserType = loginUserType;
    auctionadmintabnav1.fromAdminPage = fromAdminPage;
    auctionadmintabnav1.clear();
}


public function auctionPublicViewDisplayComplete():void {
    var active:Boolean;
    if (auctionAdminPreviewCom == null)
        return;
    active = auctionAdminPreviewCom.initialized;
    auctionAdminPreviewCom.addEventListener(FlexEvent.CREATION_COMPLETE, auctionAdminPreviewCom_creationCompleteHandler);
    if (active == false)
        return;
    auctionAdminPreviewCom.removeEventListener(FlexEvent.CREATION_COMPLETE, auctionAdminPreviewCom_creationCompleteHandler);
    auctionAdminPreviewCom.addEventListener(MouseEvent.CLICK, auctionAdminPreviewCom_clickHandler);

    mapDisplayer.visible = false;
    galleryDisplayer.visible = false;

    auctionAdminPreviewCom.clearAuction();
    auctionAdminPreviewCom.auctionFileXML = auctionFileXML;
    auctionAdminPreviewCom.syncronizeAuction();

}


public function addAuctionItemCreateLoad():void {
    var active:Boolean;
    if (auctionitemadmintabnav1 == null)
        return;
    active = auctionitemadmintabnav1.initialized;
    auctionitemadmintabnav1.addEventListener(FlexEvent.CREATION_COMPLETE, auctionitemadmintabnav1_creationCompleteHandler);
    if (active == false)
        return;

    auctionitemadmintabnav1.removeEventListener(FlexEvent.CREATION_COMPLETE, auctionitemadmintabnav1_creationCompleteHandler);


    auctionitemadmintabnav1.currentEditState = currentEditState;
    auctionitemadmintabnav1.auctionID = auctionID;
    auctionitemadmintabnav1.auctionFileXML = auctionFileXML;
    auctionitemadmintabnav1.auctionItemFileXML = auctionItemFileXML;
    auctionitemadmintabnav1.clear();

}


public function itemPublicViewDisplayComplete():void {
    var active:Boolean;
    if (itemAdminPreviewCom == null)
        return;
    active = itemAdminPreviewCom.initialized;
    itemAdminPreviewCom.addEventListener(FlexEvent.CREATION_COMPLETE, itemAdminPreviewCom_creationCompleteHandler);
    if (active == false)
        return;
    itemAdminPreviewCom.removeEventListener(FlexEvent.CREATION_COMPLETE, itemAdminPreviewCom_creationCompleteHandler);
    itemAdminPreviewCom.addEventListener(MouseEvent.CLICK, itemAdminPreviewCom_clickHandler);

    mapDisplayer.visible = false;
    galleryDisplayer.visible = false;

    itemAdminPreviewCom.clearItem();
    itemAdminPreviewCom.auctionItemFileXML = auctionItemFileXML;
    itemAdminPreviewCom.auctionItemDBXML = auctionItemDBXML;
    itemAdminPreviewCom.syncronizeItem();

}

public function invoiceItemsViewDisplayComplete():void {
    var active:Boolean;
    if (invoicePrintOut == null)
        return;
    active = invoicePrintOut.initialized;
    invoicePrintOut.addEventListener(FlexEvent.CREATION_COMPLETE, invoicePrintOut_creationCompleteHandler);
    if (active == false)
        return;

    invoicePrintOut.removeEventListener(FlexEvent.CREATION_COMPLETE, invoicePrintOut_creationCompleteHandler);
    invoicePrintOut.clear();
    invoicePrintOut.loadAdminUsers();
    invoicePrintOut.loadBuyerUsers();
    invoicePrintOut.loadItemListData();

}


