package main

import "core:math/rand"

sample_image_coordinates :: proc(total_pixels: int, k: int) -> []int {
    if k <= 0 || k > total_pixels do return {}

    result := make([]int, k)
    
    seen := make(map[int]struct{})
    defer delete(seen)

    picked := 0
    for picked < k {
        idx := rand.int_max(total_pixels)
        
        if !(idx in seen) {
            seen[idx] = {}
            
            result[picked] = idx
            picked += 1
        }
    }

    return result
}
