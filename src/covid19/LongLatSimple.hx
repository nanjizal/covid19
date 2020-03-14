package covid19;

class LongLatSimple {
    var w: Float;
    var h: Float;
    public function new( w_: Float, h_: Float ){
        w = w_;
        h = h_;
    }
    public static inline function conversion( long: Float, lat: Float ): { x: Float, y: Float }{
        var x =  ((w/360) * (180 + long)) - 9;
        var y =  ((h/180) * (90 - lat)) - 18;
        return { x: x, y: y };
    }

}