include <../../lib/stemfie-x.scad>


/* 
    Universal simple demo gearbox
    Motor - diam 21mm
    Gears - 12, 28/12, 28

    Gears axis distance (28+12)/20 = 20 (= 2 BU)
*/   
   
$fn = 50;

// small motor 21mm diam.
module motor_dc(){
    U(){
        rr = 1;       // priemer hriadela
        rh = 8;       // dlzka hriadela
        lr = 6.2/2;   // priemer  loziska
        lh = 1.62;    // dlzka loziska
        cr = 16.1/2;   // priemer odsadenia         
        ch = 3.9;      // dlzka odsadenie
        mr = 21.1/2;  // priemer motora (upravena, 20.8)
        md = 21.2;    // dlzka motora
        color("lightblue") cylinder(r=rr, h=rh);   // hriadel
        color("lightgrey") Tz(rh) cylinder(r=lr, h=lh);                // lozisko
        color("lightgrey") Tz(rh+lh) cylinder(r=cr, h=ch);             // odsadenie
        color("grey") Tz(rh+lh+ch) cylinder(r=mr, h=md);          // motor
    }
}

//------------------------------------------------------------------------------
// support 
//------------------------------------------------------------------------------   
MKx() BU_Tx(1/2 + 1/4) BU_Tz(1.5) beam_block([1/2, 3, 3], holes=[true, false, false]);
color("orange") MKx() BU_Tz(1/2) BU_Tx(1/2 + 1) beam_block([1, 3, 1], holes=[true, false, true]);


//------------------------------------------------------------------------------
// gears
//------------------------------------------------------------------------------
// double gear
 BU_Ty(-1) BU_Tz( 1+1/2) Ry() Rz(360/12/2)
{    
    color("lightgreen") spur_gear (modul=1, tooth_number=28, width=5, bore=4, pressure_angle=20, helix_angle=0, optimized=false);
    color("lightgreen") BU_Tz(-1/2) spur_gear (modul=1, tooth_number=12, width=5, bore=4, pressure_angle=20, helix_angle=0, optimized=false);
    BU_Tz(-1) color("blue") cylinder(r=2, h=20);
}

// motor gear
color("green") BU_Tz(1 + 1/2) BU_Ty(-3)  BU_Tx(-1/2) Ry()  Rz(360/12/3)
spur_gear (modul=1, tooth_number=12, width=10, bore=2, pressure_angle=20, helix_angle=0, optimized=false);

// simple gear
BU_Tz(1 + 1/2) BU_Ty(1) BU_Tx(-1/2) Ry() 
{
    color("red") spur_gear (modul=1, tooth_number=28, width=5, bore=4, pressure_angle=20, helix_angle=0, optimized=false);
    
    color("red") D(){
        cylinder(r=7.5/2, h=10);  
        hole(2);
        }
        
    BU_Tz(-1.5) color("blue") cylinder(r=2, h=30);
    }
    

//------------------------------------------------------------------------------
// motor holder
//------------------------------------------------------------------------------
// motor
BU_Tz(1 +1/2) BU_Ty(-3)  BU_Tx(-0.3) Rz()  Rx() motor_dc();

// holder
color("lightblue") BU_Ty(-3)  BU_Tx(1+1/2) BU_Tz(1.5)  
D()
{
     beam_block([1, 3, 3], [false, false, false]);
     
    {
        BU_Tx(-1.9) Rz()  Rx() motor_dc();
        BU_Tz(1.5) beam_block([2, .1, 1.5], [false, false, false]);
        BU_Tz(-1) hole_list([[0,-1], [0,1] ], l=1);
        BU_Ty(2) BU_Tz( 1.2) Rx() cylinder(r=1, h=40);
        BU_Ty(-.8) BU_Tz( 1.2) Rx() cylinder(r=2.5, h=8); 
    }
}

// base plate
color("lightgrey") BU_Ty(-1.5) BU_Tx(.5) BU_Tz(-1/8) beam_block([5, 8, 1/4], holes=[false, false, true]);