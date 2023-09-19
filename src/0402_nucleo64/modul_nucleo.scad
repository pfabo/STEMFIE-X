/*
NUCLEO64 boear holder, in BU
*/

include <../../lib/stemfie-x.scad>


module pin(){
    D(){

       cylinder(r2=2.54, r1=3.9, h=10);
       cylinder(r=1.25, h=10);
        }
}

module Nucleo64(){
    // pins
    // from STM NUCLEO64 documentation
    Tx(33)    Ty(-2.54) pin();
    Tx(0)     Ty(5*2.54 + 5.08 + 7*2.54 + 13.97) pin();
    Tx(48.26) Ty(7*2.54 + 4.06 + 9*2.54 +  3.56) pin();


    // spodna doska s vystuhami
    color("blue") Tx(-5) Ty(-5) Tz(2.5) 
    U(){
            beam_block([3,2,.25], holes = [false, false, true], center = false);
            BU_Tx(3) beam_block([2,2,.25], holes = [false, false, false], center = false);
            BU_Tx(5) beam_block([2,2,.25], holes = [false, false, true], center = false);
            
            // middle plate
            BU_Ty(2) beam_block([7,3,.25], holes = [false, false, true], center = false);
            
            BU_Ty(5) beam_block([2,2,.25], holes = [false, false, false], center = false);
            BU_Ty(5) BU_Tx(2) beam_block([3,2,.25], holes = [false, false, true], center = false);
            BU_Ty(5) BU_Tx(5) beam_block([2,2,.25], holes = [false, false, false], center = false);
            
    }

}

Nucleo64();