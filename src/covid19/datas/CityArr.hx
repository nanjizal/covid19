package covid19.datas;
import latLongUK.EastNorth;
@:forward
abstract CityArr( Array<City> ) from Array<City> to Array<City> {
    public inline
    function new( v: Array<City> ){ this = v; }
    @:from
    public inline static 
    function fromArrayArray( arr: Array<Array<String>> ){
        var arrC = new Array<City>();
        for( i in 0...arr.length ) {
            arrC[ i ] = arr[ i ];
        }
        return new CityArr( arrC );
    }
}