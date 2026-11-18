use crate::Rgb;
use std::collections::HashMap;

// inputs will be the lookup hashmap, width and height, bitchopped image
// create grid of u8 of image.
// go through each pixel and assign palette color
// create accessor for grid and return grid

// every pixel in the lookup gets assigned the centroid color
pub fn repaint(pixels: &mut [Rgb], centroids: Vec<Rgb>, lookup: &HashMap<Rgb, usize>) {
    for pixel in (*pixels).iter_mut() { 
        *pixel = centroids[*lookup.get(pixel).unwrap()];
    }
}

#[derive(Clone, Debug, PartialEq, Hash, Eq)]
pub struct Grid {
    width: usize,
    height: usize,
    pixels: Vec<u8>,
}

impl Grid {
    pub fn new(chopped_img: &[Rgb], lookup: &HashMap<Rgb, usize>, width: usize, height: usize) -> Self {
        let mut pixels: Vec<u8> = vec![];

        for p in chopped_img {
            // k should always be small so u8 is fine here
            let value = *lookup.get(p).unwrap() as u8;
            pixels.push(value);
        }
        // run repaint af
        Grid { width, height, pixels }
    }

    pub fn get(&self, x: usize, y: usize) -> u8 {
        self.pixels[y * self.width + x]
    }
}