package covid19.geo;

@:structInit
class EastNorth {
    public var east:       Float;
    public var north:      Float;
    function new( east: Float, north: Float ){
        this.east       = east;
        this.north      = north;
    }
    public static
    var zero( get, null ): EastNorth;
    inline static 
    function get_zero(): EastNorth {
        return { east: 0., north: 0. };
    }
    public
    var notOrigin( get, null ): Bool;
    inline 
    function get_notOrigin(){
        return !( east == 0. && north == 0. );
    }
    public inline
    function pretty(){
        return 'east ' + Math.round( east ) + ' north ' + Math.round( north );
    }
}