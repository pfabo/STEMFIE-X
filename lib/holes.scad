/*
Subsection: Holes
Derived from https://github.com/Cantareus/Stemfie_OpenSCAD

Modules:
    hole()
    hole_grid()
    hole_list()
    hole_slot()
*/


// Module: hole()
// Usage:
//   hole(depth = 1, center=true);
//
// Description:
//   Create a circular standard sized hole.
//
// Arguments:
//   depth = The depth of the hole in base units.
//
// Example(3D):
//   difference()
//   {
//     BU_cube();
//     hole(depth = 1);
//   }
//

module hole(depth = 1, center = true)
{
    LiEx(depth * BU * 1.005)
        Ci(r = HoleRadius);
}



//----------------------------------------------------------------------

// Module: hole_grid()
// Usage:
//   hole_grid(size, l=1);
//
// Description:
//   Creates a rectangular array of holes centered on the origin with block unit spacing.
//
// Arguments:
//   size = List with number of holes in X and Y directions.
//   l = See {{hole()}}
//   neg = See {{hole()}}
//
// Example(3D): 
// Create a 4x5 block with vertical holes.
//   difference()
//   {
//     BU_cube([4,5,1]);
//     hole_grid([4,5]);
//   }
//
// Example(3D): 
// Create a 4x5x0.25 block unit plate with holes.
//   difference()
//   {
//      offset(r = BU/2) square([3 * BU, 4 * BU], center = true);
//      hole_grid([4,5], l = 0.25);
//   }

module hole_grid(size = [1,1], l = 1)
{
  forXY(N = size.x, M = size.y, dx = BU, dy = BU)
    hole(depth = l);
}

//----------------------------------------------------------------------


// Module: hole_list()
// Usage:
//   hole_list(list, l=1);
//
// Description:
//   Creates a rectangular array of holes centered on the origin with block unit spacing.
//
// Arguments:
//   list = List with location of holes by X,Y co-ordinates in block units.
//   l = See {{hole()}}
//
// Example(3D): 
// Create brace with custom hole locations
//   difference()
//   {
//     brace(5, holes = false);
//     hole_list([[0,0],[4,0]], l = 0.25);
//   }

module hole_list(list = [[0,0]], l = 1)
{
  for(i = list)
    BU_T(i.x, i.y, 0)
      hole(depth = l);
}

//----------------------------------------------------------------------


// Module: hole_slot()
// Usage:
//   hole_slot(length);
//
// Description:
//   Create a 2D slot profile with radius equal to {{HoleRadius}} and length l.
//
// Arguments:
//   l = Length of slot in block units.
//
// Example(2D):
//   hole_slot(2);

module hole_slot(position=[x,y], length=1, h=1)
{
    LiEx(h=h*BU) BU_T(position.x, position.y, 0)
        slot(length, HoleRadius);
}

