import spark.components.DropDownList;

private function valueTabSearch(list:DropDownList, searchVar:String):int {
    var x:int = 0;
    var obj:Object = list.dataProvider;
    var xl:XMLList = obj.source as XMLList;
    var s:String;

    for (x = 0; x < xl.length(); x++) {
        s = xl[x].toString();

        if (s == searchVar)
            return x;

    }

    return (-1);

}

