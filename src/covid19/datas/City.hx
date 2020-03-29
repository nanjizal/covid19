package covid19.datas;
import latLongUK.EastNorth;
import latLongUK.LatLongUK;
@:structInit
class InternalCity {
    public var place:          String;
    public var area9:          String; // not yet used
    public var latitude:       Float;
    public var longitude:      Float;
    public var east:           Float;
    public var north:          Float;
    function new( place:        String
                , area9:        String
                , latitude:     Float
                , longitude:    Float
                , east:         Float
                , north:        Float ){
        this.place              = place;
        this.area9              = area9;
        this.latitude           = latitude;
        this.longitude          = longitude;
        this.east               = east;
        this.north              = north;
    }
}
@:forward
abstract City( InternalCity ) from InternalCity to InternalCity {
    public inline
    function new( v: InternalCity ){ this = v; }
    @:from
    public inline static 
    function fromArray( arr: Array<String> ){
        var val = toOScoordinates( arr );
        return new City(  { place:             StringTools.trim( arr[0] )
                          , area9:             ''
                          , latitude:          Std.parseFloat( arr[1] )
                          , longitude:         Std.parseFloat( arr[2] )
                          , east:              val.east
                          , north:             val.north
                          } );
    }
    public static inline
    function toOScoordinates( arr: Array<String> ): EastNorth {
        var toFloat =  Std.parseFloat;
        var val = LatLongUK.ll_to_osOld( { lat: toFloat( arr[2] ), long: toFloat( arr[3] ) } );
        return val;
    }
}