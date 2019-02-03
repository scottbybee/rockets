//skeeter

/*
motor dimensions:
    mini d=13mm, l=4.4cm
    standard d=18mm, l=7cm
    c11&d d=24, l=7cm
    24e d=24, l=9.5cm
    e&f d=29mm, l=11.5cm
*/
$fn=90;
radius=6.5;
clearance=0.4;
thickness=1.6;
height=44;
ff=8; //fudge factor to improve appearance

difference(){
hull(){
tube(height);
translate([0,0,height+ff]){sphere(r=radius);}
}
cylinder(r=radius,h=height);
}
module tube(height){
    difference(){
        cylinder(r=radius+clearance+thickness,h=height);
        cylinder(r=radius,h=height);
    }  
}