/*
Subsection: beams
Derived from https://github.com/Cantareus/Stemfie_OpenSCAD


Modules:
    BU_cube()       basic cube in block units
    beam_block()    beam with holes
    beam_cross()    'V', 'L', 'T' and 'X' beam shapes
*/


/* 
Module: BU_cube()
    Usage:
        BU_cube(size = [1,1,1]);

    Description:
        Create a cube of given size in block units.

    Arguments:
        BU_cube = Size of cube

    Example(3D):
        BU_cube();
        BU_cube([3,1,1]);
*/
module BU_cube(size = [1,1,1], x=undef, y=undef, z=undef, center=true)
{
    x = (x==undef? size: x);
    cube(x[0] == undef?[x*BU, y?y*BU:x*BU, y?(z?z*BU:1*BU):x*BU]:x*BU, center=center); 
}

module BU_cube_rounded(size = [1,1,1], x=undef, y=undef, z=undef, r=0.1, center=false)
{
    x = (x==undef? size: x);
    cube_rounded(x[0] == undef?[x*BU, y?y*BU:x*BU, y?(z?z*BU:1*BU):x*BU]:x*BU, r*BU, center=center); 
}



/*
Module: beam_block()
    Usage: 
        beam_block(size, holes, center);

    Description:
        Creates a Stemfie beam with holes.

    Arguments:
        size = Size of block to create in block units.
        holes = Array of booleans in xyz order for which directions to create holes or a single boolean for all directions.

    Example(3D): Standard Stemfie beam
        beam_block(3);

    Example(3D): Stemfie beam with vertical holes only.
        beam_block(3, holes = [false, false, true], center = false);

    Example(3D): Stemfie 3D "beam"
        beam_block([3, 2, 2]);
*/
module beam_block(size = [4,1,1], holes = [true, true, true], center = true)
{
  size  = is_list(size)?size:[size,1, 1];
  holes = is_list(holes)?holes:[holes,holes,holes];
  
  faceRotate = [[0,90,0],[90,0,0],[0,0,90]];
  
  T(center?0:((size - [1,1,1]) * BU / 2))
  D()
  {
        BU_cube(size, center=true);
    
    for(i = [0:2])
    {
      if(holes[i])
        R(faceRotate[i])
          hole_grid(size = [size[(i + 2) % 3], size[(i + 1) % 3]], l = size[i] );
    }
  }
}


/*
Module: beam_cross()
    Usage: 
        beam_cross(lengths, holes);

        Description:
            Overlaps two Stemfie beams. It can be used to create 'V', 'L', 'T' and 'X' shapes.

        Arguments:
            lengths = Array of 2, 3 or 4 integers. Lengths extending from intersection block with clockwise ordering.

    Example(3D): 'V' beam
        beam_cross([3,3]);
    
    Example(3D): 'L' beam
        beam_cross([5,3]);
        
    Example(3D): 'T' beam
        beam_cross([2,3,2]);
        
    Example(3D): 'X' beam
        beam_cross([2,2,2,2]);
*/
module beam_cross(lengths = [2,2,2,2], h=1, holes = [true, true, true])
{
  cross_helper(len(lengths))
  {
    beam_block([lengths[0] + 1,1,h], holes, center = false);
    //Don't use a for loop here, the children will not be available to parent module.
    if(len(lengths) > 1)
      beam_block([lengths[1] + 1,1,h], holes, center = false);
    if(len(lengths) > 2)
      beam_block([lengths[2] + 1,1,h], holes, center = false);
    if(len(lengths) > 3)
      beam_block([lengths[3] + 1,1,h], holes, center = false);
  }
}

