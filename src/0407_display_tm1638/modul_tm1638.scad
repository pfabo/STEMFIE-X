/*
Drziak modulu TM1638
*/

include <../../lib/stemfie-x.scad>

module pin(){
    D(){

       cylinder(r2=2.54, r1=3.9, h=10);
       cylinder(r=1.25, h=10);
        }
}

module Display_TM1638(){

    D(){
        BU_cube([8,5,1/4]);
        U(){
            BU_cube([6, 3, 1/4+0.01]);
            hole_list([ [ 3.5,-1],  [ 3.5, 0], [ 3.5, 1] ]);
            hole_list([ [-3.5,-1],  [-3.5, 0], [-3.5, 1] ]);
            hole_list([ [-2.5, 2],  [-1.5, 2],  [-0.5, 2], [ 0.5, 2], [ 1.5, 2], [2.5, 2] ]);
            hole_list([ [-2.5, -2],  [-1.5,-2],  [-0.5,-2], [ 0.5,-2], [ 1.5,-2], [2.5, -2] ]);
        }
    }

    Tx( 33.98 ) Ty( 21.0) pin();
    Tx( -33.98 ) Ty( -21.0) pin();
    Tx( -33.98 ) Ty( 21.0) pin();
    Tx( 33.98 ) Ty( -21.0) pin();

}

Display_TM1638();