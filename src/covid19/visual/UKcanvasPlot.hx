package covid19.visual;
import covid19.geo.EastNorth;
import htmlHelper.canvas.Surface;
import covid19.geo.LongLatUK;
class UKcanvasPlot {
    var minX        = 50.10319;
    var minY        = -7.64133;
    var maxX        = 60.15456;
    var maxY        = 1.75159;
    public var alpha       = 0.3;
    public var scale       = 1/2000;
    public var sizeScale   = ( 1/(1.8 * 10) );
    public var colorChange = ( 1/22 );
    public var surface:    Surface;
    public function new( surface: Surface ){
        this.surface = surface;
    }
    public inline
    function toXY( east: Float, north: Float ){
        return { x: east * scale + 100, y: 500 - north * scale };// flip north
    }
    public
    function plot( eastNorth: EastNorth, cases: Int, colors: Array<Int> ){
        var size      = cases*sizeScale;
        var fillColor = colors[ Math.round( cases*colorChange ) ];
        var p = toXY( eastNorth.east, eastNorth.north );
        var radius = size * 0.5;
        circle36( fillColor, alpha, p.x, p.y, radius );
    }
    public 
    function drawRectBorder(){
        var ll = new LongLatUK();
        var min = ll.ll_to_osOld( minX, minY );
        var max = ll.ll_to_osOld( maxX, maxY );
        var x = min.east * scale + 100;
        var y = 500 - ( min.north ) * scale + 100;
        var w = ( max.east - min.east ) * scale + 100;
        var h = 500 - max.north * scale  - ( 500 - min.north * scale );
        surface.beginFill( 0x0000ff, 0. );
        surface.lineStyle( 2., 0xf0f0f0, 1. );
        surface.moveTo( x, y );
        surface.lineTo( x+w, y );
        surface.lineTo( x+w, y+h );
        surface.lineTo( x, y+h );
        surface.lineTo( x, y );
        surface.endFill();
    }
    public inline
    function circle36( fillColor: Int, fillAlpha: Float
                   , ax: Float, ay: Float
                   , radius: Float ): Int {
        var theta = ( Math.PI/2 );
        var step = (Math.PI*2/36);
        var bx: Float;
        var by: Float;
        var cx: Float;
        var cy: Float;
        surface.beginFill( fillColor, fillAlpha );
        surface.lineStyle( 2., 0xffa500, 0. );
        for( i in 0...36 ){
            bx = ax + radius*Math.sin( theta );
            by = ay + radius*Math.cos( theta );
            theta += step;
            cx = ax + radius*Math.sin( theta );
            cy = ay + radius*Math.cos( theta );
            add2DTriangle( ax, ay, bx, by, cx, cy );
        }
        surface.endFill();
        return 36;
    }
    public inline
    function add2DTriangle( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ){
        surface.moveTo( ax, ay );
        surface.lineTo( bx, by );
        surface.lineTo( cx, cy );
        surface.lineTo( ax, ay );
    }
}