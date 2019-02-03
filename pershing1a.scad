//pershing model
//parameteric (mostly) - so it can scale up and down

/*todo -
0) finish all scaling issues
1) engine blocks - 6.6cm up for d&e24 motors.
2) review scaling - seems short
3) stage connectors

//do a .033 scale; engine fits right inside.  :-)

motor dimensions:
    mini d=13mm, l=4.4cm
    standard d=18mm, l=7cm
    c11&d d=24, l=7cm
    24e d=24, l=9.5cm
    e&f d=29mm, l=11.5cm
*/

$fn=360;
motorRadius=12.25; //use r=12.25 for d & e engines
scale=0.1; //I wanna build a 1/10th scale model. 'cause that what will fit in the printer.

//so, rad is the radius of the warhead base; the missle is 25% larger
//and we want to work in missle radius
rad=0.8*501*scale;  //this is the radius of the missle at this scale

//translate([0,0,0]){stage(rad, 1, 3.46);}
//translate([0,0,3.46*rad]){stage(rad, 2, 3.28);}
//translate([0,0,6.72*rad]){top(rad);}

// components - for testing
//fin(rad, 2);

puck();

/*union(){
top(rad);
translate([0,0,-0]){rotate([180,0,0]){puck();}}
}*/


module tube(hgt){
    difference(){
        cylinder(r=2.5,h=hgt);
        cylinder(r=1.7,h=hgt);
    }  
}
module stage (rad, stage, height){
    //simple cylinder with 3 fins
    //make separate module for fins and mating surfaces
    stageHeight=height*rad;

    //outter wall
    difference(){
        cylinder(r=rad, h=stageHeight);
        cylinder(r=rad-1.5,h=stageHeight);
    }

    //motor tube - comment out for non-flying models
    
    difference(){
        cylinder(r=motorRadius+1, h=stageHeight-10);
        cylinder(r=motorRadius, h=stageHeight-10); 
    } 
        
    //cable covers
    rotate([0,0,180]){translate([rad,0,0]){cableCover(rad, stage);}}
    
    //motor tube mounts - comment out for non-flying models
    
    for (angle=[0:120:240]){
        rotate([0,0,angle]){
            translate([motorRadius,0,0]){
                cube([rad-motorRadius-1,motorRadius*.1,stageHeight-10]);  
            }
        }
    } 
    
    for (angle=[0:120:240]){
        rotate([0,0,angle]){
            translate([rad*1.02,0,rad*.1]){rotate([0,0,-90]){fin(rad, stage);}}
        }
    } 
}

module GandC(rad){
    //conical section for guidance and control
}

module warhead(rad){
}

module matingClamps(rad){
}

module fin(rad, stage){
    if (stage==1){
        union(){       
            hull(){
                translate([0,0,0]){rotate([-90,0,0]){cylinder(r=.1,h=.53*rad);}}  //missle edge bottom
                translate([0,.53*rad,0]){rotate([-45,0,0]){cylinder(r=.1,h=.1);}} //fin tip
                translate([0,0,.68*rad]){rotate([90,0,0]){cylinder(r=.5,h=.10);}} //missle edge top
                translate([-.06*rad,0,.30*rad]){rotate([0,90,0]){cylinder(r=.1,h=.12*rad);}} //missle edge wide spot
            }
            translate([0,0,rad*-0.1]){rotate([0,0,0]){vanePad(rad, 0.87);}}
         }
    }
    if (stage==2){
        union(){    
            hull(){ //these were a wedge  .57 (tall) x .62
                translate([-rad*.06,0,0]){cube([rad*.12, rad*.62, 1]);}; //trailing edge
                translate([0,0,.57*rad]){rotate([-90,0,0]){cylinder(r=.2,h=rad*.62);}}// leading edge
            }
            translate([0,0,rad*-0.1]){rotate([0,0,0]){vanePad(rad, 0.75);}}      
        }
    }
}

module vanePad(rad, padHeight){
    //todo - chamber leading edge 17degree
    translate([-rad*0.2150,-rad*0.06,0]){
        cube([rad*0.43,rad*0.06,rad*padHeight]);
        }
    }
    
module cableCover(rad, stage){
    //todo - chamfer top and bottom edges to 15 degrees.
    /* todo two - launching ideas
    idea 1) make a hole thru the cable covers to serve as launch tube
    idea 2) modify profile (of cable cover) to serve as launch rail?  Slip inside 20x20 extrusion?
    idea 3) build a launch adapter that screws to cable covers (it's a reinforced body area - could be just a couple eye screws)
    idea 4) add a internal tube and make it go thru the top.  Come out cable cover??
    */
    
    if (stage==1){
        translate([0,-rad*.105,rad*0.75]){
            difference(){
                cube([rad*0.07, rad*0.21, rad*2.68]);
                rotate([0,15,0]){cube([rad,rad,rad]);}
                translate([0,0,rad*2.68]){rotate([0,75,0]){cube([rad,rad,rad]);}}
            }
        }
    }
    if (stage==2){
         translate([0,-rad*.105,rad]){
            difference(){   
                cube([rad*0.07, rad*0.21, rad*1.93]);
                rotate([0,15,0]){cube([rad,rad,rad]);}
                translate([0,0,rad*1.93]){rotate([0,75,0]){cube([rad,rad,rad]);}}
            }
        }
    }
}

    
module matingRing(rad){
}

module top(rad){
    //modelling the gnc and warhead together...
    hull(){
        cylinder(r=rad, h=.1); //bottom of piece
        translate([0,0,rad*5]){cylinder(r=.5*rad, h=.1);} // angle change near tip
        translate([0,0,rad*6.17]){sphere(r=rad*0.1);}// tip of warhead - 0.03 is too pointy, using 0.1
    }
//translate([0,0,rad*1.59]){cylinder(r=rad*0.845, h=rad*.03);} //top of gnc marker
}


module puck(){
    //joins stage 1&2
    //76mmx20mm with 25mm center hole
    //and 3 1.5mm slots for stage 2
          
    
    difference(){
        cylinder(d=76,h=50);
        cylinder(r=13.75,h=50);
        
        for (angle=[0:120:240]){
        rotate([0,0,angle]){
            translate([12,0,00]){cube([rad-motorRadius,2,20]);}
            translate([12,0,30]){cube([rad-motorRadius,2,20]);}
        }
    }
    }
    }

