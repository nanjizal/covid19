package covid19;
import htmlHelper.tools.TextLoader;
import htmlHelper.tools.CSV;
import haxe.ds.StringMap;
import covid19.datas.StatsC19;
import covid19.datas.LongLatAreas;
import datetime.DateTime;
import htmlHelper.tools.DivertTrace;
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
    public var e_areas:  StringMap<String>;
    public var statData = new Array<StatsC19>();
    public var areaData = new Array<LongLatAreas>();
    var textLoader:     TextLoader;
    var eAreas:         Array<Array<String>>;
    var areaLatLong:    Array<Array<String>>;
    var covid19stats:   Array<Array<String>>;
    var months = [ 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    public function new(){
        new DivertTrace();
        textLoader = new TextLoader( ['../data/postcodeAdmin.csv','../data/E_areas.csv','../data/covid19uk.csv' ], finished );
    }
    public function finished(){
        parseCSV();
        for( i in statData ) {
            if( i.date.getDay() == 13 && i.totalCases > 0 ) {
                var lat: Float = 0;
                var long: Float = 0; 
                for( pos in areaData ){
                    //trace(pos.admin_area + '   ' + i.area );
                    if( pos.admin_area.toLowerCase() == i.area.toLowerCase() ){
                        lat  = pos.latitude;
                        long = pos.longitude;
                        break;
                    }
                }
                trace( i.date.getDay() + ' ' + months[ i.date.getMonth() - 1 ] + ','
                        + ' ' + i.area + ' ' + i.totalCases + ' ill, '
                        + '  lat ' + lat + ' long ' + long );
            }
        }
    }
    public function parseCSV(){
        var txtContents = textLoader.contents;
        var adminStr = txtContents.get( 'postcodeAdmin.csv' );
        var e_areaStr = txtContents.get( 'E_areas.csv' );
        var covid19Str = txtContents.get( 'covid19uk.csv');
        var eAreas          = CSV.parse( e_areaStr );
        eAreas.shift(); // remove title
        var areaLatLong     = CSV.parse( adminStr );
        areaLatLong.shift(); // remove title
        var covid19stats    = CSV.parse( covid19Str );
        covid19stats.shift(); // remove Title
        e_areas = new StringMap<String>();
        for( e in eAreas ) e_areas.set( e[ 0 ], e[ 1 ] );
        for( i in 0...covid19stats.length ) statData[ i ] = covid19stats[ i ]; 
        for( i in 0...areaLatLong.length )  areaData[ i ] = areaLatLong[ i ];
    }
    public function getAreas(){
        return e_areas.keys();
    }
}