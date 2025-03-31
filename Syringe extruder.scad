/*
    Squishstruder - Syringe Extruder for Tronxy
    by D. Scott Williamson 1/4/2024 
    
    (c) copyright 2024 All rights reserved.

    todo
        [] Rename git repo
        [-] Rebuild in FreeCAD - decided it was too much effort
        [-] Parametric for different syringes
        [-] Customizer


    version history
    v2.1
        [] Redesign acutator to hold plunger for retraction

    v2.0
        [x] Thicken belt screw walls
        [x] Raise motor and syringe mount for more clearance
            [x] Bring motor and syringe forward to clear mounting screw heads
        [x] syringe flange holder for retraction and to prevent rotation
            [x] Flange holder
    v1.1
        [x] Mounting screw holes larger (3.3 -> 4.5)
        [x] Vertical screw spacing on mount needs to be wider (24.185)
    v1.0 Printed on Voron in blue PLA 4 walls .3mm layers
        [x] Model syringe
        [x] Drive
            [x] Stepper motor
            [x] Shaft coupler
            [x] Threaded rod
        [x] Design mounting plate frame
            [x] Mount to printer
            [x] Stepper motor mount
            [x] Syringe mount
            [x] Workshop 88 logo
            [x] Version number
            [x] Rename Squishstruder
            [x] Precise mounting hole locations
        [x] Design actuator plunger holder
            [x] Plunger interface (Actuator cannot lift plunger for retraction)
            [x] Dual nut capture 
        [-] Redesign actuator to print on its back and the plunger top fits in a slot for retraction
        [x] Need screw holes in back for screws to hold belts
        [x] Thickened area around belt mounting screws
        [-] gusset for belt screws that does not interfere with mounting screws
*/


ver="v2.0";    // Version

// layer height
nozzled=0.4;
lh=.35;     //[.1:.05:1]

syringe_body_wall_thickness=1.5;
syringe_body_diameter=29.5;         // [2:80]
syringe_body_length=134;            // [2:200]
syringe_body_diameter1=11.22;       // [2:80]
syringe_body_length1=5;
syringe_body_diameter2=6.8;         // [2:80]
syringe_body_length2=43;

syringe_body_flange_width=50;
syringe_body_flange_diameter=33.2;
syringe_body_flange_length=18;

syringe_body_flange_radius=4;
syringe_body_flange_thickness=2.6;

syringe_plunger_head_diameter=31;   // [2:80]
syringe_plunger_thickness=2;   // [1:8]
syringe_plunger_length1=130;         // [10:200]
syringe_plunger_length2=12;         // [10:200]
syringe_plunger_length=142;         // [10:200]
syringe_plunger_throw=127.5-12;     // [10:200]
syringe_plunger_wall_width=24.6;
syringe_plunger_wall_width2=16.8;

syringe_plunger_tip_thickness=5;


clearance=nozzled*.5;
nema17r1=22/2+clearance*2;
nema17screwoffset=31/2;
nema17screwholer=(3/2)+clearance;
nema17motorw=42.3;
nema17cornerr=4;
nema17offset=44/2;

$fn=32;

mount_thickness=3;
mount_height=180;
mount_width=52; //44;
mount_depth=60;
mount_hole_diameter=12;
mount_syringe_offset=50;


actuator_thickness=mount_thickness;
actuator_width=44;
actuator_depth=60;
actuator_rod_diameter=18;
actuator_plunger_id=syringe_plunger_head_diameter+1;
actuator_plunger_od=actuator_plunger_id+actuator_thickness*2;
actuator_height=40;

quarter20nut_flatd=11;
quarter20nut_h=5.6;
quarter20nut_id=.25*25.4;

xbearingspacing=44;
xbearingy1=20;
xbearingy2=xbearingy1+xbearingspacing;
mount_screw_spacing_x=18;
mount_screw_spacing_y=24.185;   // v1.0 25;
mount_belt_screw_spacing=mount_width-mount_thickness; //42;

