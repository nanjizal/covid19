package covid19;
import htmlHelper.tools.TextLoader;
import htmlHelper.tools.CSV;
import htmlHelper.tools.AnimateTimer;
import haxe.ds.StringMap;
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
import covid19.geo.LongLatUK;
import covid19.geo.EastNorth;
import covid19.visual.UKcanvasPlot;
import datetime.DateTime;
import htmlHelper.tools.DivertTrace;
import htmlHelper.canvas.CanvasWrapper;
import htmlHelper.canvas.Surface;
import pallette.ColorWheel24;
import uk.CanvasUK;
import js.Browser;
// sources... 
// https://github.com/tomwhite/covid-19-uk-data/blob/master/data/covid-19-cases-uk.csv
// https://www.doogal.co.uk/AdministrativeAreas.php

typedef AreaName = {
    var areaId: String;
    var name:   String;
}
class Main {
    public static
    function main(){
        new Main();
    }
    var csvStats = 'https://raw.githubusercontent.com/tomwhite/covid-19-uk-data/master/data/covid-19-cases-uk.csv';
    var csvStats2 = '../data/covid19uk.csv';
    var textLoader:     TextLoader;
    var longLatArr:     LongLatAreasArr;
    var stat19Arr:      StatsC19Arr;
    var area9Arr:       Area9Arr;
    var citiesArr:      CityArr;
    var additionalArr:  AddLatLongArr;
    // assumed start date of data.
    var dayCounter      = new DayCounter( { day:5, month:3, year:2020} );
    var canvasWrapper:  CanvasWrapper;
    var surface:        Surface;
    var divertTrace:    DivertTrace;
    var mapPlot:        UKcanvasPlot;
    var months = [ 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    public function new(){
        divertTrace = new DivertTrace();
        var canvas = new CanvasWrapper();
        canvas.width  = 1024;
        canvas.height = 768;
        Browser.document.body.appendChild( cast canvas );
        surface = new Surface({ x: 10, y: 10, me: canvas.getContext2d() });
        var uk = new CanvasUK( surface );
        uk.dx = 28;
        uk.dy = 47;
        uk.alpha = 0.7;
        uk.scaleY = 0.975;
        uk.scaleX = 1.04;
        uk.draw();
        mapPlot = new UKcanvasPlot( surface );
        mapPlot.plotGrid();
        textLoader = new TextLoader( ['../data/postcodeAdmin.csv'
                                     ,'../data/E_areas.csv'
                                     ,'../data/latLongAdditional.csv'
                                     ,'../data/SomeCities.csv'
                                     , csvStats ], finished );
    }
    public function drawGraph(){
        for( i in 0...citiesArr.length ){
            var city = citiesArr[ i ];
            var p = mapPlot.toXY( city.east, city.north );
            mapPlot.circle36( 0x99c799, 0.1, p.x, p.y, 2. );//f7f7f7
        }
        //mapPlot.drawRectBorder();
    }
    public function finished(){
        parseCSV();
        trace('Animating UK data');
        drawGraph();
        AnimateTimer.create();
        AnimateTimer.onFrame = render;
    }
    var count           = 0;
    var framesDivisor   = 8;
    public function render(i: Int ):Void{
        count++;
        if( count%framesDivisor == 0 ){
            count = 0;
            renderDate();
            dayCounter.next();
        }
    }
    var unplotted:  String = 'unplotted<br>';
    var lastStr:    String = '';
    var currentStr: String = '';
    @:access( htmlHelper.tools.DivertTrace )
    @:access( surface.me )
    function renderDate(){
        lastStr = currentStr + lastStr;
        var str = '';
        var colors = ColorWheel24.getWheel();
        //colors.reverse();
        var dayStat = stat19Arr.getByDate( dayCounter );
        for( i in 0...dayStat.length ){
            var stat = dayStat[ i ];
            var eastNorth = getEastNorth( stat );
            if( eastNorth.notOrigin ) mapPlot.plot( eastNorth, stat.totalCases, colors );
            if( eastNorth.notOrigin ){
                str += '<b>' + stat.totalCases + '</b>' + ' ill, ' + datePretty( stat.date ) + ', ' + stat.area + ' ' + eastNorth.pretty();
                str += '<br>';
            } else {
                unplotted += datePretty( stat.date ) + ', ' + stat.area + ' ' + stat.totalCases + ' ill, ';
                unplotted += '<br>';
            }
        }
        if( str != '' ) {
            currentStr = str;
            //trace( unplotted + '<br>-plotted<br>' + currentStr + lastStr ); // collate traces it's much faster!
        } else {
            divertTrace.traceString = '';
            trace( unplotted + '<br>-plotted<br>' + currentStr + lastStr ); // collate traces it's much faster!
            AnimateTimer.onFrame = function(i: Int ){};
        }
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
    inline
    function datePretty( date: DateTime ): String {
        return date.getDay() + ' ' + months[ date.getMonth() - 1 ];
    }
    public function parseCSV(){
        longLatArr     = parseData( 'postcodeAdmin.csv' );
        stat19Arr      = parseData( 'covid-19-cases-uk.csv' );
        area9Arr       = parseData( 'E_areas.csv' );
        additionalArr  = parseData( 'latLongAdditional.csv' );
        citiesArr      = parseData( 'SomeCities.csv' );
    }
    function parseData( fileNom: String ): Array<Array<String>> {
        var str         = textLoader.contents.get( fileNom );
        var arr         = CSV.parse( str );
        arr.shift(); // remove title
        return arr;
    }
}