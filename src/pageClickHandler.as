// ActionScript file

import flash.events.MouseEvent;

import mx.rpc.events.ResultEvent;

import spark.components.Button;

protected function AdminTabNav_clickHandler(event:MouseEvent):void {

    var obj:Object;
    obj = event.target;
    obj;

    if (obj is Button) {
        obj;
    }
    else
        return;

    var name:String = obj.id;
    obj;

    AdminTabNavClickHandler(name);

}

protected function AdminTabNavClickHandler(name:String):void {

    if (name == "accountInfoBtn") {

    }

    if (name == "previewAuctionBtn") {
        synchronizeAuctionAdminViewRenderer();

    }
    if (name == "previewAuctionItemBtn") {

        synchronizeAuctionItemAdminViewRenderer();


    }

    if (name == "createAuctionAdminPageBtn") {
        this.currentState = "AddAuction";
        synchronizeAuctionCreateNew();
        pageLoader();

    }
    if (name == "editAuctionBtn") {
        synchronizeAuctionCreateNew();
        loadSelectedAuction();

    }

    if (name == "addAuctionItemsBtn") {

        if (AdminTabNav.auctionLoaderCom.currentEditState == "New") {
            auctionFileXML = AdminTabNav.auctionLoaderCom.auctionFileXML;
            auctionID = AdminTabNav.auctionLoaderCom.auctionID;
            currentEditState = AdminTabNav.auctionLoaderCom.currentEditState;
            this.currentState = "AddItem";
            pageLoader();
        }
    }

    if (name == "editAuctionItemBtn") {
        if (AdminTabNav.auctionLoaderCom.currentEditState == "Edit") {
            auctionFileXML = AdminTabNav.auctionLoaderCom.auctionFileXML;
            auctionID = AdminTabNav.auctionLoaderCom.auctionID;
            currentEditState = AdminTabNav.auctionLoaderCom.currentEditState;
            auctionItemFileXML = AdminTabNav.auctionLoaderCom.auctionItemFileXML;
            this.currentState = "AddItem";
            pageLoader();
        }
    }

    if (name == "itemInvoiceBtn") {

        if (AdminTabNav.adminUserInvoice.currentEditState == "loadSelectedInvoices") {
            AdminTabNav.adminUserInvoice.addEventListener(ResultEvent.RESULT, invoiceListsVerify);

            synchronizeInvoiceData();
        }

    }
}

protected function logIn_clickHandler(event:MouseEvent):void {

    var obj:Object;
    obj = event.target;
    obj;

    if (obj is Button) {
        obj;
    }
    else
        return;

    var name:String = obj.id;
    obj;

    logInClickHandler(name);

}

private function logInClickHandler(name:String):void {

    if (name == "logOutBtn") {
        logInClearLoad();
        pageLoader();

    }
    if (name == "accountInfoBtn") {
        synchronizeUserLogIn();

        if (loginUserType == "Admin" || loginUserType == "Satellite") {
            this.currentState = "AdminPage";
        }
        else if (loginUserType == "Bidder") {
            synchronizeUserLogIn();
            this.currentState = "BidderPage";
        }

        pageLoader();
    }
}

protected function auctionadmintabnav1_clickHandler(event:MouseEvent):void {

    var obj:Object;
    obj = event.target;
    obj;

    if (obj is Button) {
        obj;
    }
    else
        return;

    var name:String = obj.id;
    obj;

    auctionAddClickHandler(name);

}

private function auctionAddClickHandler(name:String):void {
    if (name == "previewAuctionBtn") {
        if (auctionadmintabnav1.currentEditState == "View") {
            auctionFileXML = auctionadmintabnav1.auctionFileXML;
            this.currentState = "PreviewAuction";
            pageLoader();
        }
    }

    if (name == "addAuctionItemsBtn") {

        if (auctionadmintabnav1.currentEditState == "New") {
            auctionFileXML = auctionadmintabnav1.auctionFileXML;
            auctionID = auctionadmintabnav1.auctionID;
            currentEditState = auctionadmintabnav1.currentEditState;
            this.currentState = "AddItem";
            pageLoader();
        }


    }

    if (name == "editAuctionItemBtn") {

        if (auctionadmintabnav1.currentEditState == "Edit") {
            auctionFileXML = auctionadmintabnav1.auctionFileXML;
            auctionID = auctionadmintabnav1.auctionID;
            currentEditState = auctionadmintabnav1.currentEditState;
            auctionItemFileXML = auctionadmintabnav1.auctionItemFileXML;
            this.currentState = "AddItem";
            pageLoader();
        }
    }


    if (name == "previewAuctionItemBtn") {
        if (auctionadmintabnav1.currentEditState == "View") {

            auctionFileXML = auctionadmintabnav1.auctionFileXML;
            auctionID = auctionadmintabnav1.auctionID;
            auctionItemFileXML = auctionadmintabnav1.auctionItemFileXML;
            auctionItemDBXML = auctionadmintabnav1.auctionItemDBXML;
            auctionDBXML = auctionadmintabnav1.auctionDBXML;
            this.currentState = "PreviewItem";
            pageLoader();
        }
    }

}