// x bearing ends look like i3 58mm tall, bearings xbearingspacingmm apart
///////////////////////////////////////////////////////////////////////////////
// Variables after here will not appear in the cutomizer
module hide_from_customizer() {} 

plunge=-30;//-syringe_plunger_throw*(sin($t*360)/2+.5);

raisefloor=36;
screwclearance=3;

///////////////////////////////////////////////////////////////////////////////
// Preview
// Guides for develoment
if ($preview){
    ty(screwclearance) tz(raisefloor) {
        
        t([0,mount_syringe_offset,142])rx(180)rz(00) {
            tz(plunge) rz(45) plunger();
            syringe();
        }
        ty(nema17offset) {
            nema17steppermotor(pinion=false);
            color([.4,.4,.4]) tz(5) rz(plunge*20/25.4*360) coupler();
            color([.6,.6,.6]) tz(15) rz(plunge*20/25.4*360) cylinder(d=.25*25.4,h=300);    // Threaded rod
            color([.8,.8,.8]) tz(156-plunge-actuator_thickness-.1) nut(flatd=quarter20nut_flatd,h=quarter20nut_h,id=quarter20nut_id);
            color([.8,.8,.8]) tz(156-plunge-actuator_thickness+actuator_height-quarter20nut_h+.1) nut(flatd=quarter20nut_flatd,h=quarter20nut_h,id=quarter20nut_id);
        }

        color([.1,.3,.7]) tz(156-plunge-actuator_thickness) actuator();
    }

    //color([.1,.8,.8]) retainer();
    color([.1,.2,.8]) mount();
    
    // bearing rails
    color([.8,.8,.8]) for(i=[0,xbearingspacing]) t([-100,-4-mount_thickness-4,xbearingy1+i]) ry(90) cylinder(d=8,h=200);

    
    //t([0,0,10])nema17mountingplate();
    //#t([0,0,20])nema17holes();
    //tz(3) ty(100)nut(flatd=quarter20nut_flatd,h=quarter20nut_h,id=quarter20nut_id);
    //#ty(100)nuthole(flatd=quarter20nut_flatd+.5,h=quarter20nut_h+.4);
}
else{
    tx(-50) rx(90) mount();
    tx(50) actuator();
}


///////////////////////////////////////////////////////////////////////////
// modules

// 10mm wide W88 logo
module w88logo()
{
	s=2.8;
	scale([s,s,2]) translate([-8.1,-2.1,-2.6 /*+.125*/])
	import("w88_logo.stl");
}

// Actuator rides on threaded rod and moves the syringe plunger
module actuator()
{
    difference() {
    
        union() {
            hull() {
            ty(nema17offset) cylinder(d=actuator_rod_diameter,h=actuator_thickness*2);
            ty(mount_syringe_offset) cylinder(d=actuator_plunger_od,h=actuator_thickness*2);
            }
            
            ty(nema17offset) cylinder(d=actuator_rod_diameter,h=actuator_height);
            
            for(a=[-90:36:90]) {
                s=sin(a);
                c=cos(a);
                hull() {
                    t([s*(actuator_plunger_od/2-actuator_thickness/2),mount_syringe_offset+c*(actuator_plunger_od/2-actuator_thickness/2),0]) cylinder(d=actuator_thickness,h=actuator_thickness*2);
                    t([s*(actuator_rod_diameter/2-actuator_thickness/2),nema17offset+c*(actuator_rod_diameter/2-actuator_thickness/2),0]) cylinder(d=actuator_thickness,h=actuator_height);
                }
                
            }
        }
        
        // recess for top of syringe
        tz(-.1) ty(mount_syringe_offset) cylinder(d1=actuator_plunger_id+2,d2=actuator_plunger_id,h=actuator_thickness);
        
        ty(nema17offset) {
        // bottom nut hole
        tz(-.1) nuthole(flatd=quarter20nut_flatd+.5,h=quarter20nut_h+.4);
        // top nut hole
        tz(-.1) cylinder(d=.25*25.1+1, h=actuator_height+1);
        tz(actuator_height-quarter20nut_h) nuthole(flatd=quarter20nut_flatd+.5,h=quarter20nut_h+.4);
        }

    }
}


