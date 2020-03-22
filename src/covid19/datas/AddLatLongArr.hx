package covid19.datas;
import covid19.geo.EastNorth;
@:forward
abstract AddLatLongArr( Array<AddLatLong> ) from Array<AddLatLong> to Array<AddLatLong> {
    public inline
    function new( v: Array<AddLatLong> ){ this = v; }
    @:from
    public inline static 
    function fromArrayArray( arr: Array<Array<String>> ){
        var arrAL = new Array<AddLatLong>();
        for( i in 0...arr.length ) {
            arrAL[ i ] = arr[ i ];
        }
        return new AddLatLongArr( arrAL );
    }
    public inline
    function eastNorthByArea( area: String ): EastNorth {
        var found = false;
        var eastNorth = EastNorth.zero;
        for( pos in this ){
            if( pos.place.toLowerCase() == area.toLowerCase() ){
                eastNorth.east  = pos.east;
                eastNorth.north = pos.north;
                found  = true;
                break;
            }
        }
        return eastNorth;
    }
}