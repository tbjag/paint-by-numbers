package main

RGB :: struct {
	r: u8,
	g: u8,
	b: u8
}

Point :: struct {
	x, y: int
}

BoundingBox :: struct {
	min_x, max_x: int,
	min_y, max_y: int
}

Facet :: struct {
	color: RGB,
	pixel_num: int,
	// bbox: BoundingBox,
	border_points: map[Point]struct{}
	// neighbour_facets: []int
}