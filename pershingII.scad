//pershing II model
//parameteric (mostly) - so it can scale up and down

/* dimensions - 
first stage 3.7mx1m = 7.4rad
second stage 2.5mx1m = 5.0rad
gnc 1.6mx1mx0.7m = 3.2rad
warhead 1.6x0.7X0.5 = 3.2rad
radar 1.3X.5X0
Note: GandC and the radar section both have a change of pitch to make a more accurate model

*/

/*todo -
0) finish all scaling issues
1) engine blocks - 6.6cm up for d&e24 motors.
2) review scaling - seems short
3) stage connectors

4) here's a thought - build flight and display vanes; use a 3 pin design for alignment & internal clip to secure them
that way looks more accurate on display but can fly with the larger vanes.
(I think the steerable nozzle issue can be resolved this way)

5) add initialOffset to move vanes center of face when experimenting with "low-rez" rockets

6) add 'sanity check' code; make sure motor size will fit in the tube depending on scale

7) add options switches to do things like display/flight vanes, second stage vanes, etc.

8) clean up the code and documentation

9) parameterize puck()

//do a .033 scale; engine fits right inside.  :-)

motor dimensions:
    mini d=13mm, l=4.4cm
    standard d=18mm, l=7cm
    c11&d d=24, l=7cm
    24e d=24, l=9.5cm
    e&f d=29mm, l=11.5cm
*/

$fn=90;
motorRadius=12.25; //use r=12.25 for d & e engines
scale=1/25; //1/13th scale model. 'cause that's what will fit in the printer.

//so, rad is the radius of the warhead base; the missle is 25% larger
//and we want to work in missle radius
//rad=0.8*501*scale;  //this is the radius of the missle at this scale
rad=500*scale;
//translate([0,0,0]){stage(rad, 1, 3.7*2);}
//translate([0,0,(7.4*rad)]){matingRing(rad);} //fix matingRing scale issues
//translate([0,0,7.44*rad]){stage(rad, 2, 2.5*2);}
//translate([0,0,12.39*rad]){matingRing(rad);}
union(){
translate([0,0,12.4*rad]){cylinder(r=rad-1.6,h=.25*rad);}
translate([0,0,12.64*rad]){GandC(rad);}
}
//translate([0,0,15.57*rad]){warhead(rad);}
//translate([0,0,18.77*rad]){radar(rad);}


// components - for testing
//translate([rad*2,rad*2,0]){puck();}


module stage (rad, stage, height){
    //simple cylinder with 3 fins
    //make separate module for fins and mating surfaces
    stageHeight=height*rad;

    //outer wall
    difference(){
        cylinder(r=rad, h=stageHeight);
        cylinder(r=rad-1.5,h=stageHeight);
    }

    //motor tube - comment out for non-flying models
    
    difference(){
        cylinder(r=motorRadius+1, h=stageHeight-10);
        cylinder(r=motorRadius, h=stageHeight-10); 
    } 
        
    //need union function here to integrate these features??
    
    //cable covers
    rotate([0,0,45]){translate([rad,0,0]){cableCover(rad, stage);}}
    rotate([0,0,225]){translate([rad,0,0]){cableCover(rad, stage);}}
    
    //motor tube mounts - comment out for non-flying models
    
    for (angle=[0:120:240]){
        rotate([0,0,angle]){
            translate([motorRadius,0,0]){
                cube([rad-motorRadius-1,motorRadius*.1,stageHeight-10]);  
            }
        }
    } 
    if (stage==1){ // looks cool with vanes for both stages!
    for (angle=[0:90:360]){  //4 vanes for PII
        rotate([0,0,angle]){
            translate([rad*1,0,.9]){rotate([0,0,00]){vane(rad);}} //display/flight vane code is needed
        }
    }} 
}

