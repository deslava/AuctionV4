package components {
import auctionFunctionsClass.auctionItemClass;
import auctionFunctionsClass.fileLoaderClass;
import auctionFunctionsClass.sellerClass;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.XMLListCollection;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import spark.components.DropDownList;
import spark.events.IndexChangeEvent;

public class itemAdd extends itemAddLayout {
    public function itemAdd() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, addAuctionItemTab1_creationCompleteHandler);
    }

    public var auctionsxmlFileLoader:HTTPService = new HTTPService();
    private var _loginUserID:String = new String();
    private var _userDBXML:XML = new XML();
    private var _auctionItemDBXML:XML;
    private var _auctionSellerLists:XML = new XML();
    private var _auctionSellerFileXML:XML = new XML();
    private var _statesXML:XML;
    private var _feeLoaderXML:XML = new XML();
    private var _auctionItem:auctionItemClass;
    private var itemCategoriesXML:XML = new XML();
    private var tempXML:XML = new XML();
    private var tempUpdateXML:XML = new XML();
    private var xmlItemCategoriesLoader:HTTPService = new HTTPService();
    private var itemCategoryFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _xmlStatesLoader:HTTPService = new HTTPService();
    private var _stateFileLoader:fileLoaderClass = new fileLoaderClass();
    private var sellerXmlFileLoader:HTTPService = new HTTPService();
    private var sellerFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _xmlFeesFileLoader:fileLoaderClass = new fileLoaderClass();
    private var _xmlFeesLoader:HTTPService = new HTTPService();
    private var _editSeller:Boolean = false;
    private var _xc:XMLListCollection;
    private var xc:XMLListCollection;
    private var xc1:XMLListCollection;
    private var xc2:XMLListCollection = new XMLListCollection();
    private var xc3:XMLListCollection = new XMLListCollection();
    private var xc4:XMLListCollection = new XMLListCollection();
    private var xc5:XMLListCollection = new XMLListCollection();
    private var xc6:XMLListCollection = new XMLListCollection();
    private var auctionsfileLoader:fileLoaderClass = new fileLoaderClass();
    private var _seller:sellerClass = new sellerClass();
    private var _item:auctionItemClass = new auctionItemClass();

    private var _currentEditState:String = "New";

    public function get currentEditState():String {
        return _currentEditState;
    }

    public function set currentEditState(value:String):void {
        _currentEditState = value;
    }

    private var _auctionID:Number = -1;

    public function get auctionID():Number {
        return _auctionID;
    }

    public function set auctionID(value:Number):void {
        _auctionID = value;
    }

    private var _auctionFileXML:XML = new XML();

    public function get auctionFileXML():XML {
        return _auctionFileXML;
    }

    public function set auctionFileXML(value:XML):void {
        _auctionFileXML = value;

        _auctionID = _auctionFileXML.id;
    }

    private var _auctionItemFileXML:XML;

    public function get auctionItemFileXML():XML {
        return _auctionItemFileXML;
    }

    public function set auctionItemFileXML(value:XML):void {
        _auctionItemFileXML = value;
    }

    public function clear():void {

        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        clearTab1();
        addAuctionItemTabEvents();

        if (_currentEditState == "New")
            saveItemAddBtn.visible = true;
        else
            saveItemAddBtn.visible = false;
    }


    //////////////////////////////////////////////////////////////////////////

    public function saveFile():void {
        this.enabled = false;
        _auctionItemFileXML = getItemFile();
        _item.currentEditState = _currentEditState;
        _item.auctionID = _auctionID;
        _item.auctionFileXML = _auctionFileXML;
        _item.addEventListener(ResultEvent.RESULT, itemFileXMLVerify);
        _item.addEventListener(FaultEvent.FAULT, itemFileXMLFail);

        _item.saveItem(_auctionItemFileXML);

    }

    public function clearSeller():void {
        addAuctionItemTabEvents();

        loadStatesXML();
        loadFeeCategories();
        loadAuctionFeeType();
        assignFeeCategories();

        nameP9.text = "";
        emailP9.text = "";
        streetAuctionTab.text = "";
        cityAuctionTab.text = "";
        zipAuctionTab.text = "";
        feeAmountItem.text = "";

        var t:XMLListCollection = new XMLListCollection();
        auctionItemFeeHolder.dataProvider = null;
        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();

        loadFeesTable();
        assignFeeTable();


    }

    public function clearTab1():void {

        this.currentState = "addItem";

        _auctionSellerLists = new XML();
        _auctionSellerFileXML = new XML();

        _statesXML = new XML();

        _feeLoaderXML = new XML();

        _auctionItem = new auctionItemClass();

        itemCategoriesXML = new XML();

        tempXML = new XML();
        tempUpdateXML = new XML();

        xmlItemCategoriesLoader = new HTTPService();
        itemCategoryFileLoader = new fileLoaderClass();

        _xmlStatesLoader = new HTTPService();
        _stateFileLoader = new fileLoaderClass();

        sellerXmlFileLoader = new HTTPService();
        sellerFileLoader = new fileLoaderClass();

        _xmlFeesFileLoader = new fileLoaderClass();
        _xmlFeesLoader = new HTTPService();

        _editSeller = false;

        _xc = new XMLListCollection();

        xc = new XMLListCollection();
        xc1 = new XMLListCollection();
        xc2 = new XMLListCollection();
        xc3 = new XMLListCollection();
        xc4 = new XMLListCollection();
        xc5 = new XMLListCollection();
        xc6 = new XMLListCollection();

        auctionsxmlFileLoader = new HTTPService();
        auctionsfileLoader = new fileLoaderClass();

        _seller = new sellerClass();
        _item = new auctionItemClass();

        itemName.text = "";
        itemCategories.selectedIndex = -1;
        itemCategories.tabIndex = -1;

        itemInitalBidDollar.text = "0";
        itemInitalBidCents.value = 0;
        itemReserveBidDollar.text = "0";
        itemReserveBidCents.value = 0;
        itemQuantity.value = 1;
        optionBuyNow.selected = false;

        itemSeller.selectedIndex = -1;
        itemSeller.tabIndex = -1;

        richTextEditorItem1.text = "";
        richTextEditorItem1.htmlText = "";

        this.invalidateDisplayList();

        loadItemCategories();
        loadSellersLists();
        loadAuctionItemXML();
    }

    public function clearTab2():void {

        addAuctionItemTabEvents();

        newItemCategory.text = "";
        errorItemTypeLabel.text = "";
        itemCategoryHolder.dataProvider = xc2.list;
    }

    public function clearTab4():void {

        addAuctionItemTabEvents();

        feeNameDropDown.selectedIndex = -1;
        feeAmountItem.text = "";
        feeTypeDropDown.selectedIndex = -1;
        assignFeeCategories();

    }

    public function assignItem():void {

        if (_currentEditState == "New")
            saveItemAddBtn.visible = true;
        else {
            saveItemAddBtn.visible = false;
        }


        itemName.text = _auctionItemFileXML.itemName;
        itemInitalBidDollar.text = _auctionItemFileXML.initialDollarBid;
        itemInitalBidCents.value = _auctionItemFileXML.initialCentsBid;
        itemReserveBidDollar.text = _auctionItemFileXML.reserveDollar;
        itemReserveBidCents.value = _auctionItemFileXML.reserveCents;
        itemQuantity.value = _auctionItemFileXML.quantity;

        if (_auctionItemFileXML.buyNow == "true")
            optionBuyNow.selected = true;
        else
            optionBuyNow.selected = false;

        itemCategories.tabIndex = itemCategories.selectedIndex;
        itemSeller.tabIndex = itemSeller.selectedIndex;


        richTextEditorItem1.text = _auctionItemFileXML.description;
        richTextEditorItem1.htmlText = _auctionItemFileXML.rtdescription;

        _auctionItemFileXML;

        assignItemCategories();
        assignSellerLists();

    }

    public function loadItemCategories():void {

        var obj:Object = new Object();
        obj.searchVar = "";
        obj.table1 = "Load";
        ItemCategoryXML(obj);

    }

    public function ItemCategoryXML(obj:Object):void {

        var url:String;
        url = "itemsCategories.php";

        xmlItemCategoriesLoader = itemCategoryFileLoader.xmlFileLoader;
        xmlItemCategoriesLoader.addEventListener(ResultEvent.RESULT, ItemCategoryVerify);
        xmlItemCategoriesLoader.addEventListener(FaultEvent.FAULT, itemCategoryFileFail);

        itemCategoryFileLoader.loadXML(url, obj);

    }

    public function itemCategoryFileValid():void {

        var obj:Object = new Object();
        var t:String;
        var i:int;

        if (itemCategoriesXML.toString() == "ok") {
            obj = blankOutObjVar(obj);
            obj.table1 = "Load";
            ItemCategoryXML(obj);
        }
        else if (itemCategoriesXML.toString() == "Error") {

        }

        else {

            assignItemCategories();

        }

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public function assignItemCategories():void {


        if (this.currentState == "addItem") {
            itemCategories.dataProvider = xc2.list;
            itemCategories.selectedIndex = -1;

            if (_auctionItemFileXML != null) {
                itemCategories.selectedIndex = valueTabSearch(itemCategories, _auctionItemFileXML.category);
            }

        }

        else if (this.currentState == "addCategory") {
            itemCategoryHolder.dataProvider = xc2.list;
            itemCategoryHolder.selectedIndex = -1;
        }
    }

    public function loadSellersLists():void {

        if (_auctionID == -1)
            return;

        var obj:Object = new Object();
        obj = blankOutObjVar(obj);
        obj.searchVar = _auctionID;
        obj.table1 = "Load";
        loaditemSellerList(obj);

    }

    public function loaditemSellerList(obj:Object):void {
        var url:String;
        url = "sellersListXML.php";

        sellerXmlFileLoader = sellerFileLoader.xmlFileLoader;
        sellerXmlFileLoader.addEventListener(ResultEvent.RESULT, loaditemSellerListVerify);
        sellerXmlFileLoader.addEventListener(FaultEvent.FAULT, loaditemSellerListFail);

        sellerFileLoader.loadXML(url, obj);
    }

    public function loadSellerListValid():void {

        if (this.currentState == "addSeller") {
            this.currentState = "addItem";
            assignSellerLists()

        }
        else if (this.currentState == "addItem") {

            assignSellerLists();

        }


    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public function loadFeeCategories():void {


        var obj:Object = new Object();
        obj = blankOutObjVar(obj);
        obj.table1 = "LoadSellerFee";
        auctionFeesXML(obj);

    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    public function auctionFeeVerifyValid():void {
        var obj:Object = new Object();
        var t:String;

        if (_feeLoaderXML.toString() == "ok") {
            loadFeeCategories();

        }

        else if (_feeLoaderXML.toString() == "Error") {
            errorEventFeeLabel.text = "That Category Already Exists";
        }

        else {
            feeCategoriesXML(_feeLoaderXML);
            assignFeeCategories();

        }


    }

    public function loadAuctionFeeType():void {
        var auctionFeeTypesXML:XML = <Types>
            <type id="$">$ Dollar</type>
            <type id="%">% Percent</type>
        </Types>;

        var productAttributes:XMLList = auctionFeeTypesXML.type.children();
        var xl:XMLList = XMLList(productAttributes);
        xc5 = new XMLListCollection(xl);

    }

    public function feeCategoriesXML(xml:XML):void {

        var productAttributes:XMLList = xml.children();
        var xl:XMLList = XMLList(productAttributes);
        xc3 = new XMLListCollection(xl);

        assignFeeCategories();

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function saveSellerXMLFile():void {

        this.enabled = false;

        _seller.auctionSellerFileXML = getSellerFile();
        _seller.auctionFileXML = _auctionFileXML;
        _seller.auctionID = auctionID;
        _seller.saveSeller();

        _seller.addEventListener(ResultEvent.RESULT, saveSellerXMLVerify);
        _seller.addEventListener(FaultEvent.FAULT, saveSellerXMLFail);
    }

    public function sellersXMLValid():void {


        if (this.currentState == "addItem") {
            _auctionSellerFileXML;
        }

        if (this.currentState == "addSeller") {
            _editSeller = true;
            loadSellerXML();

        }

    }

    public function loadItemSellerSelected(i:int):void {
        var url:String = "";
        var node:XML = new XML();

        if (i == -1)
            return;

        node = _auctionSellerLists.Seller[i];

        url = node.info_xml;

        _seller.auctionSellerDBXML = node;
        _seller.loadSellerFile(url);

        _seller.addEventListener(ResultEvent.RESULT, saveSellerXMLVerify);
        _seller.addEventListener(FaultEvent.FAULT, saveSellerXMLFail);

    }

    public function loadSellerXML():void {

        _auctionSellerFileXML = _seller.auctionSellerFileXML;

        _auctionSellerFileXML.normalize();

        nameP9.text = _auctionSellerFileXML.userName.toString();
        emailP9.text = _auctionSellerFileXML.email.toString();
        streetAuctionTab.text = _auctionSellerFileXML.address.toString();
        cityAuctionTab.text = _auctionSellerFileXML.city.toString();
        zipAuctionTab.text = _auctionSellerFileXML.zipcode.toString();
        feeAmountItem.text = "";

        if (_editSeller == false) {
            tempXML = _auctionFileXML.copy();
            saveSellerBtn.visible = true;
            updateSellerBtn.visible = false;
        }
        else if (_editSeller == true) {
            tempXML = _auctionSellerFileXML.copy();
            saveSellerBtn.visible = false;
            updateSellerBtn.visible = true;

        }

        var xl:XMLList = XMLList(tempXML.auctionFees.children());
        xc4 = new XMLListCollection(xl);
        auctionItemFeeHolder.dataProvider = xc4.list;
        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();

        houseIDstates.selectedIndex = valueTabSearch(houseIDstates, _auctionSellerFileXML.state);
    }

    public function getItemFile():XML {
        var pass:Boolean = false;

        _auctionItemFileXML.dropDown[0] = itemSeller.selectedItem;
        _auctionItemFileXML.sellerId = _auctionSellerLists.userId.toString();
        _auctionItemFileXML.sellerType = "Seller";
        _auctionItemFileXML.auctionId = _auctionID;
        _auctionItemFileXML.itemName = itemName.text;
        _auctionItemFileXML.initialDollarBid = itemInitalBidDollar.text;
        _auctionItemFileXML.initialCentsBid = itemInitalBidCents.value;
        _auctionItemFileXML.reserveDollar = itemReserveBidDollar.text;
        _auctionItemFileXML.reserveCents = itemReserveBidCents.value;
        _auctionItemFileXML.quantity = itemQuantity.value;

        if (optionBuyNow.selected == true)
            _auctionItemFileXML.buyNow = "true";
        else
            _auctionItemFileXML.buyNow = "false";

        _auctionItemFileXML.category = itemCategories.selectedItem.toString();

        _auctionItemFileXML.description = richTextEditorItem1.text;
        _auctionItemFileXML.rtdescription = richTextEditorItem1.htmlText;
        _auctionItemFileXML.auction_path = _auctionFileXML.path.toString();

        return _auctionItemFileXML;
    }

    private function addAuctionItemTabEvents():void {
        if (currentState == "addItem") {
            saveItemAddBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            itemSeller.addEventListener(IndexChangeEvent.CHANGE, sellerTab_changeHandler);

            itemCategoriesBtn.addEventListener(MouseEvent.CLICK, itemCategoriesBtn_clickHandler);
            itemSellerBtn.addEventListener(MouseEvent.CLICK, itemSellerBtn_clickHandler);
            sellerEditBtn.addEventListener(MouseEvent.CLICK, itemUpdateSellerBtn_clickHandler);


        }
        else if (currentState == "addCategory") {
            eventItemCreateBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            itemsCategoryPanel.addEventListener(CloseEvent.CLOSE, eventTypePnl_closeHandler)

        }
        else if (currentState == "addSeller") {
            saveSellerBtn.addEventListener(MouseEvent.CLICK, clickFunction);
            updateSellerBtn.addEventListener(MouseEvent.CLICK, clickFunction);

            addSellerPanel.addEventListener(CloseEvent.CLOSE, title_closeHandler);

            auctionItemFeeAddBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);
            deleteFeeBtn.addEventListener(MouseEvent.CLICK, auctionPageBtn_clickHandler);

            addFeeBtn.addEventListener(MouseEvent.CLICK, addFeeBtn_clickHandler);

        }
        else if (currentState == "addFeeType") {
            eventFeeCreateBtn.addEventListener(MouseEvent.CLICK, clickFunction);

            eventTypePnl.addEventListener(CloseEvent.CLOSE, eventTypePnl2_closeHandler);

        }


    }

    private function loadAuctionItemXML():void {

        if (_currentEditState == "New") {
            _auctionItem = new auctionItemClass();
            _auctionItem.addEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
            _auctionItem.addEventListener(FaultEvent.FAULT, auctionItemXMLFail);
            _auctionItem.createItem();
        }
        else {
            _auctionItem.auctionFileXML = _auctionFileXML;
            assignItem();
        }

    }


    /////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignItemCategoriesList():void {

        var productAttributes:XMLList = itemCategoriesXML.children();
        var xl:XMLList = XMLList(productAttributes);
        xc2 = new XMLListCollection(xl);


    }

    private function getSellerFile():XML {
        _auctionSellerFileXML.auctionId = _auctionID;
        _auctionSellerFileXML.userName = nameP9.text.toString();
        _auctionSellerFileXML.email = emailP9.text.toString();
        _auctionSellerFileXML.state = houseIDstates.selectedItem.toString();
        _auctionSellerFileXML.address = streetAuctionTab.text.toString();
        _auctionSellerFileXML.city = cityAuctionTab.text.toString();
        _auctionSellerFileXML.zipcode = zipAuctionTab.text.toString();
        _auctionSellerFileXML.phone = phoneAuctionTab.text.toString();

        _auctionSellerFileXML.auctionFees = tempXML.auctionFees;
        _auctionSellerFileXML.normalize();

        return _auctionSellerFileXML;
    }

    private function assignSellerLists():void {

        if (_auctionSellerLists == null)
            return;

        var productAttributes:XMLList = _auctionSellerLists.Seller.dropDown;
        var xl:XMLList = XMLList(productAttributes);
        xc3 = new XMLListCollection(xl);

        itemSeller.dataProvider = xc3.list;

        if (_auctionItemFileXML != null) {
            itemSeller.selectedIndex = valueTabSearch(itemSeller, _auctionItemFileXML.dropDown);

            var i:int = itemSeller.selectedIndex;

            loadItemSellerSelected(i);

        }
    }

    private function loadStatesXML():void {

        var url:String = "fileRead.php";
        var obj:Object = new Object();
        obj.fileName = "UsStates.xml";

        _xmlStatesLoader = _stateFileLoader.xmlFileLoader;

        _xmlStatesLoader.addEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        _xmlStatesLoader.addEventListener(FaultEvent.FAULT, loadStatesXMLFail);

        _stateFileLoader.loadXML(url, obj);


    }

    private function loadStates():void {

        var productAttributes:XMLList = _statesXML.state.attribute("label");
        var xl:XMLList = XMLList(productAttributes);
        _xc = new XMLListCollection(xl);

        assignStates();
    }

/////////////////////////////////////////////////////////////////////////////////////////////////

    private function assignStates():void {
        if (_xc == null)
            return;

        houseIDstates.dataProvider = _xc.list;

        if (_editSeller == true)
            houseIDstates.selectedIndex = valueTabSearch(houseIDstates, _auctionFileXML.auctionState);

    }

    private function auctionFeesXML(obj:Object):void {
        var url:String;
        url = "feeCategories.php";

        _xmlFeesLoader = _xmlFeesFileLoader.xmlFileLoader;
        _xmlFeesLoader.addEventListener(ResultEvent.RESULT, auctionFeesVerify);
        _xmlFeesLoader.addEventListener(FaultEvent.FAULT, auctionFeesFail);

        _xmlFeesFileLoader.loadXML(url, obj);

    }

    private function assignFeeCategories():void {
        if (this.currentState == "addSeller") {
            feeNameDropDown.dataProvider = xc3.list;
            feeNameDropDown.selectedIndex = -1;

            feeTypeDropDown.dataProvider = xc5.list;
            feeTypeDropDown.selectedIndex = -1;

        }
        if (this.currentState == "addFeeType") {
            auctionFeeCategoryHolder.dataProvider = xc3.list;
            auctionFeeCategoryHolder.selectedIndex = -1;
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////

    private function loadFeesTable():void {


        var xl:XMLList = XMLList(_auctionFileXML.auctionFees.children());
        xc6 = new XMLListCollection(xl);

    }

    private function assignFeeTable():void {

        auctionItemFeeHolder.dataProvider = xc6.list;


        auctionItemFeeHolder.validateNow();
        auctionItemFeeHolder.validateDisplayList();
    }

    private function blankOutObjVar(obj:Object):Object {

        obj.searchVar = "";
        obj.table1 = "";


        return(obj);

    }

    private function valueTabSearch(list:DropDownList, searchVar:String):int {

        var x:int = 0;
        var obj:Object = list.dataProvider;


        if (obj == null) {
            x = -1;
            return x;
        }

        var xl:XMLList = obj.source as XMLList;
        var s:String;

        for (x = 0; x < xl.length(); x++) {
            s = xl[x].toString();

            if (s == searchVar)
                return x;

        }

        return (-1);

    }

    public function clickFunction(event:MouseEvent):void {
        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;

        var obj:Object = new Object();

        if (name == "saveItemAddBtn") {

            saveFile();
            bubbleMouseEvent(event);
        }


        if (name == "saveSellerBtn") {

            _seller.currentEdit = false;
            saveSellerXMLFile();


        }


        if (name == "updateSellerBtn") {

            _seller.currentEdit = true;
            saveSellerXMLFile()
        }

        if (name == "eventItemCreateBtn") {
            obj = blankOutObjVar(obj);
            obj.searchVar = newItemCategory.text;
            obj.table1 = "Add";
            ItemCategoryXML(obj);
        }


        if (name == "eventFeeCreateBtn") {
            errorEventFeeLabel.text = "";

            if (newFeeCategory.text.length < 4) {
                errorEventFeeLabel.text = "Enter a Valid Event Type";
                return;
            }

            obj = blankOutObjVar(obj);
            obj.searchVar = newFeeCategory.text;
            obj.table1 = "AddSellerFee";
            auctionFeesXML(obj);

        }

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public function auctionItemXMLFail(event:FaultEvent):void {

        var obj:Object;

        obj = XML(event.fault);
        obj;

        _auctionItem.removeEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _auctionItem.removeEventListener(FaultEvent.FAULT, auctionItemXMLFail);

        this.dispatchEvent(event);

    }

    public function auctionItemXMLVerify(event:ResultEvent):void {

        var obj:Object;
        var xml:XML;

        obj = XML(event.result);
        _auctionItem.removeEventListener(ResultEvent.RESULT, auctionItemXMLVerify);
        _auctionItem.removeEventListener(FaultEvent.FAULT, auctionItemXMLFail);

        xml = _auctionItem.auctionItemFileXML;

        var node:XML;
        node = obj.item[0] as XML;

        if (node != null) {
            _auctionItemFileXML = node;
            assignItem();
            this.dispatchEvent(event);
            return;
        }
    }

    public function ItemCategoryVerify(event:Event):void {


        itemCategoriesXML = new XML();
        itemCategoriesXML = XML(xmlItemCategoriesLoader.lastResult);
        xmlItemCategoriesLoader.removeEventListener(ResultEvent.RESULT, ItemCategoryVerify);
        xmlItemCategoriesLoader.removeEventListener(FaultEvent.FAULT, itemCategoryFileFail);

        assignItemCategoriesList();

        itemCategoryFileValid();


    }

    public function loaditemSellerListFail(event:FaultEvent):void {


    }

    public function loaditemSellerListVerify(event:ResultEvent):void {

        var responseXML:XML = XML(event.result);
        _auctionSellerLists = responseXML;

        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, loaditemSellerListVerify);
        sellerXmlFileLoader.removeEventListener(ResultEvent.RESULT, loaditemSellerListFail);

        loadSellerListValid();

    }

    public function sellerTab_changeHandler(event:IndexChangeEvent):void {
        var currSelection:Object = event.currentTarget;

        var i:int = currSelection.selectedIndex;

        loadItemSellerSelected(i);

    }

    public function saveSellerXMLVerify(event:ResultEvent):void {

        this.enabled = true;

        var obj:Object;

        obj = XML(event.result);

        var node:XML;
        node = obj.seller[0] as XML;

        if (node != null) {
            _auctionSellerFileXML = node;
        }

        _seller.removeEventListener(ResultEvent.RESULT, saveSellerXMLVerify);
        _seller.removeEventListener(FaultEvent.FAULT, saveSellerXMLFail);

        sellersXMLValid();

    }

    protected function addAuctionItemTab1_creationCompleteHandler(event:Event):void {
        this.removeEventListener(FlexEvent.CREATION_COMPLETE, addAuctionItemTab1_creationCompleteHandler);
        this.dispatchEvent(event);

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function itemFileXMLFail(event:FaultEvent):void {
        // TODO Auto-generated method stub

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////

    protected function itemFileXMLVerify(event:ResultEvent):void {
        // TODO Auto-generated method stub
        event;

        this.enabled = true;
        _currentEditState = "Edit";
        loadAuctionItemXML();
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function itemUpdateSellerBtn_clickHandler(event:MouseEvent):void {
        // TODO Auto-generated method stub
        if (itemSeller.selectedIndex == -1)
            return;

        _editSeller = true;
        this.currentState = "addSeller";
        clearSeller();
        loadSellerXML();

    }

    protected function itemCategoriesBtn_clickHandler(event:MouseEvent):void {
        this.currentState = "addCategory";
        clearTab2();
    }

    protected function itemSellerBtn_clickHandler(event:MouseEvent):void {
        // TODO Auto-generated method stub
        _editSeller = false;
        this.currentState = "addSeller";
        clearSeller();
        _seller.createSeller();
        loadSellerXML();

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////

    protected function itemCategoryFileFail(event:FaultEvent):void {
        var obj:Object;

        obj = XML(event.fault);
        obj;

        xmlItemCategoriesLoader.removeEventListener(ResultEvent.RESULT, ItemCategoryVerify);
        xmlItemCategoriesLoader.removeEventListener(FaultEvent.FAULT, itemCategoryFileFail);

    }

    protected function addFeeBtn_clickHandler(event:MouseEvent):void {
        // TODO Auto-generated method stub
        this.currentState = "addFeeType";
        clearTab4();
        assignFeeCategories();

        updateSellerBtn.visible = false;
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////

    protected function eventTypePnl_closeHandler(event:CloseEvent):void {
        // TODO Auto-generated method stub
        this.currentState = "addItem";
        assignItemCategories();


    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function eventTypePnl2_closeHandler(event:CloseEvent):void {
        // TODO Auto-generated method stub
        this.currentState = "addSeller";
        //assignFeeCategories();


    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function title_closeHandler(event:CloseEvent):void {
        // TODO Auto-generated method stub
        _editSeller = false;
        this.currentState = "addItem";
        loadSellersLists();

    }

    protected function saveSellerXMLFail(event:FaultEvent):void {
        this.enabled = true;

        _seller.removeEventListener(ResultEvent.RESULT, saveSellerXMLVerify);
        _seller.removeEventListener(FaultEvent.FAULT, saveSellerXMLFail);
    }

    private function loadStatesXMLFail(event:Event):void {

        var obj:Object = new Object();

        obj = _xmlStatesLoader.lastResult;

        _xmlStatesLoader.removeEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        _xmlStatesLoader.removeEventListener(FaultEvent.FAULT, loadStatesXMLFail);

    }

    private function loadStatesXMLVerify(event:Event):void {

        var obj:Object = new Object();
        obj = _xmlStatesLoader.lastResult;

        _statesXML = new XML();
        var s:String;
        _statesXML = XML(_xmlStatesLoader.lastResult);

        _xmlStatesLoader.removeEventListener(ResultEvent.RESULT, loadStatesXMLVerify);
        _xmlStatesLoader.removeEventListener(FaultEvent.FAULT, loadStatesXMLFail);

        loadStates();
    }

    private function auctionFeesFail(event:Event):void {

        _xmlFeesLoader.removeEventListener(ResultEvent.RESULT, auctionFeesVerify);
        _xmlFeesLoader.removeEventListener(FaultEvent.FAULT, auctionFeesFail);
    }

    private function auctionFeesVerify(event:Event):void {

        _feeLoaderXML = new XML();
        _feeLoaderXML = XML(_xmlFeesLoader.lastResult);
        _xmlFeesLoader.removeEventListener(ResultEvent.RESULT, auctionFeesVerify);
        _xmlFeesLoader.removeEventListener(FaultEvent.FAULT, auctionFeesFail);
        auctionFeeVerifyValid();

    }


    //////////////////////////////////////////////////////////////////////////////////////////////////

    private function auctionPageBtn_clickHandler(event:MouseEvent):void {

        var currBtn:Object = event.currentTarget;
        var name:String = currBtn.id;
        var pass:Boolean = false;
        var t:int;

        if (name == "auctionItemFeeAddBtn") {
            var node:XML = new XML();
            node = <fee id="" type="" amount="" display="" applyTo=""/>;

            node.@id = feeNameDropDown.selectedItem;
            node.@type = feeTypeDropDown.selectedItem;
            node.@amount = feeAmountItem.text;

            if (node.@type == "% Percent") {
                node.@display = node.@amount + " " + "%";
            }
            else if (node.@type == "$ Dollar") {
                node.@display = "$" + node.@amount;
            }

            if (this.id == "addAuctionTab9")
                node.@applyTo = "Auction";

            else if (this.id == "addItem1")
                node.@applyTo = "Seller";

            else if (this.id == "addItem3")
                node.@applyTo = "Item";


            var node3:XML = _auctionFileXML;

            tempXML.auctionFees.appendChild(node);

            var xl:XMLList = XMLList(tempXML.auctionFees.children());
            xc4 = new XMLListCollection(xl);
            auctionItemFeeHolder.dataProvider = xc4.list;


            auctionItemFeeHolder.validateNow();
            auctionItemFeeHolder.validateDisplayList();

            node3;


        }

        if (name == "deleteFeeBtn") {
            if (auctionItemFeeHolder.selectedIndex == -1) {

                return;
            }

            else {

                t = auctionItemFeeHolder.selectedIndex;

                delete tempXML.auctionFees.fee[t];

                xl = XMLList(tempXML.auctionFees.children());
                xc4 = new XMLListCollection(xl);
                auctionItemFeeHolder.dataProvider = xc4.list;
            }
        }

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////

    private function bubbleMouseEvent(event:MouseEvent):void {

        var obj:InteractiveObject = event.currentTarget as InteractiveObject;
        var e:MouseEvent = new MouseEvent("CLICK", true, true, null as int, null as int, obj, true, false, false, false, 0);
        this.dispatchEvent(e);
    }
}
}