package covid19.datas;
import datetime.DateTime;
@:structInit
class InternalDayCounter {
    public var day:   Int;
    public var month: Int;
    public var year:  Int;
    function new( day:       Int
                , month:     Int
                , year:      Int ){
        this.day              = day;
        this.month            = month;
        this.year             = year;
    }
}
@:forward
abstract DayCounter( InternalDayCounter ) from InternalDayCounter to InternalDayCounter {
    public inline
    function new( v: InternalDayCounter ){ this = v; }
    public inline
    function hasNext(){
        return true;
    }
    public inline
    function next(){
        var isLeap = DateTime.isLeap( this.year );
        var dayTot = DateTime.daysInMonth( this.month, isLeap );
        this.day++;
        if( this.day > dayTot ) {
            this.day = 1;
            this.month++;
            if( this.month > 12 ) {
                this.month = 1;
                this.year++;
            }
        }
    }
    public inline
    function matchDate( date: DateTime ){
        return date.getDay() == this.day && date.getMonth() == this.month && date.getYear() == this.year;
    }
}