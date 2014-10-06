package components {
import mx.events.FlexEvent;

public class auctionItemDisplay extends auctionItemDisplayLayout {
    public function auctionItemDisplay() {
        super();

        init();
    }

    private var _itemXML:XML;

    private function init():void {

        _itemXML = new XML();
        _itemXML = this.data as XML;


        this.addEventListener(FlexEvent.CREATION_COMPLETE, itemRender_creationHandler);
    }

    protected function itemRender_creationHandler(event:FlexEvent):void {
        _itemXML = this.data as XML;
        _itemXML;


        itemTitle.text = "";
        itemIDtext.text = "";
        categoryDisplay2.text = "";
        ReserveBidNowLabel.text = "";

        imageLoad.source = "";


        itemTitle.text = _itemXML.itemName;
        itemIDtext.text = _itemXML.itemId;
        categoryDisplay2.text = _itemXML.category;
        ReserveBidNowLabel.text = "";

        imageLoad.source = _itemXML.image.@file.toString();


    }
}
}