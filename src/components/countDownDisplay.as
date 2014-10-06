package components {
import auctionFunctionsClass.serverTime;

import flash.events.Event;

import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import util.timerConversion;

[Event(name="result", type="mx.rpc.events.ResultEvent")]
[Event(name="fault", type="mx.rpc.events.FaultEvent")]
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]

public class countDownDisplay extends countDownDisplayLayout {
    public function countDownDisplay() {
        super();
        this.addEventListener(FlexEvent.CREATION_COMPLETE, countDownTimer_creationComplete);
    }

    private var _currTime:Number;
    private var _countDownTime:Number;
    private var _serverTimeLoaderItem:serverTime;
    private var _displayTime:timerConversion;
    private var e:Event;

    private var _auctionTime:Number;

    public function set auctionTime(value:Number):void {
        _auctionTime = value;
    }

    public function clear():void {
        var active:Boolean;
        if (this == null)
            return;
        active = this.initialized;
        if (active == false)
            return;

        _currTime = 0;
        _auctionTime = 0;
        _countDownTime = 0;


        countDownTimerTxt.text = "";
        getServerTimer();
    }

    private function getServerTimer():void {

        _serverTimeLoaderItem = new serverTime();
        _serverTimeLoaderItem.addEventListener(ResultEvent.RESULT, serverTimeLoader_resultHandler);
        _serverTimeLoaderItem.addEventListener(FaultEvent.FAULT, serverTimeLoader_faultHandler);
        _serverTimeLoaderItem.getServerTime();
    }

    private function countDownTimer_creationComplete(event:FlexEvent):void {

        clear();

    }

    private function serverTimeLoader_faultHandler(event:Event):void {
        var obj:Object;
        obj = event;

        e = new Event("fault");
        this.dispatchEvent(e);
    }

    private function serverTimeLoader_resultHandler(event:Event):void {
        var countDownTime:Number = 0;

        _currTime = event.currentTarget.currentTime.getTime();


        if (_auctionTime == 0) {
            _auctionTime = _currTime
        }
        countDownTime = _auctionTime - _currTime;


        _displayTime = new timerConversion(countDownTime);
        countDownTimerTxt.text = _displayTime.timeString();
        countDownTimerTxt.invalidateDisplayList();

        e = new Event("result");
        this.dispatchEvent(e);

    }

}
}