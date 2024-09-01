
declare sub home()  'G0 to (0,0,0). Does not use endstops.
declare sub drawLine(a as double, b  as double, c as double, d as double)
declare sub drawTo(a as double, b  as double)
declare sub drawToCont(a as double, b  as double)
declare sub moveTo overload(a as double, b  as double)
declare sub moveTo overload(a as double, b  as double, C as double)
declare sub laser()
declare sub laserP(power as integer)
declare sub noLaser()
declare sub setSpeed(speed as integer)
declare sub drawCircle(x as double, y as double, r as double)
declare sub drawBox(x as double, y as double, a as double, b as double)


'Main code (test area)
'=====================

'UNCOMMENT THE FOLLOWING LINE AND SET A FILE PATH+NAME
'const OUTFILE="d:\Spirograph_test.gcode"

open OUTFILE for output as #1

laserP(800)
setSpeed(1200)

'2024-08-31: With light (treated?) wood sheets, 30-40% power and speed 600
'works well for line drawings (Spirograph style)

const OUTERRADIUS=30
const INNERRADIUS=15
'const POINTRADIUS=10
const PI=3.141592653589793238462643383279

const SCALE=2.5

dim as double theta, xi, yi, xp, yp
dim as double pointradius


for pointradius=-15 to 15 step 1
   noLaser()
   moveTo((OUTERRADIUS-INNERRADIUS+POINTRADIUS)*SCALE,0)
   laser()
   for theta=0.000 to PI*2 step 0.001
      xi=(OUTERRADIUS-INNERRADIUS)*cos(theta)
      yi=(OUTERRADIUS-INNERRADIUS)*sin(theta)
      xp=xi+POINTRADIUS*cos(-theta*(OUTERRADIUS/INNERRADIUS))
      yp=yi+POINTRADIUS*sin(-theta*(OUTERRADIUS/INNERRADIUS))
      drawToCont(xp*SCALE,yp*SCALE)
      next theta

   next pointradius

noLaser()

close #1

end



'Subroutines beyond this point
'=============================

sub home()
   print #1,"G0 X0 Y0 Z0"
   end sub
   
sub drawLine(a as double, b  as double, c as double, d as double)
   noLaser()
   print #1,"G0 X";int(64*a)/64;" Y";int(64*b)/64
   laser()
   print #1,"G1 X";int(64*c)/64;" Y";int(64*d)/64
   noLaser()
   end sub   

sub drawTo(a as double, b  as double)
   laser()
   print #1,"G1 X";int(64*a)/64;" Y";int(64*b)/64
   noLaser()
   end sub      

sub drawToCont(a as double, b  as double)
   print #1,"G1 X";int(64*a)/64;" Y";int(64*b)/64
   end sub      

sub moveTo(a as double, b  as double)
   noLaser()
   print #1,"G0 X";int(64*a)/64;" Y";int(64*b)/64
   end sub      

sub moveTo overload(a as double, b  as double, c as double)
   noLaser()
   print #1,"G0 X";int(64*a)/64;" Y";int(64*b)/64;" Z";int(64*c)/64
   end sub      

sub laser()
   print #1,"M4"
   end sub   

sub laserP(power as integer)
   print #1,"M4 S";power
   end sub   

sub noLaser()
   print #1,"M5"
   end sub   
   
sub setSpeed(speed as integer)
   print #1,"F ";speed
   end sub   

sub drawCircle(x as double, y as double, r as double)
   dim as double theta,xx,yy
   dim as double dt
   'We want segments to be under 100um, so we'll aim for 50um ones.
   dt=0.05/r
   moveTo(x+r,y)
   laser()
   for theta=0.00 to 6.28 step dt
      xx=x+r*cos(theta)
      yy=y+r*sin(theta)
      drawToCont(xx,yy)
      next theta
   noLaser()
   end sub   

sub drawBox(x as double, y as double, a as double, b as double)
   drawLine(x,y,a,y)
   drawLine(a,y,a,b)
   drawLine(a,b,x,b)
   drawLine(x,b,x,y)
   end sub   
      