module GandC(rad){
    //conical section for guidance and control
    //cylinder(r1=rad, r2=0.7*rad, h=3.2*rad); //old, inaccurate version
    union(){
        cylinder(r1=rad, r2=rad*(12/15), h=.53*rad*2);
        translate([0,0,.53*rad*2]){cylinder(r1=rad*(12/15), r2=0.7*rad, h=.53*rad*4);}
        //also need vanes
         for (angle=[0:90:271]){
        rotate([0,0,angle]){
        translate([.8*rad,0,1.1*rad]){rotate([2.5,0,-90]){gncVane(rad);}}
    }
        }
}}

module warhead(rad){
   cylinder(r1=0.7*rad, r2=0.5*rad, h=3.2*rad); 
}

module radar(rad){
    //modelling the gnc and warhead together...
    hull(){
        cylinder(r=.5*rad, h=.1); //bottom of piece
        //translate([0,0,rad*5]){cylinder(r=.5*rad, h=.1);} // angle change near tip
        translate([0,0,rad*2.6]){sphere(r=rad*0.1);}// tip of warhead - 0.03 is too pointy, using 0.1
    }
//translate([0,0,rad*1.59]){cylinder(r=rad*0.845, h=rad*.03);} //top of gnc marker
}
module gncVane(rad){
    //small vane on gnc. height=8/7rad, base=.5*rad
    //replace the 2d vane with 3d like first stage of p1a
    /* first draft is rough
    translate([0,rad/2,0]){rotate([0,-90,180]){
    difference(){
    cube([(8/7)*rad, 0.5*rad, 0.05*rad]);
    rotate([0,0,24]){cube([(8/7)*rad*2, 0.5*rad, 0.05*rad]);}
    }}}
    */
    
    union(){       
            hull(){
                translate([0,0,0]){rotate([-90,0,0]){cylinder(r=.1,h=.53*rad);}}  //missle edge bottom
                translate([0,.5*rad,0]){rotate([-45,0,0]){cylinder(r=.1,h=.1);}} //fin tip
                translate([0,0,8/7*rad]){rotate([90,0,0]){cylinder(r=.5,h=.10);}} //missle edge top
                translate([-.06*rad,0,.30*rad]){rotate([0,90,0]){cylinder(r=.1,h=.12*rad);}} //missle edge wide spot
                
            }
            //add "tab" for PII vanes here
            translate([0,0,0]){rotate([0,0,0]){vanePad(rad, 1.15);}}
         }
    
}
    


module vane(rad){ //add scale([rad,rad,rad])
    localScale=.23*rad;
    localScale=.18*rad;
    scale([localScale*.80,localScale*.75,localScale]){
    difference(){
        hull(){
            translate([0,0,0]){sphere(r=.1);}
            translate([10,0,0]){sphere(r=.1);}
            translate([0,.5,4]){rotate([90,0,0]){cylinder(r=.1,h=1);}}
            translate([0,0,11]){sphere(r=.1);}
        }
        translate([8,-5,-1]){cube([10,10,10]);}
        translate([-0.1,-1,-0.1]){cube([1.5,2,2]);}
    }}
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
                cube([rad*0.07, rad*0.21, rad*5.68]);
                rotate([0,15,0]){cube([rad,rad,rad]);}
                translate([0,0,rad*5.68]){rotate([0,75,0]){cube([rad,rad,rad]);}}
            }
        }
    }
    if (stage==2){
         translate([0,-rad*.105,rad]){
            difference(){   
                cube([rad*0.07, rad*0.21, rad*2.93]);
                rotate([0,15,0]){cube([rad,rad,rad]);}
                translate([0,0,rad*2.93]){rotate([0,75,0]){cube([rad,rad,rad]);}}
            }
        }
    }
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
    
module matingRing(rad){
    $fn=360;
    rotate_extrude()
    translate([rad-(scale*10),0,0])
    scale([scale,scale,scale]){xSection();};
}
module xSection(){
    polygon([
    [9,0],
    [10,1],
    [10,19],
    [9,20],
    [0,20],
    [0,18],
    [6,16], 
    [6,4],
    [0,2],
    [0,0]]);
    }
 

