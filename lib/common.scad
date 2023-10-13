
// Subsection: Block Unit Translation Shortcuts
// Modified from Rudolf Huttary's [shortcuts.scad](https://www.thingiverse.com/thing:644830)

// Module: BU_T()
// Usage:
//   BU_T(x, y, z);
//   BU_T([x, y, z]);
// Description:
//   Shortcut for translate([x * BU, y * BU, z * BU])
module BU_T(x=0, y=0, z=0)
{
  translate(x[0]==undef?[x, y, z]* BU:x * BU)children(); 
}

// Module: BU_TK()
// Usage:
//   BU_TK(x, y, z);
//   BU_TK([x, y, z]);
// Description:
//   Children at origin and translation.
// Example(3D): One block unit cube centered at origin and one at [3 * BU, 0, 0]
//   BU_TK(3, 0 , 0) BU_cube();
module BU_TK(x=0, y=0, z=0)
{
  children(); 
  
  BU_T(x, y, z)
    children(); 
}

// Module: BU_Tx()
// Usage: BU_Tx(x)
// Description:
//   Shortcut for translate([x * BU, 0, 0])
module BU_Tx(x)
{
  translate([x * BU, 0, 0])
    children();
}

// Module: BU_Ty()
// Usage: BU_Ty(y)
// Description:
//   Shortcut for translate([0, y * BU, 0])
module BU_Ty(y)
{
  translate([0, y * BU, 0])
    children();
}

// Module: BU_Tz()
// Usage: BU_Tz(z)
// Description:
//   Shortcut for translate([0, 0, z * BU])
module BU_Tz(z)
{
  translate([0, 0, z * BU])children();
}

// Module: BU_TKx()
// Usage: BU_TKx(x)
// Description:
//   Alternative for BU_TK(x=x)
module BU_TKx(x)
{
  BU_TK(x=x)
    children();
}

// Module: BU_TKy()
// Usage: BU_TKy(z)
// Description:
//   Alternative for BU_TK(y=y)
module BU_TKy(y)
{
  BU_TK(y=y)
    children();
}

// Module: BU_TKz()
// Usage: BU_TKz(z)
// Description:
//   Alternative for BU_TK(z=z)
module BU_TKz(z)
{
  BU_TK(z=z)
    children();
}



// Module: BU_slot()
// Usage:
//   BU_slot(length);
//
// Description:
//   Create a 2D slot profile with radius {{BU}}/2
//
// Arguments:
//   l = Length of slot in block units (BU).
//
// Example(2D):
//   BU_slot(2);

//module BU_slot(length)
//{
//  slot(length);
//}

//----------------------------------------------------------------------

// Module: slot()
// Usage:
//   BU_slot(length, r);
//
// Description:
//   Create a 2D slot profile.
//
// Arguments:
//   length = Length of slot in block units.
//
// Example(2D):
//   BU_slot(2, r = 2 + Clearance);
//
module BU_slot(length, r = BU/2)
{
  hull()
  {
    MKx()
      BU_Tx(length / 2 - 1 / 2)
        Ci(r = r);
  }
}

//----------------------------------------------------------------------

module cross_helper(num = 4)
{
  for(i = [0: min(3, num - 1)])
  {
    Rz(-90 * i)
    D()
    {
      children(i);

      if(num > 1)
      {
        if(num != 2 || i != 1)
          Rz(num == 3 && i == 2?0:45)BU_Tx(-1)Cu(BU * 2);
        if(num != 2 || i != 0)
          Rz(num == 3 && i == 0?0:-45)BU_Tx(-1)Cu(BU * 2);
      }
    }
  }
}

/// https://www.thingiverse.com/thing:644830
/// ShortCuts.scad 
/// Author: Rudolf Huttary, Berlin 2015
/// Update: Dario Pellegrini, Padova (IT) 2019/8
///

/// Euclidean Transformations

module T(x=0, y=0, z=0){
  translate(x[0]==undef?[x, y, z]:x)children(); }
module TK(x=0, y=0, z=0){ children(); T(x,y,z) children(); }
  
module Tx(x) { translate([x, 0, 0])children(); }
module Ty(y) { translate([0, y, 0])children(); }
module Tz(z) { translate([0, 0, z])children(); }
module TKx(x) { TK(x=x) children(); }
module TKy(y) { TK(y=y) children(); }
module TKz(z) { TK(z=z) children(); }

module R(x=0, y=0, z=0) rotate( is_list(x)? x : [x, y, z]) children();
module Rx(x=90) for(i=(is_list(x)?x:[x])) R([i, 0, 0]) children();
module Ry(y=90) for(i=(is_list(y)?y:[y])) R([0, i, 0]) children();
module Rz(z=90) for(i=(is_list(z)?z:[z])) R([0, 0, i]) children();


module M(x=0, y=0, z=0) mirror( is_list(x)? x : [x, y, z]) children(); 
module Mx() M([1, 0, 0]) children(); 
module My() M([0, 1, 0]) children(); 
module Mz() M([0, 0, 1]) children(); 

module RK(x=0, y=0, z=0){children(); rotate( is_list(x)? x : [x, y, z]) children();}
module RKx(x=90) Rx(concat(0,x)) children();
module RKy(y=90) Ry(concat(0,y)) children();
module RKz(z=90) Rz(concat(0,z)) children();

module MK(x=0, y=0, z=0) {children(); mirror( is_list(x)? x : [x, y, z]) children();} 
module MKx() MK([1, 0, 0]) children(); 
module MKy() MK([0, 1, 0]) children(); 
module MKz() MK([0, 0, 1]) children(); 

module S(x=1, y=undef, z=undef){ scale(x[0]==undef?[x, y?y:x, z?z:y?1:x]:x) children();}
module Sx(x=1){scale([x, 1, 1]) children();}
module Sy(y=1){scale([1, y, 1]) children();}
module Sz(z=1){scale([1, 1, z]) children();}

module Skew(x=0, y=0, z=0, a=0, b=0, c=0)
  multmatrix([[1, a, x], [b, 1, y], [z, c, 1]]) children(); 
module skew(x=0, y=0, z=0, a=0, b=0, c=0) 
  Skew(x, y, z, a, b, c) children();
module SkX(x=0) Skew(x=x) children();
module SkY(y=0) Skew(y=y) children();
module SkZ(z=0) Skew(z=z) children();
module SkewX(x=0) Skew(x=x) children();
module SkewY(y=0) Skew(y=y) children();
module SkewZ(z=0) Skew(z=z) children();

module LiEx(h=1, tw = 0, sl = 20, sc = 1, C=true) linear_extrude(height=h, twist = tw, slices = sl, scale = sc, center=C) children();

// Booleans
module D() if($children >1) difference(){children(0); children([1:$children-1]);} else children(); 
module U() children([0:$children-1]);
module I() intersection_for(n=[0:$children-1]) children(n); 

// rotates N instances of children around z axis
module rotN(r=10, N=4, offs=0, M=undef) for($i=[0:(M?M-1:N-1)])  rotate([0,0,offs+$i*360/N])  translate([r,0,0]) children();
module forN(r=10, N=4, offs=0, M=undef) rotN(r, N, offs, M) children();
module forX(dx = 10, N=4) for(i=[0:N-1]) T(-((N-1)/2-i)*dx) children(); 
module forY(dy = 10, M=4) for(i=[0:M-1]) Ty(-((M-1)/2-i)*dy) children(); 
module forZ(dz = 10, M=4) for(i=[0:M-1]) Tz(-((M-1)/2-i)*dz) children(); 
module forXY(dx = 10, N=4, dy = 10, M=4) forX(dx, N) forY(dy, M) children(); 


