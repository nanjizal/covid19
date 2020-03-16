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
        if( StringTools.trim( arr[4] ) == '1 to 4'){
            arr[4] = '2';
        }
        var area = StringTools.trim( arr[3] );
        if( StringTools.startsWith( area, '"') ) area = area.substr( 1, area.length );
        if( StringTools.endsWith( area, '"' ) )  area = area.substr( 0, area.length - 1 );
        var totalCases = Std.parseInt( arr[4] );
        if( totalCases == null && arr.length == 6 ) totalCases = Std.parseInt( arr[5] );
        return new StatsC19( { date:       StringTools.trim( arr[0] )
                             , country:    StringTools.trim( arr[1] ) 
                             , areaCode:   StringTools.trim( arr[2] )
                             , area:       area
                             , totalCases: totalCases
                             } );
    }
    
}