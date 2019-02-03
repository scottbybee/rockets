$fn=36;
scale([1,1,1.5]){
    rotate_extrude( angle = 120, $fn=360 )
    translate([501,0,0])
    xSection();
    }

//rotate_extrude( angle = 120, $fn=360 )
//translate([45,0,0])
//circle(r=1);
//rotate([0,180,0]){xSection();}

//translate([50,0,10]){sphere(r=8);}

module xSection(){
    polygon([[9,0],[10,1],[10,19],[9,20],[0,20],[0,18],[6,16], [6,4],[0,2],[0,0]]);
    }