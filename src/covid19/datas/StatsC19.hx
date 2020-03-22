package covid19.datas;
import datetime.DateTime;

@:structInit
class InternalStatsC19 {
    public var date:       DateTime;
    public var country:    String;
    public var areaCode:   String;
    public var area:       String;
    public var totalCases: Int; 
    function new( date: String, country: String, areaCode: String, area: String, totalCases: Int ){
        this.date       = date;
        this.country    = country;
        this.areaCode   = areaCode;
        this.area       = area;
        this.totalCases = totalCases;
    }
}
@:forward
abstract StatsC19( InternalStatsC19 ) from InternalStatsC19 to InternalStatsC19 {
    public inline
    function new( v: InternalStatsC19 ){ this = v; }
    @:from
    public inline static 
    function fromArray( arr: Array<String> ){
        return new StatsC19( { date:       clean( arr[0] )
                             , country:    clean( arr[1] ) 
                             , areaCode:   clean( arr[2] )
                             , area:       cleanPlus( arr[3] )
                             , totalCases: cleanTotalCases( arr )
                             } );
    }
    public inline static 
    function cleanPlus( str: String ){
        str = clean( str );
        if( StringTools.startsWith( str, '"' ) ) str = str.substr( 1, str.length );
        if( StringTools.endsWith( str, '"' )   ) str = str.substr( 0, str.length );
        return str;
    }
    public inline static 
    function clean( str: String ){
        StringTools.trim( str );
        return str;
    }
    public inline static
    function cleanTotalCases( arr: Array<String> ): Int {
        var str = clean( arr[4] );
        if( str == '1 to 4' ) str = '2';
        var totalCases = Std.parseInt( str );
        // if comma in name the totalCount location can be shifted by 1.
        if( totalCases == null && arr.length == 6 ){
            str = clean( arr[5] );
            totalCases = Std.parseInt( str );
        }
        return totalCases;
    }
}