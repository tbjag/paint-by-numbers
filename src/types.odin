package main

RGB :: struct {
	r: u8,
	g: u8,
	b: u8
}

Vector :: struct {
	values: [dynamic]RGB,
	weight: int,
}

KMeans :: struct {
	current_iteration: int,
	points_per_category: [dynamic][dynamic]Vector,
	centroids: [dynamic]Vector,
	current_delta_difference: f32,
	// add pts. here
}