package components {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.URLVariables;

import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.FlexEvent;

import spark.components.List;

public class galleryDisplay extends galleryDisplayLayout {
    public function galleryDisplay() {
        //TODO: implement function
        super();
        clearMapDisplay()
    }

    private var _xmlFileInfo:XML;
    private var myAlert:Alert;

    private var _xmlFile:XML;

    public function set xmlFile(value:XML):void {
        _xmlFile = value;
    }

    public function clearAuction():void {

        clearPage1();

    }

    public function syncronizeAuction():void {

        setUpFileData();
    }

    private function clearMapDisplay():void {
        _xmlFile = new XML();
        _xmlFileInfo = new XML();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, clearGalleryDisplay_creationCompleteHandler);
        this.addEventListener(FlexEvent.HIDE, slowLoadingIFrameWithLoadIndicator_hideHandler);


    }

    private function hideVideo():void {

        slowLoadingIFrameWithLoadIndicator.source = "";
        slowLoadingIFrameWithLoadIndicator.visible = false;
        slowLoadingIFrameWithLoadIndicator.data = null;
        slowLoadingIFrameWithLoadIndicator.cacheAsBitmap = true;

        slowLoadingIFrameWithLoadIndicator.loadIFrame();
        slowLoadingIFrameWithLoadIndicator.validateDisplayList();


    }

    private function hideComponent():void {
        this.visible = false;
        this.clearAuction();
    }

    private function clearPage1():void {
        clearPage1Data();
    }

    private function clearPage1Data():void {
        hideVideo();
        imgHolderHightlight.dataProvider = null;
        imageThumb.source = "assets/images/DEFAULT.png";
    }

    private function setUpFileData():void {

        this.visible = true;
        var i:int = 0;
        _xmlFileInfo = _xmlFile;
        displayFile();

    }

    private function displayFile():void {
        var s:String;

        imgHolderHightlight.useVirtualLayout = false;


        s = _xmlFileInfo.youtubeVideo.toString();

        if (s != "") {
            slowLoadingIFrameWithLoadIndicator.source = s;
            slowLoadingIFrameWithLoadIndicator.loadIFrame();
            slowLoadingIFrameWithLoadIndicator.validateDisplayList();
            slowLoadingIFrameWithLoadIndicator.visible = true;
            imageThumb.visible = false;
            showVideoBtn.label = "Hide Video";
        }
        else {
            hideVideo();
            showVideoBtn.label = "Show Video";
            showVideoBtn.visible = false;
        }

        assignHighlightImagHolderToList(imgHolderHightlight);
        this.visible = true;
    }

    private function assignHighlightImagHolderToList(list:List):void {

        var s:String = _xmlFileInfo.auctionImages.toString();

        s = _xmlFileInfo.auctionImages.toString();
        if (s != "") {
            var xl:XMLList = XMLList(_xmlFileInfo.auctionImages.children());
            var xc:XMLListCollection = new XMLListCollection(xl);
            list.dataProvider = xc.list;
        }
        else {
            _xmlFileInfo.auctionImages = "";
        }


    }

    private function imageThumbDownload(urlString:String):void {

        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageThumbDownloadVerify);

        var request:URLRequest = new URLRequest(urlString);
        var variables:URLVariables = new URLVariables();
        variables.nocache = new Date().getTime();
        request.data = variables;

        loader.load(request);

        /*	mx.core.FlexGlobals.topLevelApplication.enabled = false;
         myAlert = Alert.show("Loading Images Please Wait", "Loading", Alert.OK, this);
         myAlert.mx_internal::alertForm.removeChild(myAlert.mx_internal::alertForm.mx_internal::buttons[0]);*/


    }

    private function titlewindow1_closeHandler(event:CloseEvent):void {
        hideComponent();

    }

    private function clearGalleryDisplay_creationCompleteHandler(event:FlexEvent):void {
        this.galleryHolder.addEventListener(CloseEvent.CLOSE, titlewindow1_closeHandler);
        this.imgHolderHightlight.addEventListener(MouseEvent.CLICK, imgHolderHightlight_clickHandler);
        this.showVideoBtn.addEventListener(MouseEvent.CLICK, showVideoBtn_clickHandler);
        this.slowLoadingIFrameWithLoadIndicator.addEventListener(Event.ENTER_FRAME, slowLoadingIFrameWithLoadIndicator_enterFrameHandler);

        clearPage1();
    }

    private function slowLoadingIFrameWithLoadIndicator_enterFrameHandler(event:Event):void {
        slowLoadingIFrameWithLoadIndicator.invalidateDisplayList();

    }

    private function slowLoadingIFrameWithLoadIndicator_hideHandler(event:FlexEvent):void {
        hideVideo();
    }

    private function imgHolderHightlight_clickHandler(event:MouseEvent):void {
        var obj:Object;

        obj = imgHolderHightlight.selectedItem;

        if (obj == null)
            return;

        var url:String = obj.@file;
        imageThumbDownload(url);

        if (slowLoadingIFrameWithLoadIndicator.visible == true) {
            slowLoadingIFrameWithLoadIndicator.visible = false;
            showVideoBtn.visible = true;
            showVideoBtn.label = "View Video";
            imageThumb.visible = true;

        }

    }

    private function imageThumbDownloadVerify(event:Event):void {

        var loader:Loader = (event.target as LoaderInfo).loader;

        imageThumb.source = loader.content;


        /*mx.core.FlexGlobals.topLevelApplication.enabled = true;
         PopUpManager.removePopUp(myAlert);*/

    }

    private function showVideoBtn_clickHandler(event:MouseEvent):void {
        if (slowLoadingIFrameWithLoadIndicator.visible == false) {
            slowLoadingIFrameWithLoadIndicator.visible = true;
            showVideoBtn.visible = true;
            showVideoBtn.label = "Hide Video";
            imageThumb.visible = false;

        }
        else if (slowLoadingIFrameWithLoadIndicator.visible == true) {
            slowLoadingIFrameWithLoadIndicator.visible = false;
            showVideoBtn.visible = true;
            showVideoBtn.label = "View Video";
            imageThumb.visible = true;

        }
    }
}
}