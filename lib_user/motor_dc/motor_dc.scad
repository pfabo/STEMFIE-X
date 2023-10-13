/*
Modelarske DC motory

    motor_dc_21    - maly motor, diam. 21mm 

*/

// small DC motor, body diam 21mm, axis diam 2mm
module motor_dc_21()
{
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

// demo
//motor_dc_21();