module retainer()
{
    
}


/* false start
retainer_length=100;
retainer_thickness=mount_thickness;
retainer_depth=20;  //syringe_body_diameter+2;
retainer_gap=syringe_body_flange_thickness+.3;
retainer_end_diameter=10;
// Retainer holds the syringe in place during retraction
module retainer()
{
    //t([-retainer_width/2, -retainer_depth/2, retainer_length]) 
    hull()
    {
        t([-mount_width/2+mount_thickness,mount_syringe_offset,20]) ry(90) cylinder(d=retainer_end_diameter, h=retainer_thickness);
        t([-mount_width/2+mount_thickness,mount_syringe_offset-retainer_depth/2,140]) cube([retainer_thickness,retainer_end_diameter,10]);
    }
}
*/

// Mount to the body of the printer
module mount()
{
    difference() {
        union() {
            // back
            t([-mount_width/2,-mount_thickness,3]) cube([mount_width,mount_thickness,mount_height-3]);
            // motor mount
            t([-mount_width/2,-mount_thickness,raisefloor]) cube([mount_width,mount_depth+mount_thickness,mount_thickness]);
            
            // gussets
            for (x=[-1,1]) tx(x*(mount_width/2-mount_thickness/2)-mount_thickness/2) hull(){
                tz(3)cube([mount_thickness,.01,mount_height-3]);    // the 3 is for connector clearance
                tz(syringe_body_length+raisefloor+12-1)cube([mount_thickness,mount_depth,1]);  // top to make a box
                t([0,-mount_thickness,raisefloor]) cube([mount_thickness,mount_depth+mount_thickness,mount_thickness]);
            }

            // syringe mount
            tz(syringe_body_length+raisefloor) hull() {
                ty(mount_syringe_offset+screwclearance) cylinder(d=syringe_body_diameter+mount_thickness*2,h=12);
                t([-mount_width/2,-mount_thickness,0]) cube([mount_width,mount_depth+mount_thickness,12]);
            }
            
            // flared sides for belt screws
            for(x=[-1,1]) t([x*mount_belt_screw_spacing/2,-mount_thickness,35]) rx(-90) cylinder(d1=7,d2=3,h=30);


            // side SQUISHSTRUDER text
            t([mount_width/2,28,104])rx(-73)rz(90)rx(90)linear_extrude(height=lh*2) text("SQUISHSTRUDER",size=17,font="PT Utah Condensed:style=Bold",halign="center",valign="center",$fn=32);

    
            t([-mount_width/2,28,104])rx(-73)rz(-90)rx(90)linear_extrude(height=lh*2) text("SQUISHSTRUDER",size=17,font="PT Utah Condensed:style=Bold",halign="center",valign="center",$fn=32);

            // side logos
            for(m=[0,1]) mirror([m,0,0]) t([mount_width/2+.75,40,158]) r([90,0,90]) s([3,3,2.5]) w88logo();

    }
    // mounting holes
    dx=mount_screw_spacing_x/2;
    dy=mount_screw_spacing_y/2;
    #for(i=[0,1]) for(x=[-1,1])for(y=[-1,1]) t([x*dx,-5,y*dy+xbearingy1+xbearingspacing*i]) rx(-90) cylinder(d=4.5,h=10);
    // visual clearance for screw heads
    #for(i=[0,1]) for(x=[-1,1])for(y=[-1,1]) t([x*dx,-5+10-2.5,y*dy+xbearingy1+xbearingspacing*i]) rx(-90) cylinder(d=6.5,h=2.5);
    
    // Holes for screws to hold x belt
    #for(x=[-1,1]) t([x*mount_belt_screw_spacing/2,-4,35]) rx(-90) cylinder(d=2.95,h=30);
    
    
    ty(screwclearance) tz(raisefloor) {
        // Motor mounting holes
        t([0,nema17offset,-.1])nema17holes(clr=.5);
        // syringe mount
        t([0,mount_syringe_offset,-1]) cylinder(d=mount_hole_diameter,h=mount_thickness+2);

        // hole for threaded rod at top
        t([0,nema17offset,syringe_body_length-1]) cylinder(d=12,h=12+2);
        
        hull() for (x=[-1,1]) for (z=[-1,1]) for(y=[0,10]) t([x*.2,mount_syringe_offset+y,syringe_body_length+5.4+z*.2])syringeflange();
            
        hull() for(y=[0,10])t([0,mount_syringe_offset+y,syringe_body_length-1]) cylinder(d=syringe_body_diameter+1,h=12+2);
        

    }    
    
    // Version 
    t([0,-mount_thickness+lh*1.9,xbearingy1+xbearingspacing/2])rx(90)linear_extrude(height=lh*2) text(str(ver),size=6.5,font="PT Utah Condensed:style=Bold",halign="center",valign="center",$fn=32);
    }
}

