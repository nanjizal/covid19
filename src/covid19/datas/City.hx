package covid19.datas;
import covid19.geo.LongLatUK;
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
    function toOScoordinates( arr: Array<String> ): { east: Float, north: Float }{
        var ll = new LongLatUK();
        var toFloat =  Std.parseFloat;
        var val = ll.ll_to_osOld( toFloat( arr[1] ), toFloat( arr[2] ) );
        ll = null;
        return val;
    }
}