package components {

import flashx.textLayout.conversion.TextConverter;

import mx.collections.XMLListCollection;

import spark.components.List;

public class itemView extends itemViewLayout {
    public function itemView() {
        super();
    }

    private var _auctionItemFileXML:XML;

    public function get auctionItemFileXML():XML {
        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
    }

    private var _auctionItemDBXML:XML;

    public function get auctionItemDBXML():XML {
        return _auctionItemDBXML;
    }

    public function set auctionItemDBXML(value:XML):void {
        _auctionItemDBXML = value;
    }

    public function clearItem():void {

        clearTab();
    }

    public function syncronizeItem():void {


        loadItemFile(_auctionItemFileXML);
    }

    private function clearTab():void {


        itemTitle.text = "Select An Item";
        itemIDtext.text = "";
        categoryDisplay.text = "";
        itemDescription.text = "";
        ReserveBidNowLabel.text = "";

        itemIdLabel.visible = false;
        categoryText.visible = false;
        descriptionText.visible = false;

        itemIDtext.visible = false;
        categoryDisplay.visible = false;
        itemDescription.visible = false;
        ReserveBidNowLabel.visible = false;

        imgHolderHightlight.dataProvider = null;

    }

    private function loadItemFile(itemInfo:XML):void {
        var countDownTimerComponent:countDownDisplay = countDownTimer as countDownDisplay;

        if (itemInfo == null) {
            itemInfo = new XML
        }

        var s:String;
        var s2:String;
        var s3:String;
        var s4:String;
        var node:XML = new XML();
        var itemInfoXML:XML = itemInfo;

        itemIdLabel.visible = true;
        categoryText.visible = true;
        descriptionText.visible = true;

        itemIDtext.visible = true;
        categoryDisplay.visible = true;
        itemDescription.visible = true;
        ReserveBidNowLabel.visible = true;


        itemTitle.text = itemInfoXML.itemName.toString();
        categoryDisplay.text = itemInfoXML.category.toString();
        itemIDtext.text = itemInfoXML.itemId.toString();

        s2 = itemInfoXML.reserveDollar.toString();
        s3 = itemInfoXML.buyNow.toString();

        if (s2 == "")
            s2 = "0";

        if (s2 == "0") {
            ReserveBidNowLabel.text = "";
        }
        else if ((s2 != "0") && (s3 == "false")) {
            ReserveBidNowLabel.text = "Reserve Not Met on Item";
        }
        else if ((s2 != "0") && (s3 == "true")) {
            ReserveBidNowLabel.text = "Buy Now Item Amount: $" + s2;
        }

        s = itemInfoXML.rtdescription;
        itemDescription.text = itemInfoXML.description;
        itemDescription.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);


        imgHolderHightlight.useVirtualLayout = false;
        imgHolderHightlight.dataProvider = null;
        imgHolderHightlight.validateNow();

        countDownTimerComponent.clear();
        var time:String = _auctionItemDBXML.isoTime.toString();
        countDownTimerComponent.auctionTime = Number(time);

        assignHighlightImagHolderToList(imgHolderHightlight, itemInfoXML);

    }


    private function assignHighlightImagHolderToList(list:List, _auctionInfoXML:XML):void {

        var s:String = _auctionInfoXML.auctionImages.toString();

        s = _auctionInfoXML.auctionImages.toString();
        if (s != "") {
            var xl:XMLList = XMLList(_auctionInfoXML.auctionImages.children());
            var xc:XMLListCollection = new XMLListCollection(xl);
            list.dataProvider = xc.list;
        }
        else {
            _auctionInfoXML.auctionImages = "";
        }

    }


}
}