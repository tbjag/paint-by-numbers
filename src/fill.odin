package main

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

fill :: proc (pixels: []RGB, width, height, idx: int, facet: ^Facet, seen: []bool) {
	if idx >= len(pixels) || idx < 0 			do return
	if facet.color != pixels[idx] || seen[idx] 	do return

	facet.pixel_num += 1
	seen[idx] = true
	
	y := idx / width
	x := idx % width

	
	if x == 0 || pixels[idx - 1] != facet.color ||
	   x + 1 == width || pixels[idx + 1] != facet.color ||
	   y == 0 || pixels[idx - width] != facet.color ||
	   y + 1 == height || pixels[idx + width] != facet.color {
			append(&facet.border_points, Point{x, y})
	}

	
	if x + 1 < width do fill(pixels, width, height, y * width + x + 1, facet, seen)
	if x > 0 		 do	fill(pixels, width, height, y * width + x - 1, facet, seen)
	fill(pixels, width, height, (y + 1) * width + x, facet, seen)
	fill(pixels, width, height, (y - 1) * width + x, facet, seen)
}

create_facets :: proc(pixels: []RGB, width, height: int) {
	seen := make([]bool, len(pixels))
	defer delete(seen)

	for pixel, idx in pixels {
		
	}
	
}