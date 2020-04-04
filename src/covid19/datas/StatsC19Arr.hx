package covid19.datas;
import covid19.datas.DayCounter;
@:forward
abstract StatsC19Arr( Array<StatsC19> ) from Array<StatsC19> to Array<StatsC19> {
    public inline
    function new( v: Array<StatsC19> ){ this = v; }
    @:from
    public inline static 
    function fromArrayArray( arr: Array<Array<String>> ): StatsC19Arr {
        var arr19 = new Array<StatsC19>();
        for( i in 0...arr.length ) arr19[ i ] = arr[ i ];
        return new StatsC19Arr( arr19 );
    }
    public
    function getByDate( dayCounter: DayCounter ): StatsC19Arr {
        var arr = new Array<StatsC19>();
        var j = 0;
        for( stat in this ){
            var date = stat.date;
            if( dayCounter.matchDate( date ) ){
                arr[ j++ ] = stat; 
            }
        }
        return arr;
    }
    public
    function getMaxTotal(){
        var max = 0;
        for( i in this ){
            if( i.totalCases > max ) max = i.totalCases;
        }
        return max;
    }
}