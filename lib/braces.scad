/*
Subsection: braces
Derived from https://github.com/Cantareus/Stemfie_OpenSCAD

Modules:
    brace(size, <h=>, <holes=>);
    brace_cross(lengths = [2,2,2,2], h = 0.25);
    brace_arc(r, angle, h = 0.25, holes = 2);   
    brace_plate(size=[2,2], h=1/4, holes=true);
    
230715  brace_plate
231011  update - doplneny parameter center pre brace_plate
        update - doplneny parameter center pre brace
        update - brace_arc posunuty do z=0
*/


/*
Module: brace()

    Usage: 
        brace(size, <h=1/4>, <holes=true>);

    Description:
        Creates a Stemfie brace with holes.

    Arguments:
        size   = length of brace to create in block units.
        h      = height of brace
        holes = set to false to create blank brace.

    Example(3D): Standard Stemfie brace
        brace(3);

    Example(3D): Double thickness blank brace
        brace(3, h = 0.5, holes = false);
*/
module brace(size, h = 0.25, holes = true, center=false)
{
  //BU_Tz(h/2)                // update, posun do polohy z=0
  //BU_Tx((size-1)/2)  
  T(center?0:(([size, 0, 0] - [1,0,0]) * BU / 2 + [0, 0, h/2]*BU))
  D()
  {
    U()
    {
        LiEx(BU * h )
        BU_slot(size);
    }
    if(holes)
      hole_grid([size,1], h*1.05);
  }
}

//----------------------------------------------------------------------

// Module: brace_cross()
// Usage: 
//   brace_cross(lengths = [2,2,2,2], <h=1/4>);
//
// Description:
//   Overlaps two Stemfie brace. It can be used to create 'V', 'L', 'T' and 'X' shapes.
//
// Arguments:
//   lengths = Array of 2, 3 or 4 integers. Lengths extending from intersection block 
//             with clockwise ordering.
//   h       = height of brace, default = 1/4 BU
//
// Example(3D): 'V' brace
//   brace_cross([3,3]);
//
// Example(3D): 'L' brace
//   brace_cross([5,3]);
//
// Example(3D): 'T' brace
//   brace_cross([2,3,2]);
//
// Example(3D): Double thickness 'X' brace
//   brace_cross([1, 1, 1, 1], 0.5);
module brace_cross(lengths = [2,2,2,2], h = 0.25)
{
    for(i = [0: len(lengths)-1])
    {
        Rz(90 * i) 
        BU_Tx(lengths[i]/2)
        brace(lengths[i] + 1,   center = true);
    }
}


// Module: brace_arc()
// Usage:
//   brace_arc(r, angle, <h = 1/4>, <holes = 2> );
//
// Description:
//   Creates a circular arc brace. Detects when hole spacing is less than 
//   1 block unit and reduces the number of holes as necessary. If the angle is
//   too big and the end point overlaps the start point then the angle is set to 360
//   and a circular brace is created.
//
// Arguments:
//   r     = Radius in block units to the center of the brace.
//   angle = Angle between start and end points.
//
// Example(3D): Holes with 60 degree spacing have 1 radius spacing.
//   brace_arc(2, 120, holes = 3);
//
// Example(3D): Number of holes are reduced to fit of brace.
//   brace_arc(3, 360, holes = 100);
//
// Example(3D): Angle adjusted to 360 to prevent overlap.
//   brace_arc(3, 350, holes = 12);


module brace_arc(r, angle, h = 0.25, holes = 2)
{
  BU_Tz(-h/2)
  {
      // kontrola priemeru, r>1
      r = r<1 ? 1: r;
      
      //If the remaining angle leaves a distance less than 1BU increase the angle to 360.
      angle = ((1 - min(angle, 360)/360) * r * PI * 2 < 1)?360:min(angle, 360);
      
      //Reduce the number of holes if necessary to ensure spacing is always greater than 1BU.
      holes = min(floor(angle/180 * PI * r) + 1, holes);
      
      BU_Tz(h/2)
      D() // diferencie obluku a dier
      {
        U() // zjednotenie hlavneho obluka a koncovych oblukov
        {
          if(angle < 360)
          for(i=[0, 1])
          {
            Rz(i * angle)
              BU_Tx(r)
                Rz(i * 180)
                  I(){
                    // koncove obluky 
                    LiEx(BU * h){
                        Ci(BU/2);
                        BU_Ty(-1/2) Cu(BU+1, BU, BU * h + 1);
                        }
                  }
          }
          
          // hlavny obluk - oprava povodneho textu
          rotate_extrude(angle=angle, convexity = 8, $fn = FragmentNumber * r * 2) 
                BU_Tx( r -1/2) BU_Ty(-h/2) square([BU, h*BU]);
        }
        
        // diery
        if(holes > 1)
          for(n = [0:holes - 1])
            Rz(n * angle / (holes-(angle == 360?0:1)))
              BU_Tx(r)
                hole(depth = h); 
      }
  
    }
}


// Module: brace_plate()
// Usage:
//   brace_plate(size, <h=1/4>, <holes=True>, <center=false>);
//
// Description:
//   Vytvori platnu so zaoblenymi okrajmi s rovnakym polomerom ako spojka.
//   Minimalne rozmery su 2x2 BU 
//
// Arguments:
//   size   = array [x,y] - plate dimension 
//   h      = height of brace plate, default = 1/4 BU
//   holes  = set to false to create blank brace plate
//
//
module brace_plate(size, h=1/4, holes=true, center=false)
{

    x = size.x>=2 ? size.x-1 : 1;
    y = size.y>=2 ? size.y-1 : 1;
    hz = h*BU;

    T(center?0:( ([size.x, size.y, 0] - [1,1,0]) * BU / 2 + [1/2, 1/2, h/2]*BU ) )  
    D()
    {
        hull(){
            BU_Tx(-x/2) BU_Ty(-y/2) Cy(r=BU/2, hz);
            BU_Tx( x/2) BU_Ty(-y/2) Cy(r=BU/2, hz);
            BU_Tx(-x/2) BU_Ty( y/2) Cy(r=BU/2, hz);
            BU_Tx( x/2) BU_Ty( y/2) Cy(r=BU/2, hz);
        }

        if(holes==true){
            hole_grid([x+1,y+1]);
            }
    }
}
