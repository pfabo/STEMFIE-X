/*
Drziak modulu TM1638 - driver krokoveho motora

Verzia      1.0 / 24.09.2023
*/

include <../../lib/stemfie-x.scad>

module pin(){
    D(){

       cylinder(r2=2.54, r1=3.9, h=10);
       cylinder(r=1.25, h=10);
        }
}


module Module_TB6600(){
    dx = 8;
    dy = 5;
    dz = 1/4;
    
    // posun podlozky do polohy 1. kvadrantu
    BU_Tx(dx/2) BU_Ty(dy/2) BU_Tz(dz/2){ 
        D()
        {
            BU_cube([dx, dy, dz]);
            U(){
                BU_cube([dx-2, dy-2, dz + 1/8]);
                // otvory v rastri BU
                forXY(dx = 10, N=8, dy = 10, M=3) hole();  
                forXY(dx = 10, N=6, dy = 10, M=5) hole();  
            }
        }
    }
    
    I() // orezanie precnievajucich casti za rozmer podlozky
    { 
        // montazne piny pre modul
        BU_Tx(2/8) BU_Ty(5/16) 
        U(){
            Tx(  0.00)  Ty(  7.40) pin();
            Tx( 74.46)  Ty(  0.00) pin();
            Tx( 74.46)  Ty( 43.33) pin();
            Tx(  0.00)  Ty( 43.33) pin();
         }
         
        // vonkajsi rozmer
        BU_Tx(dx/2) BU_Ty(dy/2) BU_Tz(dz/2)
            BU_cube([dx,dy,4]);
            
        }

}

Module_TB6600();