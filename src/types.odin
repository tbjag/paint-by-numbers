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
	rgb: RGB
	
}