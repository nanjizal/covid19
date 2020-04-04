package covid19.datas;

import latLongUK.EastNorth;
import latLongUK.LatLongUK;
import covid19.datas.DayCounter;
@:structInit
class PlotPlace {
    public var place:          String;
    public var eastNorth:      EastNorth;
    public var date:           InternalDayCounter;
    public var total:          Int;
    function new( place:        String
                , eastNorth:    EastNorth
                , date:         InternalDayCounter
                , total:        Int ){
        this.place              = place;
        this.eastNorth          = eastNorth;
        this.date               = date;
        this.total              = total;
    }
}