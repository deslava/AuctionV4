package util {
public class timerConversion {
    public function timerConversion(_time:Number = 0) {
        _countDownTime = _time;
        timeStringCreate();
    }

    private var _countDownTime:Number;
    private var _seconds:String;
    private var _minutes:String;
    private var _hours:String;
    private var _days:String;

    public function timeString():String {
        var newTime:String;

        if (_countDownTime > 0) {
            //Joins all values into one string value
            newTime = _days + " Days " + _hours + ":" + _minutes + ":" + _seconds;
        } else {
            trace("TIME'S UP");
            newTime = "00:00:00:00";
        }

        return newTime;
    }

    private function timeStringCreate():void {

        if (_countDownTime <= 0)
            return;

        var _sec:Number;
        var _min:Number;
        var _hr:Number;
        var _d:Number;

        _sec = Math.floor(_countDownTime / 1000);
        _min = Math.floor(_sec / 60);
        _hr = Math.floor(_min / 60);
        _d = Math.floor(_hr / 24);
        //Takes results of var remaining value.  Also converts "sec" into a string
        _seconds = String(_sec % 60);
        //Once a string, you can check the values length and see whether it has been reduced below 2.
        //If so, add a "0" for visual purposes.
        if (_seconds.length < 2) {
            _seconds = "0" + _seconds;
        }
        _minutes = String(_min % 60);
        if (_minutes.length < 2) {
            _minutes = "0" + _minutes;
        }
        _hours = String(_hr % 24);
        if (_hours.length < 2) {
            _hours = "0" + _hours;
        }

        _days = String(_d);

    }
}
}