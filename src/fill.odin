package main

import "core:fmt"
import "core:slice"
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
	img_size := len(pixels)
	seen := make([]bool, img_size)
	stack := make([dynamic]int) // pixel location idx
	facets := make([dynamic]Facet)
	defer delete(seen)
	defer delete(stack)
	defer {
		for f in facets do delete(f.border_points)
	}
	defer delete(facets)

	// plan:
	// 1. do for all facets - done
	// 2. remove duplicate border pts. - done
	// 3. refactor function

	for {
		i := -1
		for s, seen_idx in seen {
			if !s {
				i = seen_idx
				break
			}
		}

		if slice.all_of(seen, true) {
			break
		}
		
		append(&stack, i)
		curr_color := pixels[i]
		border_points := make(map[Point]struct{})
		pixel_num := 0

		for len(stack) > 0 {
			curr_index := pop(&stack)
			if seen[curr_index] do continue
			seen[curr_index] = true
			if pixels[curr_index] != curr_color do continue
			pixel_num += 1
			
			x := curr_index % width
			y := curr_index / width
	
			// check neighbours
			if x != 0 {
				if pixels[y * width + x - 1] != curr_color {
					border_points[{x,y}] = struct{}{}
				} else if !seen[y * width + x - 1] {
					append(&stack, y * width + x - 1)
				}
			}
			if x != width - 1 {
				if pixels[y * width + x + 1] != curr_color {
					border_points[{x,y}] = struct{}{}
				} else if !seen[y * width + x + 1] {
					append(&stack, y * width + x + 1)
				}
			}
			if y != 0 {
			 	if pixels[(y - 1)* width + x] != curr_color {
					border_points[{x,y}] = struct{}{}
				} else if !seen[(y - 1)* width + x] {
					append(&stack, (y - 1)* width + x)
				}
				
			}
			if y != height - 1 {
		 		if pixels[((y + 1)* width) + x] != curr_color {
					border_points[{x,y}] = struct{}{}
				} else if !seen[(y + 1)* width + x] {
					append(&stack, (y + 1)* width + x)
				}
			}
		}
		f := Facet {
			color= curr_color,
			pixel_num = pixel_num,
			border_points = border_points
		}
		append(&facets, f)

	}

	
	
	for f in facets {
		fmt.printfln("facet_color: %d, %d, %d; num_pixels: %d", f.color.r, f.color.g, f.color.b, f.pixel_num)
	}
	fmt.println("finished filling 0")
}