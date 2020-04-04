package covid19.manager;
import covid19.datas.StatsC19;
import covid19.datas.LongLatAreas;
import covid19.datas.LongLatAreasArr;
import covid19.datas.Area9;
import covid19.datas.Area9Arr;
import covid19.datas.StatsC19Arr;
import covid19.datas.AddLatLong;
import covid19.datas.AddLatLongArr;
import covid19.datas.City;
import covid19.datas.CityArr;
import covid19.datas.DayCounter;
import covid19.datas.PlotPlace;
import htmlHelper.tools.TextLoader;
import htmlHelper.tools.CSV;
import latLongUK.EastNorth;
class DataManager{
    var dayCounter      = new DayCounter( { day:5, month:3, year:2020} );
    var csvStats = 'https://raw.githubusercontent.com/tomwhite/covid-19-uk-data/master/data/covid-19-cases-uk.csv';
    var csvStats2 = '../data/covid19uk.csv';
    var textLoader:     TextLoader;
    var longLatArr:     LongLatAreasArr;
    var stat19Arr:      StatsC19Arr;
    var area9Arr:       Area9Arr;
    var citiesArr:      CityArr;
    var additionalArr:  AddLatLongArr;
    var notPlotted =    new Array<String>();
    var plotDatas =     new Array<PlotPlace>();
    var finish:         Void->Void;
    var startPoints =   new Array<Int>();
    public function new( finish: Void->Void ){
        this.finish = finish;
        textLoader = new TextLoader( ['../data/postcodeAdmin.csv'
                                     ,'../data/E_areas.csv'
                                     ,'../data/latLongAdditional.csv'
                                     /*,'../data/SomeCities.csv'*/
                                     , csvStats ], parseCSV );
    }
    function parseCSV(){
        longLatArr     = parseData( 'postcodeAdmin.csv' );
        stat19Arr      = parseData( 'covid-19-cases-uk.csv' );
        area9Arr       = parseData( 'E_areas.csv' );
        additionalArr  = parseData( 'latLongAdditional.csv' );
        /*citiesArr      = parseData( 'SomeCities.csv' );*/
        stat19Arr.sort( dateSort  );
        
        collatePlotData();
        
        finish();
    }
    inline
    function dateSort( a: StatsC19, b: StatsC19 ): Int {
        return Math.round(( a.date - b.date ).getTotalSeconds());
    }
    public
    function collatePlotData(){
    // parse to cleaner structure.
        var hasDays = true;
        while( hasDays ){
            hasDays = storeDay();
            dayCounter.next();
            days++;
        }
        days--;
        plotDatas[ plotDatas.length ] = null;
        startPoints[ startPoints.length ] = plotDatas.length-1;
    }
    
    var days = 0;
    function parseData( fileNom: String ): Array<Array<String>> {
        var str         = textLoader.contents.get( fileNom );
        var arr         = CSV.parse( str );
        arr.shift(); // remove title
        return arr;
    }
    function storeDay(){
        startPoints[ startPoints.length ] = plotDatas.length;
        var dayStat = stat19Arr.getByDate( dayCounter );
        for( i in 0...dayStat.length ){
            var stat = dayStat[ i ];
            var eastNorth = getEastNorth( stat );
            if( eastNorth.notOrigin ){
                plotDatas[ plotDatas.length ] = {   place:     stat.area
                                                  , eastNorth: eastNorth
                                                  , date:      dayCounter.cloneInternal()
                                                  , total:     stat.totalCases };
            } else {
                storeUnfound( stat.area );
            }
        }
        return ( dayStat.length != 0 );
    }
    public 
    function getNoDays(){
        return days;
    }
    public
    function getDay( count: Int ){
        var arr = new Array<PlotPlace>();
        if( count < ( startPoints.length - 1 )) {
            trace( new DayCounter(plotDatas[startPoints[count]].date).pretty() );
            for( i in startPoints[ count ]...startPoints[ count + 1 ] ){
                arr[ arr.length ] = plotDatas[ i ];
            }
        }
        return arr;
    }
    public
    function getMaxTotal(){
        return stat19Arr.getMaxTotal();
    }
    public
    function getUnfound(){
        return notPlotted.toString();
    }
    inline
    function getEastNorth( stat: StatsC19 ): EastNorth {
        var eastNorth =                         additionalArr.eastNorthByArea( stat.area );
        if( !eastNorth.notOrigin ) eastNorth =  longLatArr.eastNorthByArea( stat.area );
        if( !eastNorth.notOrigin ) {
            //trace( stat.area +',' + stat.areaCode +',' );
            if( area9Arr.area9exists( stat.areaCode ) ) {
                var area = area9Arr.getPlace( stat.areaCode );
                eastNorth = longLatArr.eastNorthByArea( area );
            }
        }
        return eastNorth;
    }
    function storeUnfound( area: String ){
        if( notPlotted.indexOf( area ) == -1 ) notPlotted[ notPlotted.length ] = area;
    }
}