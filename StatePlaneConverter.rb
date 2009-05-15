#
# DANGER: This is a quick prototype ONLY. Please do not use this
# code for production purposes!!!
#
# This was a proof of concept, an answer to a gauntlet being dropped.
# It may not handle all corner cases, but should work fine for the 
# Seattle area. The formulas were derived from the code for the
# PROJ.4 - Cartographic Projections Library http://trac.osgeo.org/proj/
#
# This class will convert  Washington North State Plane coordinates to 
# Lat and Long.
# 

class StatePlaneConverter
  
  #
  # Some standard Constants
  #
  DEGREES_PER_RADIAN = Math::PI / 180;
  FEET_TO_METERS = 0.30480060960121902
  RAD_TO_DEG = 57.29577951308232
  PI4 = 3.141592653582 / 4          
  
  # 
  # Constants for NAD83
  #
  A = 6378137                # major radius of ellipsoid, map units (NAD 83)
  E = 0.081819191042810976          # eccentricity of ellipsoid (NAD 83)
  RA = 1.0 / A.to_i
  
  #
  # Constants for Washington North State Plane
  #
  LATITUDE_OF_ORIGIN = 47.0;
  LATITUDE_OF_STD_PARALLEL_1 = 47.5000;
  LATITUDE_OF_STD_PARALLEL_2 = 48.7333;
  LONGITUDE_OF_CENTRAL_MERIDIAN = -120.8333;
  FALSE_EASTING = 500000.0;
  FALSE_NORTHING = 0

  #
  # Constants from cs2cs
  #
  RHO0 = 0.91778815723643037 # from cs2cs
  TOL=1.0e-10
  N_ITER=15
  N = 0.74452032655300449  # From cs2cs
  ELLIPS = -6.2774359784998874e66
  C = 1.8297520978156674
  LAM0 = -2.1089395128264816
  HALFPI= Math::PI / 2
  TWOPI =  2 * Math::PI

  
  def to_lat_long(x,y)
    x = (x.to_i * FEET_TO_METERS - FALSE_EASTING)  * RA
    y = (y.to_i * FEET_TO_METERS - FALSE_NORTHING) * RA

    y = RHO0 - y
    rho = hypot(x,y)

    if(rho != 0)
      if(N < 0.0)
        abort "N<0 Shouldn't get here"
        # Unless N changes, we don't need to worry about this
      end
      phi = phi2( ((rho / C) ** (1.0/N)), E)
    
      lam = Math.atan2(x, y) / N
    else
      abort "ERROR: Not sure if N needs to be recalculated here. Hope this doesn't hit!"
  		lam = 0.0
  		phi = N > 0.0 ? HALFPI : - HALFPI;
    end

    lam += LAM0
    lam = adjlon(lam)

    lam *= RAD_TO_DEG
    phi *= RAD_TO_DEG

    lat = phi
    lon = lam
    
    return lat, lon
  end

  ###############################################################################
                                        private
  ###############################################################################

  def hypot(x, y)
    Math.sqrt(x**2 + y**2)
  end
  
  def phi2(ts, e)
    eccnth = 0.5 * e;
  	phi = HALFPI - 2.0 * Math.atan(ts);
  	i = N_ITER;
  	
  	begin
  		con = e * Math.sin(phi);
  		tmp = (1.0 - con) / (1.0 + con)
  		pow = tmp ** eccnth
  		dphi = HALFPI - 2.0 * Math.atan(ts * pow) - phi;
  		phi += dphi;
  	end while ( dphi.abs > TOL && (i -= 1) )
  
  	return phi
  end


  def adjlon (lon) 
    if (lon.abs <= Math::PI) 
      return lon
    end
      
    lon += Math::PI 
    lon -= TWOPI * Math.floor(lon / TWOPI) 
    lon -= Math::PI 
    return lon
  end
  
  
end
