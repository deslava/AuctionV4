package components {

import flash.display.InteractiveObject;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

import spark.components.DataGroup;
import spark.components.IItemRenderer;
import spark.components.List;

public dynamic class publicAuctionListClass extends List {
    public function publicAuctionListClass() {
        super();
        clearAuctionList();
    }

    private var _itemID:Number;
    private var _auctionID:Number;
    private var _auctionFileXML:XML;
    private var _auctionItemFileXML:XML;
    private var _selectedAuction:auctionDisplayInfo;

    public function syncronizeAuctionRenderer():void {

        var itemRenderer:IItemRenderer = selectedRenderer(this);

        if (itemRenderer == null)
            return;

        _selectedAuction = itemRenderer as auctionDisplayInfo;
        _selectedAuction;

        _itemID = _selectedAuction.itemID;
        _auctionID = _selectedAuction.auctionID;
        _auctionFileXML = _selectedAuction.auctionFileXML;
        _auctionItemFileXML = _selectedAuction.auctionItemFileXML;

    }

    public function publicAuctionClearList():void {

        this.dataProvider = null;
        clearAuctionList();

    }

    private function clearAuctionList():void {

        this.useVirtualLayout = false;
        this.dataProvider = null;

        _itemID = 0;
        _auctionID = 0;
        _selectedAuction = new auctionDisplayInfo();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);

    }

    private function selectedRenderer(displayList:List):IItemRenderer {
        var dataGroup:DataGroup = displayList.dataGroup;
        var itemRenderer:IItemRenderer = dataGroup.getElementAt(displayList.selectedIndex) as IItemRenderer;

        return itemRenderer;
    }

    private function creationComplete(event:FlexEvent):void {

        this.addEventListener(MouseEvent.CLICK, bubbleMouseEvent);
    }

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }

}
}