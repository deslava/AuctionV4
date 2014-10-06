/**
 * Created by Daniel on 12/11/13.
 */
package auctionFunctionsClass {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.rpc.AbstractInvoker;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;

import util.HTTPServiceWrapper;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]


public class serverTime extends AbstractInvoker {

    public function serverTime() {
        _timeDelay = 500;
        _timerOn = true;
        clearHttpServices();
    }

    private var _httpService:HTTPService;
    private var _httpServiceWrapper:HTTPServiceWrapper;
    private var _timer:Timer;

    private var _currentTime:Date;

    public function get currentTime():Date {
        return _currentTime;
    }

    private var _timeDelay:int;

    public function set timeDelay(value:int):void {
        _timeDelay = value;
    }

    private var _timerOn:Boolean;

    public function set timerOn(value:Boolean):void {
        _timerOn = value;
    }

    public function clear():void {

        _timeDelay = 500;
        _timerOn = true;
        clearHttpServices();
    }

    public function getServerTime():void {

        _httpServiceWrapper.getContent("timerCount.php", "e4x", populateList);
        _timer = new Timer(_timeDelay);
        _timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    private function clearTimer():void {
        _timer.stop();
        _timer.reset();
        _timer.removeEventListener(TimerEvent.TIMER, onTimer);
    }

    private function clearHttpServices():void {
        _httpService = new HTTPService();
        _httpServiceWrapper = new HTTPServiceWrapper();
    }

    private function clearServerTime():void {
        _httpServiceWrapper = null;
        _currentTime = null;
        _timer = null;
    }

    private function onTimer(event:TimerEvent):void {
        clearTimer();
        clearServerTime();
        clearHttpServices();
        getServerTime();
    }

    private function populateList(event:ResultEvent):void {
        _httpServiceWrapper.removeEventListener(ResultEvent.RESULT, populateList);
        _httpServiceWrapper.removeEventListener(FaultEvent.FAULT, populateList);

        if (!event) {
            var e:Event = new Event("fault");
            this.dispatchEvent(e);
            return;

        }

        var obj:Object;
        var time:String;
        var xmlTime:XML;

        obj = event as Object;

        xmlTime = XML(obj.result);
        time = xmlTime.toString();

        _currentTime = new Date(Date.parse(time));
        trace(time);

        e = new Event("result");
        this.dispatchEvent(e);

        if (_timerOn == true)
            _timer.start();
        else
            clearTimer();
    }
}
}
