package covid19.datas;
import covid19.geo.EastNorth;
@:forward
abstract LongLatAreasArr( Array<LongLatAreas> ) from Array<LongLatAreas> to Array<LongLatAreas> {
    public inline
    function new( v: Array<LongLatAreas> ){ this = v; }
    @:from
    public inline static 
    function fromArrayArray( arr: Array<Array<String>> ){
        var arrLL = new Array<LongLatAreas>();
        for( i in 0...arr.length ) arrLL[ i ] = arr[ i ];
        return new LongLatAreasArr( arrLL );
    }
    public inline
    function eastNorthByArea( area: String ): EastNorth {
        var found = false;
        var eastNorth = EastNorth.zero;
        for( pos in this ){
            if( pos.admin_area.toLowerCase() == area.toLowerCase() ){
                eastNorth.east  = pos.east;
                eastNorth.north = pos.north;
                found  = true;
                break;
            }
        }
        if( !found ){
            for( pos in this ){
                if( pos.county.toLowerCase() == area.toLowerCase() ){
                    eastNorth.east  = pos.east;
                    eastNorth.north = pos.north;
                    found  = true;
                    break;
                }
            }
        }
        if( !found ){
            for( pos in this ){
                if( StringTools.contains( pos.admin_area, ' ' ) ){
                    if( StringTools.contains( pos.admin_area.toLowerCase(), area.toLowerCase() ) ){
                        eastNorth.east  = pos.east;
                        eastNorth.north = pos.north;
                        found  = true;
                        break;
                    }
                }
            }
        }
        return eastNorth;
    }
}