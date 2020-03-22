package covid19.datas;
import haxe.ds.StringMap;
using StringTools;
@:forward
abstract Area9Arr( Array<Area9> ) from Array<Area9> to Array<Area9> {
    public inline
    function new( v: Array<Area9> ){ this = v; }
    @:from
    public inline static 
    function fromArrayArray( arr: Array<Array<String>> ){
        var arr9 = new Array<Area9>();
        for( i in 0...arr.length ) arr9[ i ] = arr[ i ];
        return new Area9Arr( arr9 );
    }
    @:to
    public inline
    function getMapPlaceArea():StringMap<String> {
        var stringMap = new StringMap<String>();
        for( i in 0...this.length ){
            stringMap.set( this[ i ].place, this[ i ].area9 );
        }
        return stringMap;
    }
    @:to
    public inline
    function getMapAreaPlace():StringMap<String> {
        var stringMap = new StringMap<String>();
        for( i in 0...this.length ){
            stringMap.set( this[ i ].area9, this[ i ].place );
        }
        return stringMap;
    }
    public inline
    function area9exists( str: String ){
        return getMapAreaPlace().exists( str );
    }
    public inline
    function getPlace( str: String ){
        return getMapAreaPlace().get( str );
    }
    // general function to find close matches
    public inline
    function getContains( str: String ){
        var v = new Array<Area9>();
        var j = 0;
        for( i in this ){
            if( ( i.place ).contains( str ) ){
                v[j++] = i;
            }
        }
        return new Area9Arr( v );
    }
    public inline
    function getContainedBy( str: String ){
        var v = new Array<Area9>();
        var j = 0;
        for( i in this ){
            if( str.contains( i.place ) ){
                v[j++] = i;
            }
        }
        return new Area9Arr( v );
    }
    public inline
    function getWordContains( str: String ){
        var v = new Array<Area9>();
        var j = 0;
        var words = str.split(' ');
        for( word in words ){
            if( word.length > 3 ){ // ignore very short words.
                for( i in this ){
                    if( i.place.contains( word ) ){
                        v[j++] = i;
                        break; // just get one match per word
                    }
                }
            }
        }
        return new Area9Arr( v );
    }
    public inline
    function getWordContainedBy( str: String ){
        var v = new Array<Area9>();
        var j = 0;
        for( i in this ){
            var words = i.place.split(' ');
            for( word in words ){
                if( word.length > 3 ){ // ignore very short words.
                    if( str.contains( word ) ){
                        v[j++] = i;
                        break; // just get one match per word
                    }
                }
            }
        }
        return new Area9Arr( v );
    }
}