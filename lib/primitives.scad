// Derived from ShortCuts.scad 
// Autor: Rudolf Huttary, Berlin 2015

//--------------------------------------------------------------------------------------------
// primitives - 2D
//  square
//  circle
//  circle_half
//  circle_sector
//--------------------------------------------------------------------------------------------

module Sq(x = 10, y = undef, center = true)
{
    square([x, y?y:x], center = center); 
}

module Ci(r = 10, d=undef)
{ 
    circle(d?d/2:r);
} 

module CiH(r = 10, w = 0, d=undef)
  circle_half(r, w, d); 

module CiS(r = 10, w1 = 0, w2 = 90, d=undef)
  circle_sector(r, w1, w2, d); 


//--------------------------------------------------------------------------------------------
// primitives - 3d
//--------------------------------------------------------------------------------------------
 
module Cy(r = undef, h = 1, C = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
  cylinder(r=d?d/2:r, h=h, center=C, r1=d1?d1/2:r1, r2=d2?d2/2:r2); 


module Cu(x = 10, y = undef, z = undef, C = true)
  cube(x[0] == undef?[x, y?y:x, y?z?z:1:x]:x, center=C); 


module CuR(x = 10, y = undef, z = undef, r = 0, C = true)
  cube_rounded(x[0] == undef?[x, y?y:x, y?z?z:1:x]:x, r=r, center=C); 


module CyR(r = 10, h=10, r_=1, d = undef, r1=undef, r2=undef, d1 = undef, d2 = undef, C=false)  
  cylinder_rounded(r, h, r, d, r1, r2, d1, d2, C); 

//--------------------------------------------------------------------------------------------
// derived primitives - 3d
//--------------------------------------------------------------------------------------------

module CyH(r = 10, h = 1, w = 0, C = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
  Rz(w) cylinder_half(r=r, h=h, center=C, r1=r1, r2=r2, d=d, d1=d1, d2=d2); 

module CyS(r = 10, h = 1, w1 = 0, w2 = 90, C = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
  cylinder_sector(r=r, h=h, w1=w1, w2=w2, center=C, r1=r1, r2=r2, d=d, d1=d1, d2=d2); 

module Ri(R = 10, r = 5, h = 1, C = true, D=undef, d=undef)
  ring(R, r, h, C, D, d); 

module RiS(R = 10, r = 5, h = 1, w1 = 0, w2 = 90, C = true, D=undef, d=undef)
   ring_sector(R, r, h, w1, w2, C, D, d); 

module RiH(R = 10, r=5, h = 1, w = 0, C = true, D=undef, d=undef)
   ring_half(R, r, h, w, C, D, d); 


module Pie(r = 10, h = 1, w1 = 0, w2 = 90, C = true, d=undef)
  cylinder_sector(r, h, w1, w2, C, d);  


module Sp(r = 10)
  sphere(r); 


module SpH(r = 10, w1 = 0, w2 = 0)
  sphere_half(r, w1, w2); 


module To(R=10, r=1, r1 = undef, w=0, w1=0, w2=360) torus(R=R, r=r, r1=r1, w=w,w1=w1, w2=w2);  


module Col(r=1, g=1, b=1, t=1) 
{
  if(len(r)) 
    color(r, g) children(); 
  else
    color([r,g,b], t) children(); 
}

function Rg(N=10) = [for(i=[0:N-1]) i]; 

//

//--------------------------------------------------------------------------------------------
// clear text definitions
//--------------------------------------------------------------------------------------------

module cube_rounded(size, r=0, center=false)
{
  sz = size[0]==undef?[size, size, size]:size; 
  ce = center[0]==undef?[center, center, center]:center; 
  r_ = min(abs(r), abs(size.x/2), abs(size.y/2), abs(size.z/2)); 
  translate([ce.x?-sz.x/2:0,ce.y?-sz.y/2:0, ce.z?-sz.z/2:0])
  if(r)
    hull() 
    {
      translate([r_, r_, r_]) sphere(r_); 
      translate([r_, r_, sz.z-r_]) sphere(r_); 
      translate([r_, sz.y-r_, r_]) sphere(r_); 
      translate([r_, sz.y-r_, sz.z-r_]) sphere(r_); 
      translate([sz.x-r_, r_, r_]) sphere(r_); 
      translate([sz.x-r_, r_, sz.z-r_]) sphere(r_); 
      translate([sz.x-r_, sz.y-r_, r_]) sphere(r_); 
      translate([sz.x-r_, sz.y-r_, sz.z-r_]) sphere(r_); 
    }
  else 
    cube(size); 
}


module circle_half(r = 10, w = 0, d = undef)
{
  R= d?d/2:r;
	difference()
	{
		circle(R); 
     rotate([0, 0, w-90])
     translate([0, -R])
		square([R, 2*R], center = false); 
	}
}


module circle_sector(r = 10, w1 = 0, w2 = 90, d = undef)
{
  R = d?d/2:r; 
  W2 = (w1>w2)?w2+360:w2; 
  diff = abs(W2-w1);
  if (diff < 180)
    intersection()
		{
       circle_half(R, w1); 
       circle_half(R, W2-180); 
 		}
	else if(diff>=360)
    circle(R); 
  else
		{
       circle_half(R, w1); 
       circle_half(R, W2-180); 
 		}
}


module cylinder_half(r = 10, h = 1, center = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
{
  R = max(d?d/2:r, r1?r1:0, r2?r2:0, d1?d1/2:0, d2?d2/2:0);
  difference()
  {
    Cy(r=r, h=h, C=center, r1=r1, r2=r2, d=d, d1=d1, d2=d2);
    Ty(-(R+1)/2)
    Cu(2*R+1, R+1, h+1, C = center); 
  }
//  linear_extrude(height = h, center = center)
//  circle_half(r=r, w=w, d=d); 
} 


module cylinder_sector(r = 10, h = 1, w1 = 0, w2 = 90, center = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
{
  R = max(d?d/2:r, r1?r1:0, r2?r2:0, d1?d1/2:0, d2?d2/2:0);
    intersection()
    {
      Cy(r=r, h=h, C=center, r1=r1, r2=r2, d=d, d1=d1, d2=d2);
      cylinder_sector_(r=R, h=h, w1=w1, w2=w2, center=center);
    }
}


module cylinder_sector_(r = 10, h = 1, w1 = 0, w2 = 90, center = true)
  linear_extrude(height = h, center = center, convexity = 2)
  circle_sector(r=r, w1=w1, w2=w2); 


module cylinder_rounded(r=10, h=10, r_=1, d=undef, r1=undef, r2=undef, d1=undef, d2=undef, center=true)
{
  r1 = r1==undef?d1==undef?d==undef?r:d/2:d1/2:r1;
  r2 = r2==undef?d2==undef?d==undef?r:d/2:d2/2:r2;
  r_ = min(abs(h/4), abs(r1), abs(r2), abs(r_));
  h = abs(h);
  Tz(center?-h/2:0) rotate_extrude() I()
  {
    offset(r_)offset(-r_) polygon([[-2*r_,0], [r1, 0], [r2, h], [0,h], [-2*r_,h]] );
    Sq(max(r1,r2), h, 0);
  }
} 


module ring(R = 10, r = 5, h = 1, center = true, D=undef, d=undef)
  linear_extrude(height = h, center = center, convexity = 2)
	difference()
	{
    Ci(r = D?D/2:R); 
    Ci(r = d?d/2:r); 
	}


module ring_half(R = 10, r = 5, h = 1, w = 0, center = true, D=undef, d=undef)
  linear_extrude(height = h, center = center, convexity = 2)
  Rz(w)
	difference()
	{
    CiH(r = D?D/2:R); 
    Ci(r = d?d/2:r); 
	}


module ring_sector(R = 10, r = 5, h = 1, w1 = 0, w2 = 90, center = true, D=undef, d=undef)
  linear_extrude(height = h, center = center, convexity = 2)
	difference()
	{
    CiS(r = D?D/2:R, w1 = w1, w2 = w2); 
    Ci(r = d?d/2:r); 
	}


module sphere_half(r = 10, w1 = 0, w2 = 0)
  R(w1, w2)
	intersection() {
   	sphere(r);
    Tz(r) Cu(2*r); 
	}


module torus(R=10, r=1, r1 = undef, w=0, w1=0, w2=360)
{
  if (r1)
    D(){
      To(R=R, r=r, w=w, w1=w1, w2=w2); 
      To(R=R, r=r1, w=w, w1=w1-1, w2=w2+1); 
    }
  else
    Rz(w1)
    rotate_extrude(angle = w2-w1)
    T(R)
    Rz(w)
    circle(r); 
    
}


//--------------------------------------------------------------------------------------------
// additional code
//--------------------------------------------------------------------------------------------

module place_in_rect(dx =20, dy=20)
{
  cols = ceil(sqrt($children)); 
  rows = floor(sqrt($children)); 
  for(i = [0:$children-1])
	{ 
	  T(dx*(-cols/2+(i%cols)+.5), dy*(rows/2-floor(i/cols)-.5))
		 children(i); 
	}
}


module measure(s=10, x=undef, y=undef, z=undef)
{
  p=[[s, s, 0], [-s, s, 0], [-s, -s, 0], [s, -s, 0]]; 
  C("black",.5)
  {
    if(z) Tz(z) polyhedron(p, [[0,1,2,3]]); 
    if(x) Tx(x) Ry(90)polyhedron(p, [[0,1,2,3]]); 
    if(y) Ty(y) Rx(90) polyhedron(p, [[0,1,2,3]]); 
  }
}

