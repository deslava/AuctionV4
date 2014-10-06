public function synchronizeAuctionItemAdminViewRenderer():void {

    if (AdminTabNav.auctionLoaderCom.itemsListHolder.selectedIndex == -1) {
        return;
    }

    auctionItemFileXML = AdminTabNav.auctionLoaderCom.auctionItemFileXML;
    auctionItemDBXML = AdminTabNav.auctionLoaderCom.auctionItemDBXML;
    auctionID = AdminTabNav.auctionLoaderCom.auctionID;

    this.currentState = "PreviewItem";
    pageLoader();

}
