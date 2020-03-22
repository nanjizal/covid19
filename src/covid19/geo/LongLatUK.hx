package covid19.geo;
/* source https://scipython.com/book/chapter-2-the-core-python-language-i/additional-problems/converting-between-an-os-grid-reference-and-longitudelatitude/
*/
class LongLatUK {
    // datum_ellipsoid
    public var osgb36_a = 6377563.396;
    public var osgb36_b = 6356256.909;
    public var wgs84_a = 6378137.;
    public var wgs84_b = 6356752.3141;
    // Transverse Mercator projection parameters: Map coordinates of true origin,
    // (E0, N0), scale factor on central meridian, F0, true origin (phi0, lambda0).
    var n0 = -100000.;
    var e0 = 400000.;
    var f0 = 0.9996012717;
    var phi0 = (49*Math.PI/180);
    var lambda0 = (-2*Math.PI/180);
    
    function fM( phi: Float, a: Float, b: Float): Float {
    //Return the parameter M for latitude phi using ellipsoid params a, b."""
     var n = (a-b)/(a+b);
     var n2 = Math.pow( n, 2 );
     var n3 = n * n2;
     var dphi = phi - phi0;
     var sphi = phi + phi0;
     return b * f0 * (
                (1 + n + 5/4 * (n2+n3)) * dphi
              - (3*n + 3*n2 + 21/8 * n3) * Math.sin(dphi) * Math.cos(sphi)
              + (15/8 * (n2 + n3)) * Math.sin(2*dphi) * Math.cos(2*sphi)
              - (35/24 * n3 * Math.sin(3*dphi) * Math.cos(3*sphi))
            );
    }
    public function os_to_llOld( e: Float, n: Float ): { lat: Float, long: Float }{
        return os_to_ll( e, n, osgb36_a, osgb36_b );
    }
    public function os_to_llNew( e: Float, n: Float): { lat: Float, long: Float }{
        return os_to_ll( e, n, wgs84_a, wgs84_b );
    }
    function os_to_ll( e: Float, n: Float, a: Float, b: Float ): { lat: Float, long: Float }{
        // Convert from OS grid reference (E, N) to latitude and longitude.
        // Latitude, phi, and longitude, lambda, are returned in degrees.
        var a2 = Math.pow( a, 2 );
        var e2 = ( a2 - Math.pow( b, 2 ))/ a2;
        var m = 0.; 
        var phip = phi0;
        while( Math.abs( n-n0-m) >= 0.00001 ){
            phip = ( n - n0 - m)/( a* f0 ) + phip;
            m = fM( phip, a, b );
        }
        var rho = a * f0 * ( 1 - e2 ) * Math.pow( 1 - Math.pow( e2*Math.sin( phip ), 2 ) ,-1.5 );
        var nu = a * f0 / Math.sqrt( 1 - e2 * Math.pow( Math.sin(phip),2) );
        var eta2 = nu/rho - 1;
        var tan_phip = Math.tan( phip );
        var tan_phip2 = Math.pow( tan_phip, 2 );
        var nu3 = Math.pow( nu, 3 );
        var nu5 = Math.pow( nu, 5 );
        var sec_phip = 1./Math.cos(phip);
        var c1 = tan_phip/2/rho/nu;
        var c2 = tan_phip/24/rho/nu3 * (5 + 3*tan_phip2 + eta2 * (1 - 9*tan_phip2));
        var c3 = tan_phip / 720/rho/nu5 * (61 + tan_phip2*(90 + 45 * tan_phip2));
        var d1 = sec_phip / nu;
        var d2 = sec_phip / 6 / nu3 * (nu/rho + 2*tan_phip2);
        var d3 = sec_phip / 120 / nu5 * (5 + tan_phip2*(28 + 24*tan_phip2));
        var d4 = sec_phip / 5040 / Math.pow( nu, 7 ) *  (61 + tan_phip2*(662 + tan_phip2* (1320 + tan_phip2*720)));
        var eme0 = e - e0;
        var eme02 = Math.pow( eme0, 2 );
        var phi = phip + Math.pow( eme0, 2 ) * (-c1 + eme02*(c2 - c3*eme02));
        var lam = lambda0 + eme0 * (d1 + eme02*(-d2 + eme02*(d3 - d4*eme02)));
        return { lat: phi*180/Math.PI, long: lam*180/Math.PI };
    }
    public function ll_to_osOld( phi: Float, lam: Float ): EastNorth {
        return ll_to_os( phi, lam, osgb36_a, osgb36_b );
    }
    public function ll_to_osNew( phi: Float, lam: Float ): EastNorth {
        return ll_to_os( phi, lam, wgs84_a, wgs84_b );
    }
    public function ll_to_os( phi: Float, lam: Float, a: Float, b: Float ): EastNorth {
        // Convert from latitude and longitude to OS grid reference (E, N).
        // Latitude, phi, and longitude, lambda, are to be provided in degrees.
        var phi = phi*Math.PI/180;
        var lam = lam*Math.PI/180;
        var a2 = Math.pow( a, 2 );
        var e2 = ( a2 - Math.pow( b,2 ))/ a2;
        var rho = a * f0 * ( 1 - e2 ) * Math.pow( 1 - Math.pow( e2*Math.sin( phi ), 2 ),-1.5 );
        var nu = a * f0 / Math.sqrt( 1 - e2 * Math.pow( Math.sin(phi),2) );
        var eta2 = nu/rho - 1;
        var m = fM( phi, a, b );
        var sin_phi = Math.sin(phi);
        var cos_phi = Math.cos(phi);
        var cos_phi2 = Math.pow( cos_phi, 2 );
        var cos_phi3 = cos_phi2 * cos_phi;
        var cos_phi5 = cos_phi3 * cos_phi2;
        var tan_phi2 = Math.pow( Math.tan(phi), 2 );
        var tan_phi4 = tan_phi2 * tan_phi2;
        var a1 = m + n0;
        var a2 = nu/2 * sin_phi * cos_phi;
        var a3 = nu/24 * sin_phi * cos_phi3 * (5 - tan_phi2 + 9*eta2);
        var a4 = nu/720 * sin_phi * cos_phi5 * (61 - 58*tan_phi2 + tan_phi4);
        var b1 = nu * cos_phi;
        var b2 = nu/6 * cos_phi3 * (nu/rho - tan_phi2);
        var b3 = nu/120 * cos_phi5 * (5 - 18*tan_phi2 + tan_phi4 + eta2*(14 - 58*tan_phi2));
        var lml0 = lam - lambda0;
        var lml02 = Math.pow( lml0, 2 );
        var n = a1 + lml02 * (a2 + lml02*(a3 + a4*lml02));
        var e = e0 + lml0 * (b1 + lml02*(b2 + b3*lml02));
        return { east: e, north: n };
    }
    public function new( ){}
}