protected function auctionAdminPreviewCom_clickHandler(event:MouseEvent):void {
    var obj:Object;
    obj = event.target;
    obj;

    if (obj is Button) {
        if (obj.id == "thumb")
            return;
        obj;
    }
    /* else if(obj is RepeatedItem1)
     {
     obj;
     auctionPublicClickHandler2();
     return
     }
     */
    else if (obj.id == "lImage") {
        obj;
        auctionPublicClickHandler2();
        return;
    }
    else
        return;

    var name:String = obj.id;
    obj;

    auctionPublicClickHandler1(name);
}

public function auctionPublicClickHandler1(name:String):void {

    if (name == "loadItemPreviewBtn") {
        //syncronizeAuctionViewRenderer();
        //loadPublicItemPreview();
    }
    if (name == "mapDisplayBtn") {
        galleryDisplayer.clearAuction();
        galleryDisplayer.visible = false;

        mapDisplayer.clearAuction();
        mapDisplayer.auctionFileXML = auctionFileXML;
        mapDisplayer.syncronizeAuction();
    }

}

public function auctionPublicClickHandler2():void {

    mapDisplayer.clearAuction();
    mapDisplayer.visible = false;

    galleryDisplayer.clearAuction();
    galleryDisplayer.xmlFile = auctionFileXML;
    galleryDisplayer.syncronizeAuction();
}


protected function itemAdminPreviewCom_clickHandler(event:MouseEvent):void {
    var obj:Object;
    obj = event.target;
    obj;

    if (obj is Button) {
        if (obj.id == "thumb")
            return;
        obj;
    }
    /* else if(obj is RepeatedItem1)
     {
     obj;
     auctionPublicClickHandler2();
     return
     }
     */
    else if (obj.id == "lImage") {
        obj;
        auctionItemPublicClickHandler2();
        return;
    }
    else
        return;

    var name:String = obj.id;
    obj;

    auctionItemPublicClickHandler1(name);

}

public function auctionItemPublicClickHandler1(name:String):void {

    if (name == "loadItemPreviewBtn") {
        //syncronizeAuctionViewRenderer();
        //loadPublicItemPreview();
    }
    if (name == "mapDisplayBtn") {
        galleryDisplayer.clearAuction();
        galleryDisplayer.visible = false;

        mapDisplayer.clearAuction();
        mapDisplayer.auctionFileXML = auctionFileXML;
        mapDisplayer.syncronizeAuction();
    }

}

public function auctionItemPublicClickHandler2():void {

    mapDisplayer.clearAuction();
    mapDisplayer.visible = false;

    galleryDisplayer.clearAuction();
    galleryDisplayer.xmlFile = auctionItemFileXML;
    galleryDisplayer.syncronizeAuction();
}

////////////////////////////////////////////////////////////////////////////////////////

public function invoiceListsVerify(event:ResultEvent):void {
    var pass:Boolean = false;
    pass = true;

    this.currentState = "InvoiceSystem";
    pageLoader();


}

public function menuClickFunction(event:MouseEvent):void {

    var currBtn:Object = event.currentTarget;
    var name:String = currBtn.id;
    var pass:Boolean = false;

    if (name == "menuBackBtn") {

        backBtn();

    }

    if (name == "menuLogIn") {
        this.currentState = "LogIn";
        pageLoader();
    }


}

public function backBtn():void {

    if (this.currentState == "Home") {
        //this.currentState = "Home";
        //pageLoader();
    }
    if (this.currentState == "LogIn") {
        this.currentState = "Home";
        pageLoader();
    }

    if (this.currentState == "AdminPage") {
        //this.currentState = "Home";
        //pageLoader();

    }

    if (this.currentState == "UserPage") {
        //this.currentState = "Home";
        //pageLoader();

    }
    if (this.currentState == "PreviewAuction") {
        addAuctionClearLoad();
        this.currentState = "AddAuction";
        pageLoader();

    }

    if (this.currentState == "AddAuction") {
        addAuctionClearLoad();
        this.currentState = "AdminPage";
        pageLoader();

    }
    if (this.currentState == "AddItem") {
        addAuctionClearLoad();
        this.currentState = "AddAuction";
        auctionitemadmintabnav1.hideVideo();
        pageLoader();
    }

    if (this.currentState == "PreviewItem") {
        addAuctionClearLoad();
        this.currentState = "AddAuction";
        pageLoader();
    }

    if (this.currentState == "publicAuctionDisplay") {
        //this.currentState = "Home";

        //pageLoader();
    }

    if (this.currentState == "publicItemDisplay") {
        //this.currentState = "Home";
        //pageLoader();
    }

    if (this.currentState == "InvoiceSystem") {
        this.currentState = "AdminPage";
    }

}
