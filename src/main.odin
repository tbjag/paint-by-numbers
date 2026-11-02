package main

import "core:slice"
import "core:fmt"
import "core:os"
import rl "vendor:raylib"
import "core:strings"

main :: proc() {
	if len(os.args) != 2 {
		fmt.println("passed incorrect amt of args")
		os.exit(1)
	}
	filepath: cstring = strings.clone_to_cstring(os.args[1])
    defer delete(filepath) // todo can delete filepath immediately?
	img := rl.LoadImage(filepath)
	if img.data == nil {
		fmt.println("failed to read image")
		os.exit(1)
	}
	defer rl.UnloadImage(img)

	raw_pixels := rl.LoadImageColors(img)
	defer rl.UnloadImageColors(raw_pixels)

	total_pixels := int(img.width * img.height)
	pixel_slice := slice.from_ptr(raw_pixels, total_pixels)

	rgb_list := make([dynamic]RGB, 0, total_pixels)
	defer delete(rgb_list)

	for color in pixel_slice {
		tuple := RGB{ r = color.r, g = color.g, b = color.b}
		append(&rgb_list, tuple)
	} // can throw away original image after this?

	// print out image info here as well
	fmt.printfln("Image width: %d height: %d", img.width, img.height)
	fmt.printfln("Successfully loaded %d RGB tuples.", len(rgb_list))
	
}