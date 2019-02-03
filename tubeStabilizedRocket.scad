/*
motor dimensions:
    mini d=13mm, l=4.4cm
    standard d=18mm, l=7cm
    c11&d d=24, l=7cm
    24e d=24, l=9.5cm
    e&f d=29mm, l=11.5cm
*/

//system wide vars here
wallThickness=0.8; //thin wall for light weight
clearance=.2; //diminish cone plug to slip in and out
motorRadius=6.5; //mini motor
motorHeight=40;
insideRadius=motorRadius+clearance;
outsideRadius=insideRadius+wallThickness;

$fn=36; //draft
$fn=360; //high quality
rocketHeight=50; //minus cone


//- rocket
tube(insideRadius,rocketHeight);
//changing tube - pass INSIDE diameter

for (angle = [30:120:270]) {
   rotate([0,0,angle]){translate([12.5,0,0]){vaneTube(5,15);}}
    }
 
rotate([0,0,187]){
    translate([outsideRadius+1.7,0,0]){tube(1.5,15);} //launchtube
    //translate([outsideRadius+1.5,0,rocketHeight-10]){tube(1.5,10);}
} //launchtube


translate([0,0,rocketHeight+10]){cone(outsideRadius);    }
translate([0,0,motorHeight]){motorMount(insideRadius+(0.5*clearance));    }

 module cone(outsideRadius){
     hull(){
         //$fn=sides;
         cylinder(r=outsideRadius,h=0.1);
         translate([0,0,15]){sphere(r=2);}
     }
     translate([0,0,-3]){cylinder(r=insideRadius-clearance, h=3);}
 }
 

module vaneTube(radius,height) {
 // make the tubes hollow
 // chamfer the top of the tube 45 degrees
    difference(){   
        rotate([0,0,30]){tube(radius, height);}
        translate([-radius,-2*radius,height]){rotate([0,45,0]){cube([4*radius,4*radius,4*radius]);}}
            }
        }

               
                
module tube(radius, height) {
        //$fn=sides; - use this to make ploygonal rockets 
        //wallThickness=0.8;
        difference(){
            cylinder(r=(radius+wallThickness), h=height);
        cylinder(r=radius,h=height);
    }
}

module motorMount(radius){
    //makes a ring 
    tube(radius-wallThickness-(.5*clearance), 3);
    }