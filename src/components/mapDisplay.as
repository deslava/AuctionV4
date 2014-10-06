package components {
import flash.events.Event;

import flashx.textLayout.conversion.TextConverter;

import mx.events.CloseEvent;
import mx.events.FlexEvent;

public class mapDisplay extends mapDisplayLayout {

    public function mapDisplay() {
        //TODO: implement function
        super();

        clearMapDisplay();

        //this.slowLoadingIFrameWithLoadIndicator.addEventListener(FlexEvent.CREATION_COMPLETE, slowLoadingIFrameWithLoadIndicator_creationCompleteHandler);
    }

    private var _auctionInfoXML:XML

    private var _auctionDBXML:XML;

    public function set auctionDBXML(value:XML):void {
        _auctionDBXML = value;
    }

    private var _auctionFileXML:XML;

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;
    }

    public function clearAuction():void {

        clearPage1();

    }

    public function syncronizeAuction():void {

        setUpAuctionFileData();
    }

    protected function setUpAuctionFileData():void {

        this.visible = true;


        _auctionInfoXML = _auctionFileXML;

        displayAuctionFile(_auctionInfoXML);

    }

    private function hideMap():void {
        slowLoadingIFrameWithLoadIndicator.visible = false;
        slowLoadingIFrameWithLoadIndicator.source = "";

        slowLoadingIFrameWithLoadIndicator.loadIFrame();
        slowLoadingIFrameWithLoadIndicator.validateDisplayList();
    }

    private function clearMapDisplay():void {
        _auctionDBXML = new XML();
        _auctionFileXML = new XML();
        _auctionInfoXML = new XML();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, clearMapDisplay_creationCompleteHandler);
        this.addEventListener(FlexEvent.HIDE, slowLoadingIFrameWithLoadIndicator_hideHandler);


    }

    private function hideComponent():void {
        this.visible = false;
        this.clearAuction();
    }

    private function clearPage1():void {
        clearPage1Data();
    }

    private function clearPage1Data():void {
        hideMap();
        mapDirectionsText.text = "";
    }

    private function displayAuctionFile(auctionFileXML:XML):void {
        var s:String;
        var search:String = 'scrolling="no"'
        var replace:String = 'scrolling="yes" overflow: -moz-scrollbars-vertical; overflow: scroll;'
        var t:String;
        s = auctionFileXML.googleMap;


        if (s != "") {
            s = heightWidthTo100(s);
            slowLoadingIFrameWithLoadIndicator.content = s;

            slowLoadingIFrameWithLoadIndicator.visible = true;
            this.slowLoadingIFrameWithLoadIndicator.addEventListener(Event.ENTER_FRAME, slowLoadingIFrameWithLoadIndicator_enterFrameHandler);
            this.slowLoadingIFrameWithLoadIndicator.addEventListener(FlexEvent.HIDE, slowLoadingIFrameWithLoadIndicator_hideHandler)
        }

        s = auctionFileXML.rtDirectionMap;
        mapDirectionsText.text = auctionFileXML.DirectionMap;
        mapDirectionsText.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);

    }

    private function strReplace(str:String, search:String, replace:String):String {
        return str.split(search).join(replace);
    }

    private function heightWidthTo100(s:String):String {


        var pattern:RegExp = / height="(\w+)" /i;
        var str:String = s;
        s = str.replace(pattern, " height=\"100%\" ");

        str = s;
        pattern = / width="(\w+)" /i;
        s = str.replace(pattern, " width=\"100%\" ");

        return s;


    }

    private function slowLoadingIFrameWithLoadIndicator_enterFrameHandler(event:Event):void {
        slowLoadingIFrameWithLoadIndicator.invalidateDisplayList();

    }

    private function slowLoadingIFrameWithLoadIndicator_hideHandler(event:FlexEvent):void {
        hideMap();
    }

    private function titlewindow1_closeHandler(event:CloseEvent):void {
        hideComponent();

    }

    private function clearMapDisplay_creationCompleteHandler(event:FlexEvent):void {
        this.mapHolder.addEventListener(CloseEvent.CLOSE, titlewindow1_closeHandler);


        clearPage1();
    }


}
}