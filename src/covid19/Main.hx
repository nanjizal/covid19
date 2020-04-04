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
import covid19.datas.PlotPlace;
//import latLongUK.LatLongUK;
import latLongUK.EastNorth;
import covid19.visual.UKcanvasPlot;
import datetime.DateTime;
import htmlHelper.tools.DivertTrace;
import htmlHelper.canvas.CanvasWrapper;
import htmlHelper.canvas.Surface;
import pallette.ColorWheel24;
import uk.CanvasUK;
import latLongUK.LatLongUK;
import js.Browser;
import js.html.CanvasElement;
import covid19.manager.DataManager;
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
    var dataManager:    DataManager;
    var canvasWrapper:  CanvasWrapper;
    var surface:        Surface;
    var surface2:       Surface;
    var divertTrace:    DivertTrace;
    var mapPlot:        UKcanvasPlot;
    public function new(){
        divertTrace = new DivertTrace();
        canvasSetup();
        vectorUK();
        mapPlot = new UKcanvasPlot( surface );
        dataManager = new DataManager( finished );
    }
    function canvasSetup(){
        var canvas = new CanvasWrapper();
        canvas.width  = 1024;
        canvas.height = 768;
        Browser.document.body.appendChild( cast canvas );
        surface = new Surface({ x: 10, y: 10, me: canvas.getContext2d() });
    }
    var canvas2: CanvasWrapper;
    function vectorUK(){
        // likely fairly approximate
        canvas2 = new CanvasWrapper();
        canvas2.width  = 1024;
        canvas2.height = 768;
        surface2 = new Surface({ x: 10, y: 10, me: canvas2.getContext2d() });
        var uk = new CanvasUK( surface2 );
        uk.dx = 28;
        uk.dy = 47;
        uk.alpha = 0.8;
        uk.scaleY = 0.975;
        uk.scaleX = 1.04;
        uk.draw();
        var mapPlot2 = new UKcanvasPlot( surface2 );
        mapPlot2.plotGrid();
    }
    public function finished(){
        trace('Animating UK data');
        var tot = dataManager.getMaxTotal();
        trace('tot ' + tot );
        scaleSize = 30/tot;
        mapPlot.sizeScale = scaleSize;//( 1/(1.8 * 10) );
        mapPlot.colorChange = 24/tot;
        trace( dataManager.getUnfound() );
        AnimateTimer.create();
        AnimateTimer.onFrame = render;
    }
    var scaleSize = 0.;
    var count           = 0;
    var framesDivisor   = 8;
    var dayNo = 0;
    public function render(i: Int ):Void{
        count++;
        if( count%framesDivisor == 0 ){
            count = 0;
            renderDate();
        }
    }
    var unplotted:  String = 'unplotted<br>';
    var lastStr:    String = '';
    var currentStr: String = '';
    var str = '';
    @:access( htmlHelper.tools.DivertTrace )
    function renderDate(){
        if( dataManager.getNoDays() > dayNo  ){
            if( dataManager.getDay( dayNo ).length > 100 ){ // don't clear if it's just wales added
                mapPlot.clear();
                var canvasElement: CanvasElement = canvas2;
                surface.me.drawImage( canvasElement, 0, 0, 1024, 768 );
            }
        } 
        lastStr = currentStr + lastStr;
        str = '';
        var colors = ColorWheel24.getWheel();
        var dayStat = dataManager.getDay( dayNo++ );
        for( i in 0...dayStat.length ){
            var stat = dayStat[ i ];
            mapPlot.plot( stat.eastNorth, stat.total, colors );
            str += '<b>' + stat.total + '</b>' 
                + ' ill, ' + ( new DayCounter( stat.date ) ).pretty() + ', ' 
                + stat.place + ' ' + stat.eastNorth.pretty();
            str += '<br>';
        }
        currentStr = str;
        if( dataManager.getNoDays() < dayNo ){
            traceEndData(); // collate traces it's much faster!
            AnimateTimer.onFrame = function(i: Int ){};
        }
    }
    @:access( htmlHelper.tools.DivertTrace )
    function traceEndData(){
        trace('end data');
        divertTrace.traceString = '';
        trace( 'not plotted (' + dataManager.getUnfound() + ')<br>' 
              + 'sizeScale = ' + Math.round((scaleSize/2)*1000)/1000 + 'pixel radius per person' 
              + '<br>-locations plotted are centre of area health services<br>' 
              + currentStr + lastStr );
    }
    inline
    function datePretty( date: DateTime ): String {
        return DayCounter.datePretty( date );
    }
}