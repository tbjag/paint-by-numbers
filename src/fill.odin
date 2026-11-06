package main

import "core:fmt"
// algorithm:
// define facet 
// pick a point
// 		check if facet is already owned
//  	attribute to facet
// 		put 4 neighbours onto stack
// continue until no more pixels on stack

// data structures needed:
// seen set


find_empty_pixel :: proc (pixels: []RGB, width: int) -> Maybe(Point) {
	for pixel, idx in pixels {
		
	}
	return nil
}

flood_fill :: proc(pixels: []RGB, x, y: int, ) {
	
}

create_facets :: proc(pixels: []RGB, width, height: int) {
	seen := make([]bool, len(pixels))
	defer delete(seen)

	stack := make([dynamic]int)
	defer delete(stack)
	border_points := make([dynamic]Point, 0)
	defer delete(border_points)
	facet := Facet {
		color = pixel_one,
		pixel_num = 0,
		border_points = border_points
	}

	
	
	for p in border_points {
		fmt.printfln("x: %d, y: %d", p.x, p.y)
	}
	fmt.println("finished filling 0")
}