// number of rows
numerical_slider = 4; // [0:10]
//number of columns
numerical_slider2 = 4; // [0:10]

// number of faces in circle
$fn=48; 

cell_diameter=18.5; // 0.1
cell_spacing=20.0;  // 0.1
cell_cap_height=6.0; // 0.5
strip_clearance_w=10.0; // 1.0
strip_clearance_h=1.0; // 0.25

// Square or Hexagonal grid?
grid_type = 0 ; // [0:Square, 1:Hex]

// Make outside edge equal thickness.
expand_outside_edge = true;

/* [Mounting holes] */
mounting_holes = true;
mounting_hole_diameter = 1.0; // 0.1
inside_only = true;

total_height=cell_cap_height+strip_clearance_h;
min_thickness = cell_spacing-cell_diameter;
exterior_expand = expand_outside_edge ? min_thickness/2 : 0;

symmetry = grid_type == 0? 4 : 6;

basis_x = cell_spacing * [1, 0, 0];
basis_y = cell_spacing * [cos(360/symmetry), sin(360/symmetry), 0];

r = (cell_spacing/2)/cos(180/symmetry);
maximum_mounting_hole_diameter = 2*(r-cell_diameter/2-cell_spacing+cell_diameter);
echo("Maximum mounting hole diameter: ", maximum_mounting_hole_diameter);
assert((mounting_hole_diameter < maximum_mounting_hole_diameter) || !mounting_holes, "Mounting hole too large!");

//assert((cos(180/symmetry)*cell_spacing - cell_diameter - 2*(cell_spacing-cell_diameter) - mounting_hole_diameter*2) > 0, "Mounting hole too large!");


module body() {
    difference(){
        for (i = [1 : numerical_slider], j = [1 : numerical_slider2]) {
            $fn=symmetry;
            theta = 180/$fn;
            r = (cell_spacing/2+exterior_expand)/cos(theta);
            translate((i-0.5)*basis_x+(j-0.5)*basis_y)
            rotate([0,0,180/symmetry])
            cylinder(h=total_height, r=r, center=true);
        }; 
        for (
            i = [1 : numerical_slider], 
            j = [1 : numerical_slider2], 
            theta = [3*180/symmetry:360/symmetry:360+90]
        ) {
            is_inside = (theta <= 180) && i > 1 && j < (numerical_slider2) ? true : false;
            if (mounting_holes && (is_inside || !inside_only)) {
                r = (cell_spacing/2)/cos(180/symmetry);
                translate(
                    (i-0.5)*basis_x + 
                    (j-0.5)*basis_y + 
                    [r*cos(theta), r*sin(theta), 0])
                cylinder(h=total_height+1, r=mounting_hole_diameter/2, center=true);
            }
        }

    }
}

difference() {
    body();
    for ( i = [1 : numerical_slider2] )
    {
        translate((i-0.5)*(basis_y))
        for ( i = [1 : numerical_slider] )
        {
            translate((i-0.5)*(basis_x))
            {
                translate([0,0,total_height/2])
               {
                   for (i = [0:symmetry-1]) {
                       angle = i*360/symmetry+90;
                       rotate([0, 0, angle]) {
                            cube(size = [strip_clearance_w,cell_spacing+10,strip_clearance_h*2], center = true);
                           cube(size = [strip_clearance_w, cell_diameter, (strip_clearance_h+0.2)*2], center=true);
                       }
                   }
               }
                translate([0,0,-(cell_cap_height+strip_clearance_h)/2-0.99]) cylinder(h = cell_cap_height+1, r=cell_diameter/2);
            }
        }
    }
}

