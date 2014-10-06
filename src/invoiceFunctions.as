public function synchronizeInvoiceData():void {

    loginUserID;
    auctionID = AdminTabNav.adminUserInvoice.auctionID;
    itemID = AdminTabNav.adminUserInvoice.itemID;
    sellerID = AdminTabNav.adminUserInvoice.sellerID;
    bidderID = AdminTabNav.adminUserInvoice.bidderID;
    invoiceType = AdminTabNav.adminUserInvoice.invoiceType;
    auctionsItemListDBXML = AdminTabNav.adminUserInvoice.auctionsItemListDBXML;
    loginUserType = AdminTabNav.adminUserInvoice.loginUserType;

}

public function invoiceViewDisplayComplete():void {
    invoicePrintOut.loginUserID = loginUserID;
    invoicePrintOut.itemID = itemID;
    invoicePrintOut.invoiceType = invoiceType;
    invoicePrintOut.sellerID = sellerID;
    invoicePrintOut.bidderID = bidderID;
    invoicePrintOut.auctionID = auctionID;
    invoicePrintOut.auctionsItemListDBXML = auctionsItemListDBXML;
    invoiceItemsViewDisplayComplete();
}