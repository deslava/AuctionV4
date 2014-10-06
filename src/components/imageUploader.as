package components {
import auctionFunctionsClass.auctionClass;
import auctionFunctionsClass.fileLoaderClass;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.net.URLRequest;
import flash.net.URLVariables;

import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.events.StateChangeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.events.GridSelectionEvent;

public class imageUploader extends imageUploaderLayout {
    private const _strUploadScript:String = "upload.php";

    public function imageUploader() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, imageUploader_creationCompleteHandler);

    }

    public var _auction:auctionClass = new auctionClass();
    public var myAlert:Alert;
    public var currSaveLocation:String;
    public var auctionsxmlFileLoader:HTTPService = new HTTPService();
    private var _strUploadFolder:String;
    private var _arrUploadFiles:Array = new Array();
    private var _numCurrentUpload:Number = 0;
    private var _refAddFiles:FileReferenceList;
    private var _refUploadFile:FileReference;
    private var auctionsfileLoader:fileLoaderClass = new fileLoaderClass();
    private var xmlFileLoader:HTTPService = new HTTPService();
    private var fileLoader:fileLoaderClass = new fileLoaderClass();

    private var _loginUserID:String;

    public function get loginUserID():String {
        return _loginUserID;
    }

    public function set loginUserID(value:String):void {
        _loginUserID = value;
    }

    private var _currentEditState:String = new String();

    public function get currentEditState():String {
        return _currentEditState;
    }

    public function set currentEditState(value:String):void {
        _currentEditState = value;
    }

    private var _auctionFileXML:XML = new XML();

    public function get auctionFileXML():XML {
        return _auctionFileXML;
    }

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;
    }

    private var _auctionItemFileXML:XML = new XML();

    public function get auctionItemFileXML():XML {
        _auctionItemFileXML = _auctionFileXML;
        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
        value;
        _auctionFileXML = _auctionItemFileXML;
    }

    public function imageThumbDownload(urlString:String):void {

        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageThumbDownloadVerify);

        var request:URLRequest = new URLRequest(urlString);
        var variables:URLVariables = new URLVariables();
        variables.nocache = new Date().getTime();
        request.data = variables;

        loader.load(request);

        FlexGlobals.topLevelApplication.enabled = false;
        myAlert = Alert.show("Loading Images Please Wait", "Loading", Alert.OK, this);
        //	myAlert.mx_internal::alertForm.removeChild(myAlert.mx_internal::alertForm.mx_internal::buttons[0]);


    }

    public function clear():void {


        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        addAuctionTab3Events();

        var t:XMLListCollection = new XMLListCollection();

        imageThumb.source = "assets/images/DEFAULT.png";

        imageFileHolder.dataProvider = null;
        imageFileHolder.dataProvider = t.list;
        imageFileHolder.validateDisplayList();


        imageUploadProg.setProgress(0, 100);
        imageUploadProg.label = 0 + "%";
        imageUploadProg.validateNow();

        loadAuction();

    }

    public function loadAuction():void {

        currSaveLocation = _auctionFileXML.path.toString();

        var xl:XMLList = XMLList(_auctionFileXML.auctionImages.children());
        var xc:XMLListCollection = new XMLListCollection(xl);
        imageFileHolder.dataProvider = xc.list;

    }

    public function saveFile():void {

        _auction.currentEditState = _currentEditState;
        _auction.saveAuction(_auctionFileXML);
        _auction.addEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.addEventListener(FaultEvent.FAULT, auctionSaveFail);

    }

    public function saveItemXMLFile():void {

    }

    public function itemsXML(obj:Object):void {

        var url:String;


        url = "itemsXML.php";

        xmlFileLoader = new HTTPService();
        fileLoader = new fileLoaderClass();

        xmlFileLoader = fileLoader.xmlFileLoader;

        xmlFileLoader.addEventListener(ResultEvent.RESULT, itemsXMLVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, itemsXMLFail);

        fileLoader.loadXML(url, obj);

    }

    protected function addAuctionTab3Events():void {

        imageFileHolder.addEventListener(GridSelectionEvent.SELECTION_CHANGE, imageFileHolder_selectionChangeHandler);
        SelectImages.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
        deleteImages.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
    }

    private function addImageFiles():void {
        _refAddFiles = new FileReferenceList();
        _refAddFiles.addEventListener(Event.SELECT, onSelectFile);
        _refAddFiles.browse();
    }

    private function deleteImageFiles():void {
        var t:int;


        if (imageFileHolder.selectedIndex == -1) {

            return;
        }

        else {

            t = imageFileHolder.selectedIndex;

            delete _auctionFileXML.auctionImages.image[t];

            var xl:XMLList = XMLList(_auctionFileXML.auctionImages.children());
            var xc:XMLListCollection = new XMLListCollection(xl);
            imageFileHolder.dataProvider = xc.list;

            imageThumb.source = "assets/images/DEFAULT.png";
        }


    }

    private function startUpload(booIsFirst:Boolean):void {
        if (booIsFirst) {
            _numCurrentUpload = 0;
        }
        if (_arrUploadFiles.length > 0) {

            var sendVars:URLVariables = new URLVariables();
            sendVars.action = "upload";
            sendVars.strUploadFolder = "/" + currSaveLocation;

            var request:URLRequest = new URLRequest();
            request.data = sendVars;
            request.url = _strUploadScript;
            request.method = "POST";
            _refUploadFile = new FileReference();
            _refUploadFile = _arrUploadFiles[_numCurrentUpload].data;
            _refUploadFile.addEventListener(ProgressEvent.PROGRESS, onUploadProgress);
            _refUploadFile.addEventListener(Event.COMPLETE, onUploadComplete);
            _refUploadFile.addEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
            _refUploadFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
            _refUploadFile.upload(request, "file", false);


            var node:XML = <image></image>;
            node.@file = currSaveLocation + _refUploadFile.name;
            node.@name = _refUploadFile.name;

            _auctionFileXML.auctionImages.appendChild(node);
            SelectImages.enabled = true;


        }
        FlexGlobals.topLevelApplication.enabled = false;

    }

    private function clearUpload():void {

        _arrUploadFiles = new Array();

        _numCurrentUpload = 0;
        _refUploadFile.removeEventListener(ProgressEvent.PROGRESS, onUploadProgress);
        _refUploadFile.removeEventListener(Event.COMPLETE, onUploadComplete);
        _refUploadFile.removeEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
        _refUploadFile.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
        _refUploadFile.cancel();
    }

    public function auctionPageBtn_clickHandler(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean;
        var node:XML;

        var obj:Object = new Object;

        if (name == "SelectImages") {
            addImageFiles();
        }

        if (name == "deleteImages") {
            deleteImageFiles();
        }
    }

    // Get upload progress

    public function imageFileHolder_selectionChangeHandler(event:GridSelectionEvent):void {
        var obj:Object;

        obj = imageFileHolder.selectedItem;

        var url:String = obj.@file;
        imageThumbDownload(url);

    }

    // Called on upload complete

    public function imageThumbDownloadVerify(event:Event):void {

        var loader:Loader = (event.target as LoaderInfo).loader;

        imageThumb.source = loader.content;


        FlexGlobals.topLevelApplication.enabled = true;
        //PopUpManager.removePopUp(myAlert);

    }

    // Called on upload io error

    public function itemsXMLFail(event:Event):void {


    }

    // Called on upload security error

    public function itemsXMLVerify(event:Event):void {

    }

    protected function addAuctionTab3State(event:StateChangeEvent):void {
        // TODO Auto-generated method stub
        addAuctionTab3Events();
    }

    private function imageUploader_creationCompleteHandler(event:FlexEvent):void {

        this.removeEventListener(FlexEvent.CREATION_COMPLETE, imageUploader_creationCompleteHandler);
        this.dispatchEvent(event);
        this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, addAuctionTab3State);

    }

    private function onSelectFile(event:Event):void {
        var arrFoundList:Array = new Array();


        if (_refAddFiles.fileList.length >= 1) {
            for (var k:Number = 0; k < _refAddFiles.fileList.length; k++) {
                _arrUploadFiles.push({label: _refAddFiles.fileList[k].name, data: _refAddFiles.fileList[k]});
            }
        }
        if (arrFoundList.length >= 1) {
            Alert.show("The file(s): \n\n• " + arrFoundList.join("\n• ") + "\n\n...are already on the upload list. Please change the filename(s) or pick a different file.", "File(s) already on list");
        }


        startUpload(true);

    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function onUploadCanceled(event:Event):void {

        _refUploadFile.cancel();
        clearUpload();
    }

    private function onUploadProgress(event:ProgressEvent):void {
        var numPerc:Number = Math.round((Number(event.bytesLoaded) / Number(event.bytesTotal)) * 100);

        imageUploadProg.setProgress(numPerc, 100);
        imageUploadProg.label = numPerc + "%";
        imageUploadProg.validateNow();

    }

    private function onUploadComplete(event:Event):void {
        _numCurrentUpload++;


        imageUploadProg.setProgress(0, 100);
        imageUploadProg.label = 0 + "%";
        imageUploadProg.validateNow();


        if (_numCurrentUpload < _arrUploadFiles.length) {
            startUpload(false);
        } else {
            Alert.show("File(s) have been uploaded.", "Upload successful");

            clearUpload();
            FlexGlobals.topLevelApplication.enabled = true;

            var xl:XMLList = XMLList(_auctionFileXML.auctionImages.children());
            var xc:XMLListCollection = new XMLListCollection(xl);
            imageFileHolder.dataProvider = xc.list;
            SelectImages.enabled = true;


        }
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    private function onUploadIoError(event:IOErrorEvent):void {
        Alert.show("IO Error in uploading file.", "Error");
        _refUploadFile.cancel();
        clearUpload();
    }

    private function onUploadSecurityError(event:SecurityErrorEvent):void {
        Alert.show("Security Error in uploading file.", "Error");
        _refUploadFile.cancel();
        clearUpload();
    }

    private function auctionSaveFail(event:FaultEvent):void {
        // TODO Auto-generated method stub
        _currentEditState = "New";

        _auction.removeEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionSaveFail);
    }

    private function auctionSaveVerify(event:ResultEvent):void {
        // TODO Auto-generated method stub
        _currentEditState = "Edit";
        _auction.currentEditState = "Edit";

        _auction.removeEventListener(ResultEvent.RESULT, auctionSaveVerify);
        _auction.removeEventListener(FaultEvent.FAULT, auctionSaveFail);


    }


}
}