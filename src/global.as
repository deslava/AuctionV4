import auctionFunctionsClass.auctionClass;
import auctionFunctionsClass.auctionsListClass;
import auctionFunctionsClass.fileLoaderClass;

import mx.rpc.http.HTTPService;

public var loggedIn:Boolean = false;
public var loginUserID:String = "0";
public var loginUserPass:String = "0";
public var loginUserType:String = "";
public var loginUserStatus:String = "";


public var auctionID:Number = -1;
public var itemID:Number;

public var auctionDBXML:XML;
public var auctionFileXML:XML;

public var auctionItemDBXML:XML;
public var auctionItemFileXML:XML;

private var auctionsItemListDBXML:XML;

public var auctionListsXML:XML;
public var auctionItemsDBListXML:XML;

public var userFileXML:XML;
public var userDBFile:XML;

public var auctionLists:auctionsListClass;
public var auction:auctionClass;

public var auctionSellerLists:XML;

public var currentEditState:String = "New";


public var fileLoader:fileLoaderClass = new fileLoaderClass();
public var xmlFileLoader:HTTPService = new HTTPService();

public var sellerID:Number = -1;
public var bidderID:Number = -1;
public var currBid:Number = -1;
public var buyerID:Number = -1;
public var invoiceType:String = "";
public var fromAdminPage:String = "no";