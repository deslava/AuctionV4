/**
 * Created by danieleslava on 10/17/14.
 */
package auctionFunctionsClass {
public class invoiceItemClass {
    public function invoiceItemClass() {

        super();
    }

    private var _invoiceListXML = new XML();
    private var _itemFileXML = new XML();
    private var _itemFeesXML = new XML();
    private var _bidderUserDBXML:XML = new XML();
    private var _xl:XMLList = new XMLList();


    private var _auctionItemFileXML = new XML();
    private var _auctionItemDBXML = new XML();

    private var _currBid:int = new int();
    private var _reserve:int = new int();

    private var _itemID:String = new String();
    private var _quantity:String = new String();
    private var _reserveFee:String = new String();
    private var _buyNow:String = new String();
    private var _sellerType:String = new String();
    private var _bidderID:String = new String();

    public function get auctionItemFileXML():XML {
        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void{
        _auctionItemFileXML = value;
    }

    public function get auctionItemDBXML():XML {
        return _auctionItemDBXML;
    }

    public function set auctionItemDBXML(value:XML):void {
        _auctionItemDBXML = value;
    }
    public function set bidderUserDBXML(value:XML):void {
        _bidderUserDBXML = value;
    }

    public function get bidderUserDBXML():XML {
        return _bidderUserDBXML;
    }
    public function create():void{


        _invoiceListXML = new XML();
        _invoiceListXML = <invoiceList/>;
    }




    public function addItem(_itemXML:XML):void{


        formatFeeXML(_itemXML);



    }

    private function formatFeeXML(_itemXML:XML):void{

        var node:XML;
        var obj:Object = new Object();

        obj = _itemXML;

        if(obj == null)
        {_itemFeesXML = new XML();}
        else
        {_itemFeesXML = XML(obj.auctionFees);}


        node = <fee idBidder="" description="" id="" type ="" amount="" display="" applyTo="" quantity="" reserveMet="" buyNow="" winner="" reserveFee="" tax=""/>;


        getItemValues();

        setItemValues(node);

    }


    private function getItemValues():void{
        var node:XML = new XML();
        var reserveStr:String = new String();

        _xl = _itemFeesXML.fee.(@id=="Reserve Fee");

        node = _xl[0];

        if(node == null)
        {_reserveFee = "10"}
        else
        {
            _reserveFee = node.@amount;
        }

        _currBid = _auctionItemDBXML.start_bid;
        _sellerType = _bidderUserDBXML.user[0].userType;
        _bidderID = _bidderUserDBXML.user[0].userId;

        reserveStr = _auctionItemFileXML.reserveDollar;
        _reserve = int(reserveStr);

        _itemID = _auctionItemFileXML.itemId;
        _quantity = _auctionItemFileXML.quantity;
        _buyNow = _auctionItemFileXML.buyNow;
    }

    private function setItemValues(node:XML):void{

        node.@id = _itemID;
        node.@buyNow = _buyNow;
        node.@quantity = _quantity;
        node.@applyTo = "Item";
        node.@winner = _sellerType;
        node.@idBidder = _bidderID;

        if(_reserve > _currBid)
        {
            node.@reserveMet = "false";
            node.@amount = _reserveFee;
        }
        else{

            node.@reserveMet = "true";
            node.@amount = _currBid;
        }

        if(_buyNow == "false" && _sellerType != "Bidder")
            node.@display = node.@amount + " (RF)";
        else if(_buyNow == "true")
            node.@display = node.@amount + " (BN)";
        else
            node.@display = "$" + node.@amount;

        _reserve = 0;

    }
    private function assignDefaultFee():void{


    }
    public function calculateReserveFee():void{

    }

    public function calculateItemFee():void{

    }
}
}
