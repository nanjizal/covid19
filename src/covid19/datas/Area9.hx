package covid19.datas;
@:structInit
class InternalArea9 {
    public var area9: String;
    public var place:     String;
    function new( area9:       String
                , place:      String ){
        this.area9              = area9;
        this.place              = place;
    }
}
@:forward
abstract Area9( InternalArea9 ) from InternalArea9 to InternalArea9 {
    public inline
    function new( v: InternalArea9 ){ this = v; }
    @:from
    public inline static 
    function fromArray( arr: Array<String> ){
        return new Area9( { area9: StringTools.trim( arr[0] )
                          , place: StringTools.trim( arr[1] )
                          } );
    }
}