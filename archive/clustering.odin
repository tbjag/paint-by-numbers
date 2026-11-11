package main

import "core:fmt"
import "core:math"


preprocess_image :: proc(pixels: []RGB) {
	BITS_TO_CHOP :: 2
	for &pixel in pixels {
		pixel.r = pixel.r >> BITS_TO_CHOP << BITS_TO_CHOP
		pixel.g = pixel.g >> BITS_TO_CHOP << BITS_TO_CHOP
		pixel.b = pixel.b >> BITS_TO_CHOP << BITS_TO_CHOP
	}
}

get_distance :: proc(a: RGB, b: RGB) -> f32 {
	rd := int(a.r) - int(b.r)
	gd := int(a.g )- int(b.g)
	bd := int(a.b) - int(b.b)
	sum_squares := (rd * rd) + (gd * gd) + (bd * bd)
	return math.sqrt_f32(f32(sum_squares))
}

step_kmeans :: proc(pixels, centroids: []RGB, assignments: []int) -> f32{
	// assign centroids
	for pixel, idx in pixels {
		min_dist_centroid_idx := 0
		min_distance: f32 = math.F32_MAX
		for centroid, centroid_idx in centroids {
			distance := get_distance(pixel, centroid)
			if distance < min_distance {
				min_dist_centroid_idx = centroid_idx
				min_distance = distance
			}
		}
		assignments[idx] = min_dist_centroid_idx
	}
	
	total_distance_diff: f32 = 0
	// adjust centroids - maybe can make more efficient by putting into loop above
	sums := make([][3]int, len(centroids))
	defer delete(sums)
	counts := make([]int, len(centroids))
	defer delete(counts)

	for centroid_idx, pixel_idx in assignments {
		pixel := pixels[pixel_idx]
		sums[centroid_idx].r += int(pixel.r)
		sums[centroid_idx].g += int(pixel.g)
		sums[centroid_idx].b += int(pixel.b)
		counts[centroid_idx] += 1
	}

	for &centroid, idx in centroids {
		if counts[idx] == 0 do continue
		new_centroid := RGB {
			r = u8(sums[idx].r / counts[idx]),
			g = u8(sums[idx].g / counts[idx]),
			b = u8(sums[idx].b / counts[idx])
		}
		total_distance_diff += get_distance(centroid, new_centroid)
		centroid = new_centroid
	}
	
	return total_distance_diff
}

run_kmeans :: proc(pixels: []RGB, k: int) {
	DELTA_DIFF :: 1.0

	sample_centroid_idxs := sample_image_coordinates(len(pixels), k)
	defer delete(sample_centroid_idxs)

	centroids := make([]RGB, k)
	defer delete(centroids)
	for pixel_idx, i in sample_centroid_idxs {
		centroids[i] = pixels[pixel_idx]
	}
	
	assignments := make([]int, len(pixels))
	defer delete(assignments)

	diff := step_kmeans(pixels, centroids, assignments)
	for diff > DELTA_DIFF { // i would measure if there was no more change?
		diff = step_kmeans(pixels, centroids, assignments)
	}

	// final assignment after running k-means
	for &pixel, idx in pixels {
		pixel = centroids[assignments[idx]]
	}
	fmt.printfln("finished assigning")
}