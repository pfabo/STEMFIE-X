include <../../lib/stemfie-x.scad>
include <../../lib_user/motor_dc/motor_dc.scad>

/* 
    Universal simple demo gearbox
    Motor - diam 21mm
    Gears - 12, 28/12, 28

    Gears axis distance (28+12)/20 = 2 BU)
    
    Uprava pre centrovane komponenty
*/   
   
$fn = 50;


//------------------------------------------------------------------------------
// support 
//------------------------------------------------------------------------------   
MKx() BU_Tx(1/2 )  
beam_block([1/2, 3, 3], holes=[true, false, false]);

color("orange") MKx()  BU_Tx(1) 
beam_block([1, 3, 1], holes=[true, false, true]);


//------------------------------------------------------------------------------
// gears
//------------------------------------------------------------------------------
// double gear
 BU_Ty(1/2) BU_Tz(1+1/2) Ry() Rz(360/12/2)
{    
    color("lightgreen") spur_gear (modul=1, tooth_number=28, width=5, bore=4, pressure_angle=20, helix_angle=0, optimized=false);
    color("lightgreen") BU_Tz(-1/2) spur_gear (modul=1, tooth_number=12, width=5, bore=4, pressure_angle=20, helix_angle=0, optimized=false);
    
    BU_Tz(-1) color("blue") cylinder(r=2, h=20);   // axis
}

// motor gear
color("green") BU_Tz(1 + 1/2) BU_Ty(-1-1/2)  BU_Tx(-1/2) Ry()  Rz(360/12/3)
spur_gear (modul=1, tooth_number=12, width=10, bore=2, pressure_angle=20, helix_angle=0, optimized=false);

// simple gear
BU_Tz(1 + 1/2) BU_Ty(2+1/2) BU_Tx(-1/2) Ry() 
{
    color("red") spur_gear (modul=1, tooth_number=28, width=5, bore=4, pressure_angle=20, helix_angle=0, optimized=false);
    
    color("red") D(){
        cylinder(r=7.5/2, h=10);  
        hole(2);
        }
        
    BU_Tz(-1.5) color("blue") cylinder(r=2, h=30);  // axis
    }
    
    

//------------------------------------------------------------------------------
// motor holder
//------------------------------------------------------------------------------
// motor
BU_Tz(1 + 1/2 ) BU_Ty(-1-1/2)  BU_Tx(-1/4) Rz()  Rx() motor_dc();

// holder
color("lightgrey") BU_Ty(-3)  BU_Tx(1) 
D()
{
     beam_block([1, 3, 3], [false, false, false]);
     
    {
        BU_Tx(-2) BU_Tz(1+1/2) BU_Ty(1+1/2)  Rz()  Rx() motor_dc();
        BU_Tz(1 + 1/2) BU_Ty(1+1/2) BU_cube([2, .1, 1.5]);
        BU_Tz(1/2) hole_list([[1/2, 1/2], [1/2, 2+1/2] ], l=1);
        BU_Ty(2.6)   BU_Tz( 2.6) BU_Tx(1/2) Rx() cylinder(r=1, h=40);
        BU_Ty(0.8) BU_Tz( 2.6) BU_Tx(1/2) Rx() cylinder(r=2.5, h=8); 
    }
}

// base plate
color("steelblue")
BU_Tz(-1/4) 
BU_Ty(-3) 
BU_Tx(-3) beam_block([5, 8, 1/4], holes=[false, false, true]);