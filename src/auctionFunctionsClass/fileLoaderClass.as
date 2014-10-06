package auctionFunctionsClass {
import flash.events.Event;

import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class fileLoaderClass {
    public function fileLoaderClass() {

        _xmlLoaderXML = new XML();
        _url = "";
        xmlFileLoader = new HTTPService();
        xmlFileLoader.concurrency = "last";
    }

    public var xmlFileLoader:HTTPService;
    private var _xmlLoaderXML:XML;

    private var _url:String;

    public function set url(urlLocation:String):void {
        _url = urlLocation;
    }

    public function get xmlLoader():XML {
        return _xmlLoaderXML;
    }


    public function loadXML(urlLocation:String = "auction.xml", obj:Object = null):void {
        if (obj == null)
            obj = new Object();

        var _obj:Object = obj;

        _url = urlLocation;

        //xmlFileLoader.contentType="application/x-www-form-urlencoded";
        xmlFileLoader.resultFormat = "text";
        xmlFileLoader.method = "POST";

        xmlFileLoader.addEventListener(ResultEvent.RESULT, XMLVerify);
        xmlFileLoader.addEventListener(FaultEvent.FAULT, XMLFail);

        XMLLoader(_url, _obj);


    }


    public function XMLLoader(urlLocation:String, obj:Object):void {
        xmlFileLoader.url = urlLocation;
        var param:Object = new Object();

        param = obj;
        param.nocache = new Date().getTime();

        xmlFileLoader.send(param);

    }

    protected function XMLVerify(event:Event):void {
        var obj:Object;
        obj = event;
        _xmlLoaderXML = XML(obj.result);

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, XMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, XMLFail);

        xmlFileLoader.disconnect();

        event = null;
        obj = null;
    }


    protected function XMLFail(event:Event):void {

        var obj:Object;
        obj = event;
        //_xmlLoaderXML  =  XML(obj.result);

        xmlFileLoader.removeEventListener(ResultEvent.RESULT, XMLVerify);
        xmlFileLoader.removeEventListener(FaultEvent.FAULT, XMLFail);

        xmlFileLoader.disconnect();

        event = null;
        obj = null;

    }


}
}