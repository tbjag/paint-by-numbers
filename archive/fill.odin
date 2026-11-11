package main

import "core:fmt"
import "core:slice"

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

	for !slice.all_of(seen, true) {
		i := -1
		for s, seen_idx in seen {
			if !s {
				i = seen_idx
				break
			}
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

			dirs := [4][2]int{{-1,0},{1,0},{0,-1},{0,1}}

			for d in dirs {
				nx, ny := x + d.x, y + d.y
				if nx < 0 || nx >= width || ny < 0 || ny >= height do continue
				ni := ny * width + nx
				if pixels[ni] != curr_color {
					border_points[{x,y}] = {}
				} else if !seen[ni] {
					append(&stack, ni)
				}
			}
	
		}
		append(&facets, Facet {
			color= curr_color,
			pixel_num = pixel_num,
			border_points = border_points
		})

	}

	
	
	for f in facets {
		fmt.printfln("facet_color: %d, %d, %d; num_pixels: %d", f.color.r, f.color.g, f.color.b, f.pixel_num)
	}
	fmt.println("finished filling 0")
}