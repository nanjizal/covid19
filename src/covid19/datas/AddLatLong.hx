package covid19.datas;
import latLongUK.LatLongUK;
import latLongUK.EastNorth;
@:structInit
class InternalAddLatLong {
    public var place:          String;
    public var area9:          String;
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
abstract AddLatLong( InternalAddLatLong ) from InternalAddLatLong to InternalAddLatLong {
    public inline
    function new( v: InternalAddLatLong ){ this = v; }
    @:from
    public inline static 
    function fromArray( arr: Array<String> ){
        var val = toOScoordinates( arr );
        return new AddLatLong(  { place:             StringTools.trim( arr[0] )
                                , area9:             StringTools.trim( arr[1] )
                                , latitude:          Std.parseFloat( arr[2] )
                                , longitude:         Std.parseFloat( arr[3] )
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