module coupler(od=16,d1=5,d2=1/4*25.4,l=20)
{
    difference()
    {
        cylinder(d=od,h=l);
        tz(-.01)cylinder(d=d1,h=l/2+.02);
        tz(l/2)cylinder(d=d2,h=l/2+.02);
        t([-.5,-od*.25,-.01]) cube([1,od,l+.02]);
    }
}

module plunger(){
    tz(-syringe_plunger_thickness-syringe_plunger_length2) {
        color([.91,.91,1,.5]) {
            tz(0) cylinder(d=syringe_plunger_head_diameter,h=syringe_plunger_thickness);   
            for(a=[0,90])rz(a) hull() {
                cube([syringe_plunger_wall_width2,syringe_plunger_thickness,.01],center=true);
                tz(syringe_plunger_length2) cube([syringe_plunger_wall_width,syringe_plunger_thickness,.01],center=true);
                tz(syringe_plunger_length) cube([syringe_plunger_wall_width,syringe_plunger_thickness,.01],center=true);
            }
        }
        color([.1,.1,.1]) tz(syringe_plunger_length) cylinder(d=syringe_body_diameter-2*syringe_body_wall_thickness,h=syringe_plunger_tip_thickness);   
    }
}



module syringe()
{
    color([.91,.91,1,.5]) 
    difference() {
        union() {
            syringebody(0);
            syringeflange();
        }
        syringebody(syringe_body_wall_thickness);
    }
}

module syringebody(offset=0) {
    tz(-offset*5)cylinder(d=syringe_body_diameter-offset*2,h=syringe_body_length+offset*5.01);
    tz(syringe_body_length) {
        cylinder(d1=syringe_body_diameter-offset*2,d2=syringe_body_diameter1-offset*2,h=syringe_body_length1+offset*.01);
        tz(syringe_body_length1)cylinder(d1=syringe_body_diameter1-offset*2,d2=syringe_body_diameter2-offset*2,h=syringe_body_length2+offset*.01);
        }
}

module syringeflange() {
    hull() {
        cylinder(d=syringe_body_flange_diameter,h=syringe_body_flange_thickness);
        for(x=[-1,1]) for (y=[-1,1]) 
            t([x*((syringe_body_flange_width/2)-syringe_body_flange_radius),y*((syringe_body_flange_length/2)-syringe_body_flange_radius),0]) 
        cylinder(r=syringe_body_flange_radius,h=syringe_body_flange_thickness);
    }
}

////////////////////////////////////////////////////////////////////
// Super sexy model of a motor
module nema17steppermotor(pinion=true)
{
	h1=9.46;		// bottom silver layer
	h2=25.25;		// middle black layer
	h3=33.19;		// top silver
	h4=35.24;		// height of nema ring
	h5=37.13; 	// bottom of gear
	h6=47.37;		// bottom to tip of shaft
	depth1=2.16;
	depth2=5.2;
	shaftd=5;
	d1=12.55;
	d2=8.14;
	offset=nema17motorw/2-nema17cornerr;
	
