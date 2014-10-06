// ActionScript file

public function pageLoader():void {
    var CurrentPage:String;

    CurrentPage = this.currentState;

    if (CurrentPage == "Home") {

    }
    else if (CurrentPage == "LogIn") {
        logInCreationLoad();
    }

    else if (CurrentPage == "AdminPage") {
        AdminTabNavCreationLoad();
    }

    else if (CurrentPage == "BidderPage") {
        BidderTabNavCreationLoad();
    }
    else if (CurrentPage == "AddAuction") {
        addAuctionCreateLoad();
    }
    else if (CurrentPage == "AddItem") {
        addAuctionItemCreateLoad();
    }
    else if (CurrentPage == "PreviewAuction") {

        auctionPublicViewDisplayComplete();

    }
    else if (CurrentPage == "PreviewItem") {

        itemPublicViewDisplayComplete();

    }

    else if (CurrentPage == "InvoiceSystem") {
        invoiceViewDisplayComplete();
    }
}




