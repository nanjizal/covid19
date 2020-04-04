package covid19.datas;
import datetime.DateTime;
@:structInit
class InternalDayCounter {
    public var day:   Int;
    public var month: Int;
    public var year:  Int;
    public
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
    function cloneInternal(): InternalDayCounter {
        return { day: this.day, month: this.month, year: this.year };
    }
    public inline
    function matchDate( date: DateTime ){
        return date.getDay() == this.day && date.getMonth() == this.month && date.getYear() == this.year;
    }
    public inline
    function matchDayCounter( dayCount: InternalDayCounter ){
        return dayCount.day == this.day && dayCount.month == this.month && dayCount.year == this.year;
    }
    public static inline
    function months(i:Int){
        return [ 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][i-1];
    }
    public inline
    function pretty(): String {
        return this.day + ' ' + months( this.month );
    }
    public static inline
    function datePretty( date: DateTime ): String {
        return date.getDay() + ' ' + months( date.getMonth() );
    }
}