	translate([0,0,-h3])
	{
		// bottom of motor
		translate([0,0,0])
			color([.8,.8,.8]) 
				difference()
				{	
					hull() for(x=[-1,1])for(y=[-1,1]) translate([x*offset,y*offset,0]) cylinder(r=nema17cornerr,h1);
					translate([0,0,-.01])
					{
						cylinder(d=d1,h=depth1);
						cylinder(d=d2,h=depth2);
						color([.6,.6,.6]) 
						for(x=[-1,1]) for(y=[-1,1]) translate([x*nema17screwoffset,y*nema17screwoffset,0]) cylinder(d1=7,d2=6,h=.5);
					}
				}
		// middle black layer of motor
		translate([0,0,h1])
			color([.2,.2,.2]) 
				hull() for(x=[-1,1])for(y=[-1,1]) translate([x*offset,y*offset,0]) cylinder(r=nema17cornerr,h2-h1);
		// sticker
		translate([0,-14,h1+.3])
				color([.8,.82,.7,.8]) 
					cube([nema17motorw/2+.1,25,15]);
				
		// top of motor
		difference()
		{
			union()
			{
				// top layer
				translate([0,0,h2])
					color([.8,.8,.8]) 
						hull() for(x=[-1,1])for(y=[-1,1]) translate([x*offset,y*offset,0]) cylinder(r=nema17cornerr,h3-h2);
				// bearing ring
				translate([0,0,h3])
					color([.85,.85,.85]) 
						cylinder(r=nema17r1, h=h4-h3);
			}
			// larger bearign hole
			translate([0,0,h3-.5])
				color([.7,.7,.7]) 
					cylinder(d=18, h=4);
			
			// shaft hole in top
			translate([0,0,h3-2.5])
				color([.4,.4,.4]) 
					cylinder(d=9, h=4);
		
			// screws
			translate([0,0,h3-4])
				color([.6,.6,.6]) 
					for(x=[-1,1]) for(y=[-1,1]) translate([x*nema17screwoffset,y*nema17screwoffset,0]) cylinder(r=nema17screwholer,h=8);
		}
		// gear
		if(pinion) translate([0,0,h5]) pinion_gear();
				
		// bottom of shaft
		color([.99,.99,.99])
		{
			translate([0,0,depth1]) cylinder(d=shaftd,h=h6-depth1-.5);
			// bezeled top
			translate([0,0,h6-.5]) cylinder(d1=shaftd,d2=shaftd-1,1);
		}

		// jack on the back
		// yellow part
		jh1=1.52;
		jw1=17;
		jd1=1.29;
		color([.7,.7,.5])
			translate([-nema17motorw/2-jd1,-jw1/2,jh1])cube([jd1,jw1,h1-jh1]);

		// circuit board
		jh2=4.28;
		jw2=15;
		jd2=6.25;
		jt2=.9;
		color([.6,.6,.3])
			translate([-nema17motorw/2-jd2,-jw2/2,jh2+.1])cube([jd2,jw2,jt2]);
		color([.4,.7,.2])
			translate([-nema17motorw/2-jd2,-jw2/2,jh2])cube([jd2,jw2,.1]);

		// white opening
		jh3=jh2+jt2;
		jw3=15;
		jd3=6.25;
		jt3=4.5;
		jt4=.45;
		jw4=7.79;
		color([1,1,1])
			translate([-nema17motorw/2-jd3,-jw2/2,jh3])
				difference()
				{
					cube([jd3,jw3,jt3]);
					translate([-jt4,jt4,jt4]) cube([jd3-jt4*2,jw3-jt4*2,jt3-jt4*2]);
					translate([-jt4,(jw3-jw4)/2,jt4]) cube([jd3-jt4*2,jw4,jt3]);
				}

		// pins
		pinw=.5;
		pinl=jd3-.5;
			pinh=7.6;
		color([.7,.7,.7])
			translate([-nema17motorw/2-pinl,-12/2-pinw/2,pinh])
				for(i=[0:6]) translate([0,i*2,0]) cube([pinl,pinw,pinw]);
				}
}
////////////////////////////////////////////////////////////////////
// NEMA 17 hole pattern
module nema17holes(h=5,clr=0)
{
	// center hole
	cylinder(r=nema17r1+clr,h=h);
	for(x=[-1,1]) for(y=[-1,1]) translate([x*nema17screwoffset,y*nema17screwoffset,0]) 
	{
		// screw hole
		cylinder(r=nema17screwholer+clr,h=h);
		
	}
}

