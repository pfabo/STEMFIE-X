//  NUCLEO64 board holder in BU grid


include <../../lib/stemfie-x.scad>


module pin(){
    D(){

       cylinder(r2=2.54, r1=3.9, h=10);
       cylinder(r=1.25, h=10);
        }
}

// piny pre prisrobovanie dosky
Tx(33)    Ty(-2.54) pin();
Tx(0)     Ty(5*2.54 + 5.08 + 7*2.54 + 13.97) pin();
Tx(48.26) Ty(7*2.54 + 4.06 + 9*2.54 +  3.56) pin();

h=1/4;   // thickness

// spodna doska s vystuhami
color("olive") Tx(-10) Ty(-10) Tz(0) 
U()
{
    beam_block([3,2, h], holes = [false, false, true], center = false);
             
    BU_Tx(3) beam_block([2,2, h], holes = [false, false, false], center = false);
    BU_Tx(5) beam_block([2,2, h], holes = [false, false, true], center = false);
    
    
    // full filling
    //BU_Ty(2) beam_block([7,3, h], holes = [false, false, true], center = false);
    // or partial filling
    BU_Ty(2) beam_block([1,3, h], holes = [false, false, true], center = false);
    BU_Ty(2) BU_Tx(6) beam_block([1,3, h], holes = [false, false, true], center = false);
    
    BU_Ty(5) beam_block([2,2, h], holes = [false, false, false], center = false);
    BU_Ty(5) BU_Tx(2) beam_block([3,2, h], holes = [false, false, true], center = false);
    BU_Ty(5) BU_Tx(5) beam_block([2,2, h], holes = [false, false, false], center = false);
    
}
