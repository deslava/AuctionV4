package util {

import mx.controls.Alert;
import mx.rpc.AsyncResponder;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public class HTTPServiceWrapper extends HTTPService {
    //reference for connections
    /**
     * Create the HTTPService
     *
     */
    public function HTTPServiceWrapper():void {
        //create the service
        _httpService = new HTTPService;
    }

    private var _httpService:HTTPService;

    // Holds all the tokens and callbacks
    private var _alertTitle:String = "HTTPService: An error occured";
    private var _processingQueue:Object = {};

    /**
     * Get content from URL
     * @param url
     * @param resultFormat
     * @param callBack
     * @param request
     * @param returnErrorEvent
     *
     */
    public function getContent(url:String, resultFormat:String, callBack:Function, request:Object = null, returnErrorEvent:Boolean = false):void {
        var asyncToken:AsyncToken;
        var internalIResponder:IResponder;

        if (request == null)
            request = new Object();

        //set the url and result format
        _httpService.url = url;
        _httpService.resultFormat = resultFormat;
        _httpService.request = null;
        _httpService.concurrency = "single";

        request.nocache = new Date;
        request.nocache.getTime();

        //check for key/value pairs to be sent in the url
        if (request) {
            _httpService.request = request;
        }

        //send the request
        asyncToken = _httpService.send();
        internalIResponder = new AsyncResponder(onGetContentHandler, onFault, asyncToken);
        asyncToken.addResponder(internalIResponder);

        //give token unique ID
        asyncToken = tokenID(asyncToken);

        _processingQueue[asyncToken.ID] = new QueueObject(callBack, returnErrorEvent);
    }

    /**
     * This is the handler event for getContent. The callBack should accept a ResultEvent
     *
     * @param event
     * @param token
     *
     */
    private function onGetContentHandler(event:ResultEvent, token:AsyncToken):void {
        var queueObject:QueueObject = _processingQueue[token.ID];

        queueObject.callBack(event);

        this.dispatchEvent(event);
        _httpService.cancel(token.ID);
        _httpService.disconnect();
        token = null;
        queueObject = null;
        _httpService = new HTTPService;
    }


    /**
     * This is the fault event for the class. The callBack should accept a null ArrayCollection and a FaultEvent if
     * you want to handle the error.
     *
     * @param event
     * @param token
     *
     */
    private function onFault(event:FaultEvent, token:AsyncToken):void {
        var queueObject:QueueObject = _processingQueue[token.ID];

        //handle the fault
        if (queueObject.returnErrorEvent) {
            queueObject.callBack(null, event);
        }
        else {
            var displayMessage:String = event.fault.faultString;
            //displayError(displayMessage);
            queueObject.callBack(null);
        }

        this.dispatchEvent(event);
    }


    /**
     * This will add a unique identifier to a token
     * @param token
     * @return
     *
     */
    private function tokenID(token:AsyncToken):AsyncToken {
        token.ID = Math.random();
        return token;
    }

    /**
     * Displays the error on a fault event in the content service
     * @param event
     *
     */
    private function displayError(displayMessage:String):void {
        Alert.show(displayMessage, _alertTitle, Alert.OK);
    }
}
}

class QueueObject {
    public var callBack:Function;
    public var returnErrorEvent:Boolean;

    public function QueueObject(callBack:Function, returnErrorEvent:Boolean) {
        this.callBack = callBack;
        this.returnErrorEvent = returnErrorEvent;
    }
}
