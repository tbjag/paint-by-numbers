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

	// try building this for 1 facet only at 0,0
	stack := make([dynamic]int) // pixel locations
	defer delete(stack)
	border_points := make([dynamic]Point, 0)
	defer delete(border_points)

	append(&stack, 0)
	curr_color := pixels[0]

	//almost done, duplicate border points  & add edges
	// consolidate checking as well
	for len(stack) > 0 {
		// pop off stack
		curr_index := pop(&stack)
		if seen[curr_index] do continue
		seen[curr_index] = true
		if pixels[curr_index] != curr_color do continue
		// if any of the neighbours are a diff color
		// then assign border
		x := curr_index % width
		y := curr_index / width

		// check neighbours
		if x != 0 {
			if pixels[y * width + x - 1] != curr_color {
				append(&border_points, {x, y})
			} else if !seen[y * width + x - 1] {
				append(&stack, y * width + x - 1)
			}
		}
		if x != width - 1 {
			if pixels[y * width + x + 1] != curr_color {
				append(&border_points, {x, y})
			} else if !seen[y * width + x + 1] {
				append(&stack, y * width + x + 1)
			}
		}
		if y != 0 {
		 	if pixels[(y - 1)* width + x] != curr_color {
				append(&border_points, {x, y})
			} else if !seen[(y - 1)* width + x] {
				append(&stack, (y - 1)* width + x)
			}
			
		}
		if y != height - 1 {
	 		if pixels[((y + 1)* width) + x] != curr_color {
				append(&border_points, {x, y})
			} else if !seen[(y + 1)* width + x] {
				append(&stack, (y + 1)* width + x)
			}
		}
		
	}

	
	
	for p in border_points {
		fmt.printfln("x: %d, y: %d", p.x, p.y)
	}
	fmt.println("finished filling 0")
}