////////////////////////////////////////////////////////////////////
// NEMA17 mounting plate
module nema17mountingplate(h=1, countersink=true)
{
	difference()
	{
		// square faceplate
		//translate([-nema17motorw/2,-nema17motorw/2,0]) cube([nema17motorw,nema17motorw,layerheight*4]);
		
		// rounded corners faceplate
		offset=nema17motorw/2-nema17cornerr;
		hull()
		{
			for(x=[-1,1])for(y=[-1,1]) translate([x*offset,y*offset,0]) cylinder(r=nema17cornerr,h);
		}

		// holes
		translate([0,0,-1])nema17holes(h=h+2, countersink=true);
	}
}////////////////////////////////////////////////////////////////////
// Gear on the motor
gearteeth=14;
gearod=8.44;
gearid=7.1;
gearh=10.5;
gearshaftd=5;
geargrooved=1.25;
gearpeakd=1.48;
gearpeakw=.67;
depth=.94;

module pinion_gear(gearteeth=14,gearidmultiplier=1)
{
	gearod=8.44*gearteeth/14;
	gearid=gearod-(8.44-7.1)*gearidmultiplier;
	gearh=10.5;
	gearshaftd=5;
	geargrooved=1.25;
	gearpeakd=1.48;
	gearpeakw=.67;
	depth=.94;

	$fn=32;
	
	color([.3,.3,.3])
	difference()
	{
		cylinder(d=gearod,h=gearh);
		translate([0,0,-1])
		{
			cylinder(d=gearshaftd,h=gearh+2);
			for(i=[0:gearteeth])
			{
				rotate([0,0,i*360/gearteeth])
				hull()
				{
						translate([gearid/2+geargrooved/2,0,0]) cylinder(d=geargrooved, h=gearh+2);
						translate([gearod/2+gearpeakd/2,0,0]) cylinder(d=gearpeakd, h=gearh+2);
				}
			}
		}
	}
}

module nut(flatd=3,id=1,h=1)
{
	cornerd=flatd/.866;
    difference() {
        cylinder(d=cornerd,h=h,$fn=6);
        tz(-1) cylinder(d=id,h=h+2);
    }
}

module nuthole(flatd=3, h=1)
{
	$fn=6;
	cornerd=flatd/.866;
	cylinder(d=cornerd,h=h);
	
	for (a=[0:60:360])
	{
		rotate([0,0,a]) translate([cornerd/2,0,0]) cylinder(d=cornerd*.1,h=h);
	}
}

// Convenience functions because typing is tiresome
module t(t) {translate(t) children();}
module tx(t) {translate([t,0,0]) children();}
module ty(t) {translate([0,t,0]) children();}
module tz(t) {translate([0,0,t]) children();}
module r(r) {rotate(r) children();}
module rx(r) {rotate([r,0,0]) children();}
module ry(r) {rotate([0,r,0]) children();}
module rz(r) {rotate([0,0,r]) children();}
module s(t) {scale(t) children();}
module sx(t) {scale([t,1,1]) children();}
module sy(t) {scale([1,t,1]) children();}
module sz(t) {scale([1,1,t]) children();}
module c(c) {color(c) children();}