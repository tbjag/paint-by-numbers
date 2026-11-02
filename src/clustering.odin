package main

import "core:fmt"

// we have a list of RGB
// first chop round numbers to factors of 4, - 0,4,8...
// put sets of color in map[color] = list of [height * imgData.width + width]
// get weight value of each color (total_pixels / num pixels per color)
// create a vector of weight + rgb <- i think this is a list so you can iterate over it and do math
// ^^ maybe we can build a function to iterate over the struct
// create a list of vectors at the end of this
// 
// start of k-means
// 
// initialize random centroids
// 
// while delta_diff > setting delta:
// 	clear pts_per_category
// 	total_distance_diff = 0
// 	for every point:
// 		set mindist to MAX_FLOAT
// 		go through each centroid and find the closest one
// 		total_distance_diff += distance found
//
// essentially return the chopped bits image, and centroid clusters
