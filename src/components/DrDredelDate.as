package components {
public class DrDredelDate {
    /*
     init new date by passing:
     a) nothing - an object with the current time will be generated
     b) a millisecond string for a specific time
     c) a time formatted in one of the following two ways:
     2013-01-01 00:00:00 -7:00   -- timzeone is optional, if omitted, date will be created as GMT
     or
     2012-01-18T23:30:42-08:00  -- timezone non-optional
     */
    public static var PST:String = "PST";
    public static var EST:String = "EST";
    public static var CST:String = "CST";
    public static var MST:String = "MST";

    public function DrDredelDate(inD:String = null) {
        if (inD == null) {
            d = new Date();
            getDateVars(d)
        }
        else if (inD.replace(/\d+/, "") == "") {
            d = new Date(parseInt(inD))
            getDateVars(d);
        }
        else
            d = convertFromString(inD);
    }

    public var year, month, monthName, date, weekDay, hours, minutes, seconds, timezoneOffset;
    private var d:Date;


    ///////////NOTHING TO REALLY LOOK AT BELOW HERE////////////////
    private var monthAbbr = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    private var timezoneString = "";

    /**
     Format using the following control characters:
     m = month,
     d = day,
     yy = 2 digit year,
     yyyy = 4 digit year,
     h = 24 hour time,
     M = minute,
     s = second,
     t = timezone as digits offset,
     c = month abbr,
     W = weekday
     H = 12hour
     a = am/pm
     A = AM/PM
     T = timezone abbr //if available
     */
    public function getFormattedDate(formatString:String):String {
        var ret:String = "";
        for (var i = 0; i < formatString.length; i++) {
            if (formatString.charAt(i) == 'm') {
                if (formatString.substring(i).match(/^mm/)) {
                    ret += addLeadingZero(month);
                    i++;
                    continue;
                }
                ret += month;
                continue;
            }
            if (formatString.charAt(i) == 'd') {
                if (formatString.substring(i).match(/^dd/)) {
                    ret += addLeadingZero(date);
                    i++;
                    continue;
                }
                ret += date;
                continue;
            }

            if (formatString.charAt(i) == 'y') {
                if (formatString.substring(i).match(/^yyyy/)) {
                    ret += year;
                    i += 3;
                    continue;
                } else if (formatString.substring(i).match(/^yy/)) {
                    ret += (year + "").substring(2, 4);
                    i++;
                    continue;
                }
            }
            if (formatString.charAt(i) == 'h') {
                if (formatString.substring(i).match(/^hh/)) {
                    ret += addLeadingZero(hours);
                    i++;
                    continue;
                }
                ret += hours;
                continue;
            }
            if (formatString.charAt(i) == 'H') {
                if (formatString.substring(i).match(/^HH/)) {
                    ret += addLeadingZero(militaryToClockHour());
                    i++;
                    continue;
                }
                ret += militaryToClockHour();
                continue;
            }
            if (formatString.charAt(i) == 'a') {
                ret += ampm();
                continue;
            }
            if (formatString.charAt(i) == 'A') {
                ret += AMPM();
                continue;
            }
            if (formatString.charAt(i) == 'M') {
                if (formatString.substring(i).match(/^MM/)) {
                    ret += addLeadingZero(minutes);
                    i++;
                    continue;
                }
                ret += minutes;
                continue;
            }
            if (formatString.charAt(i) == 's') {
                if (formatString.substring(i).match(/^ss/)) {
                    ret += addLeadingZero(seconds);
                    i++;
                    continue;
                }
                ret += seconds;
                continue;
            }
            if (formatString.charAt(i) == 't') {
                ret += timezoneOffset;
                continue;
            }
            if (formatString.charAt(i) == 'T') {
                ret += timezoneString;
                continue;
            }
            if (formatString.charAt(i) == 'c') {
                ret += getMonthAbbr();
                continue;
            }
            if (formatString.charAt(i) == 'W') {
                ret += getWeekday();
                continue;
            }
            ret += formatString.charAt(i);
        }
        return ret;
    }

    /**
     Usage:
     Returns a formatted string representation of this Date object converted over into the requested timezone. Note that this has no effect on the underlying date object and the returned value is simply a string representation.
     arguments :
     format: pass in the same format as you would for the method above for the format param
     timeZoneOffset: pass in an abbr or one of the US tZones from mySQL or just a numeric offset representing the hour offset from GMT ie. -5 or +3
     */
    public function getShiftedTimezoneFormattedDate(format:String, timeZoneOffset:String = "GMT"):String {
        var tzOffset = null;

        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "GMT")
            tzOffset = 0;
        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "EST" || timeZoneOffset == "US/Eastern")
            tzOffset = -5;
        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "EDT")
            tzOffset = -4;
        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "CST" || timeZoneOffset == "US/Central")
            tzOffset = -6;
        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "CDT")
            tzOffset = -5;
        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "MST" || timeZoneOffset == "US/Mountain")
            tzOffset = -7;
        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "MDT")
            tzOffset = -6;
        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "PST" || timeZoneOffset == "US/Pacific")
            tzOffset = -8;
        if (timeZoneOffset.toUpperCase().replace(/[^A-Z]/g, "") == "PDT")
            tzOffset = -7;

        if (tzOffset == null) {
            var operator = timeZoneOffset.charAt(0);
            tzOffset = parseInt(timeZoneOffset.replace("/:.*/", ""));
        }
        if (isNaN(tzOffset))
            return null

        tzOffset = tzOffset * 60 * 60 * 1000;
        var dTzOffset = -d.timezoneOffset * 60 * 1000;
        var newMS = d.getTime() - dTzOffset + tzOffset;
        var nDate:Date = new Date(newMS);
        return new DrDredelDate(nDate.getTime() + "").getFormattedDate(format);
    }

    public function isAfterDate(comparisonDate:Date):Boolean {
        return(d.time > comparisonDate.time)
    }

    public function isSameAsDate(comparisonDate:Date):Boolean {
        return(d.time == comparisonDate.time)
    }

    public function getTime() {
        return d.time;
    }

    public function getDate() {
        return d;
    }

    public function getWeekday() {
        return d.toString().split(" ")[0];
    }

    public function getMonthAbbr() {
        return d.toString().split(" ")[1];
    }

    private function getDateVars(d:Date) {
        this.year = d.fullYear;
        this.month = d.month;
        this.date = d.date;
        this.hours = d.hours;
        this.minutes = d.minutes;
        this.seconds = d.seconds;
        this.timezoneOffset = d.timezoneOffset;
    }

    private function convertFromString(inD:String):Date {
        //2012-10-03 10:15:00 GMT-0800
        if (inD.match(/\d{4}\-\d{1,2}\-\d{1,2} \d{1,2}\:\d{1,2}\:\d{1,2}/)) {
            return timeFromMySqlTimestamp(inD);
        }
        //2012-01-18T23:30:00-08:00
        if (inD.match(/\d{4}\-\d{1,2}\-\d{1,2}T\d{1,2}\:\d{1,2}\:\d{1,2}/)) {
            return timeFromGenericTimestamp(inD);
        }
        return null;
    }

    private function timeFromMySqlTimestamp(inD:String):Date {
        //2012-10-19 03:15:22 PST
        var parts:Array = inD.split(" ");// 0 = date, 1 = hours, 2 = timezone
        year = stripLeadingZero(parts[0].split("-")[0]);
        month = stripLeadingZero(parts[0].split("-")[1]);
        date = stripLeadingZero(parts[0].split("-")[2]);
        hours = stripLeadingZero(parts[1].split(":")[0]);
        minutes = stripLeadingZero(parts[1].split(":")[1]);
        seconds = stripLeadingZero(parts[1].split(":")[2]);
        try {
            timezoneOffset = getTZFromString(parts[2]);
        } catch (e:Error) {
            timezoneOffset = "GMT-000";
        }

        return new Date(monthAbbr[month] + " " + date + " " + year + " " + hours + ":" + minutes + ":" + seconds + " " + timezoneOffset);//09 03 2012 23:39:05 GMT-0500
    }

    private function getTZFromString(inStr:String) {
        if (inStr.toUpperCase().replace(/[^A-Z]/g) == "EST") {
            timezoneString = "EST";
            return "GMT-0500"
        }
        ;
        if (inStr.toUpperCase().replace(/[^A-Z]/g) == "EDT") {
            timezoneString = "EDT";
            return "GMT-0400"
        }
        ;
        if (inStr.toUpperCase().replace(/[^A-Z]/g) == "CST") {
            timezoneString = "CST";
            return "GMT-0600"
        }
        ;
        if (inStr.toUpperCase().replace(/[^A-Z]/g) == "CDT") {
            timezoneString = "CDT";
            return "GMT-0500"
        }
        ;
        if (inStr.toUpperCase().replace(/[^A-Z]/g) == "MST") {
            timezoneString = "MST";
            return "GMT-0700"
        }
        ;
        if (inStr.toUpperCase().replace(/[^A-Z]/g) == "MDT") {
            timezoneString = "MDT";
            return "GMT-0600"
        }
        ;
        if (inStr.toUpperCase().replace(/[^A-Z]/g) == "PST") {
            timezoneString = "PST";
            return "GMT-0800"
        }
        ;
        if (inStr.toUpperCase().replace(/[^A-Z]/g) == "PDT") {
            timezoneString = "PDT";
            return "GMT-0700"
        }
        ;
        if (inStr.charAt(0) == "-" || inStr.charAt(0) == "+") return "GMT" + inStr;
        return inStr;
    }

    private function timeFromGenericTimestamp(inD:String):Date {
        //2012-01-18T23:30:00-08:00
        var parts:Array = inD.split("T");// 0 = date, 1 = hours, 2 = timezone
        year = stripLeadingZero(parts[0].split("-")[0]);
        month = stripLeadingZero(parts[0].split("-")[1]);
        date = stripLeadingZero(parts[0].split("-")[2]);
        hours = stripLeadingZero(parts[1].split(":")[0]);
        minutes = stripLeadingZero(parts[1].split(":")[1]);
        var secAndTZ = parts[1].split(":")[2];
        var plusMinusTok = (secAndTZ.indexOf("-") != -1) ? "-" : "+";
        seconds = stripLeadingZero(secAndTZ.split(plusMinusTok)[0]);
        timezoneOffset = plusMinusTok + secAndTZ.split(plusMinusTok)[1] + "00";

        return new Date(monthAbbr[month] + " " + date + " " + year + " " + hours + ":" + minutes + ":" + seconds + " " + timezoneOffset);//09 03 2012 23:39:05 GMT-0500
    }

    private function addLeadingZero(inD:Number):String {
        return ( inD >= 10) ? inD + "" : "0" + inD;
    }

    private function stripLeadingZero(inStr:String) {
        if (inStr.replace(/\d+/, "") != "") {
            trace("DrDredelDate: stripLeadingZero: inStr " + inStr + " is non numeric. returning null");
            return null;
        }
        inStr = inStr.replace(/^0+/, "");
        if (inStr == "")
            return 0;
        return parseInt(inStr);
    }


    private function militaryToClockHour() {
        if (hours == 0 || hours == 12)
            return 12;
        if (hours < 12)return hours;
        return hours - 12;
    }

    private function AMPM() {
        return (hours < 12) ? "AM" : "PM";
    }

    private function ampm() {
        return (hours < 12) ? "am" : "pm";
    }

}
}