package covid19;
import htmlHelper.tools.TextLoader;
import htmlHelper.tools.CSV;
import haxe.ds.StringMap;
import covid19.datas.StatsC19;
import covid19.datas.LongLatAreas;
import covid19.geo.LongLatUK;
import datetime.DateTime;
import htmlHelper.tools.DivertTrace;
import htmlHelper.canvas.CanvasWrapper;
import htmlHelper.canvas.Surface;
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
    var scale    = 1/2000;
    var e_areas:  StringMap<String>;
    var statData = new Array<StatsC19>();
    var areaData = new Array<LongLatAreas>();
    var textLoader:     TextLoader;
    var eAreas:         Array<Array<String>>;
    var areaLatLong:    Array<Array<String>>;
    var covid19stats:   Array<Array<String>>;
    var canvasWrapper:  CanvasWrapper;
    var surface:        Surface;
    var months = [ 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    public function new(){
        new DivertTrace();
        var canvas = new CanvasWrapper();
        canvas.width  = 1024;
        canvas.height = 768;
        Browser.document.body.appendChild( cast canvas );
        surface = new Surface({ x: 10, y: 10, me: canvas.getContext2d() });
        drawRectBorder();
        textLoader = new TextLoader( ['../data/postcodeAdmin.csv'
                                     ,'../data/E_areas.csv'
                                     ,'../data/covid19uk.csv' ], finished );
    }
    public function drawRect( x: Float, y: Float, w: Float, h: Float ){
        surface.beginFill( 0xff0000, 0.3);
        surface.lineStyle( 2., 0xffa500, 0.2 );
        surface.moveTo( x, y );
        surface.lineTo( x+w, y );
        surface.lineTo( x+w, y+h );
        surface.lineTo( x, y+h );
        surface.lineTo( x, y );
        surface.endFill();
    }
    public function drawRectBorder(){
        var ll = new LongLatUK();
        var min = ll.ll_to_osOld( 50.10319, -7.64133);
        var max = ll.ll_to_osOld( 60.15456, 1.75159 );
        var x = min.east * scale + 100;
        var y = 500 - ( min.north ) * scale + 100;
        var w = ( max.east - min.east ) * scale + 100;
        var h = 500 - max.north * scale  - ( 500 - min.north * scale );
        surface.beginFill( 0x0000ff, 0.8 );
        surface.lineStyle( 2., 0xffa500, 1. );
        surface.moveTo( x, y );
        surface.lineTo( x+w, y );
        surface.lineTo( x+w, y+h );
        surface.lineTo( x, y+h );
        surface.lineTo( x, y );
        surface.endFill();
    }
    public function finished(){
        parseCSV();
        var str = '';
        for( i in statData ) {
            if( i.date.getDay() == 13 && i.totalCases > 0 ) {
                var lat:    Float = 0.;
                var long:   Float = 0.; 
                var east:   Float = 0.;
                var north:  Float = 0.;
                var found = false;
                for( pos in areaData ){
                    //trace(pos.admin_area + '   ' + i.area );
                    if( pos.admin_area.toLowerCase() == i.area.toLowerCase() ){
                        lat    = pos.latitude;
                        long   = pos.longitude;
                        east   = pos.east;
                        north  = pos.north;
                        found  = true;
                        break;
                    }
                }
                var size = i.totalCases;
                // flip north
                if( found ) drawRect( east * scale - size/2 + 100
                                    , 500 - north *scale - size/2
                                    , size, size );
                // if not found implement use of e_areas.
                str += ( i.date.getDay() + ' ' + months[ i.date.getMonth() - 1 ] + ','
                        + ' ' + i.area + ' ' + i.totalCases + ' ill, '
                        + '  lat ' + lat + ' long ' + long + ' east ' + Math.round( east ) + ' north ' + Math.round( north ) );
                str += '<br>';
            }
        }
        trace( str ); // collate traces it's much faster!
    }
    public function parseCSV(){
        var txtContents         = textLoader.contents;
        var adminStr            = txtContents.get( 'postcodeAdmin.csv' );
        var e_areaStr           = txtContents.get( 'E_areas.csv' ); // not really used.
        var covid19Str          = txtContents.get( 'covid19uk.csv');
        var eAreas              = CSV.parse( e_areaStr );
        eAreas.shift();         // remove title
        var areaLatLong         = CSV.parse( adminStr );
        areaLatLong.shift();    // remove title
        var covid19stats        = CSV.parse( covid19Str );
        covid19stats.shift();   // remove Title
        e_areas                 = new StringMap<String>();
        for( e in eAreas )                  e_areas.set( e[ 0 ], e[ 1 ] );
        for( i in 0...covid19stats.length ) statData[ i ] = covid19stats[ i ]; 
        for( i in 0...areaLatLong.length )  areaData[ i ] = areaLatLong[ i ];
    }
    function getAreas(){
        return e_areas.keys();
    }
}