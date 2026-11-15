use std::vec;

use crate::Rgb;

use rand::seq::index;

const BITS_CHOP: u8 = 2;
const DELTA_DIFF: f32 = 1.0;

pub fn preprocess(pixels: &mut [Rgb]) {
    // so this mutates in place as far as i understand
    // just like odin here
    for pixel in pixels { // & !0b11 is same as bitchop code
        pixel.r = pixel.r >> BITS_CHOP << BITS_CHOP;
        pixel.g = pixel.g >> BITS_CHOP << BITS_CHOP;
        pixel.b = pixel.b >> BITS_CHOP << BITS_CHOP;
    }
}

fn get_distance(a: &Rgb, b: &Rgb) -> f32 {
    let (r, g, b) = ( // learn tuple destructure with structs
            a.r as i32 - b.r as i32,
            a.g as i32 - b.g as i32,
            a.b as i32 - b.b as i32,
        );
    ((r * r + g * g + b * b) as f32).sqrt()
}

fn step_kmeans(pixels: &[Rgb], centroids: &mut [Rgb], assignments: &mut [usize]) -> f32{
    for (pixel_idx, pixel) in pixels.iter().enumerate() {
        let mut min_dist_centroid_idx: usize = 0;
        let mut min_distance: f32 = f32::MAX;
        let mut centroid_idx: usize = 0;
        for centroid in &mut *centroids {
            let distance = get_distance(pixel, centroid);
            if distance < min_distance {
                min_dist_centroid_idx = centroid_idx; 
                min_distance = distance;
            }
            centroid_idx += 1;
        }
        assignments[pixel_idx] = min_dist_centroid_idx;
    }
    let mut total_distance: f32 = 0.0;
    let mut sums: Vec<[i32; 3]> = vec![[0; 3]; centroids.len()];
    let mut counts: Vec<i32> = vec![0; centroids.len()];

    for (pixel_idx, centroid_idx) in assignments.iter().enumerate() {
        let pixel = pixels[pixel_idx];

        sums[*centroid_idx][0] += pixel.r as i32;
        sums[*centroid_idx][1] += pixel.g as i32;
        sums[*centroid_idx][2] += pixel.b as i32;
        counts[*centroid_idx] += 1;
    }

    for (idx, centroid) in (*centroids).iter_mut().enumerate() {
        if counts[idx] == 0 {
            continue;
        }
        let r = (sums[idx][0] / counts[idx] ) as u8;
        let g = (sums[idx][1] / counts[idx]) as u8;
        let b = (sums[idx][2] / counts[idx]) as u8;

        let new_centroid = Rgb{r, g, b};
        total_distance += get_distance(centroid, &new_centroid);
        *centroid = new_centroid;
    }
    
    
    total_distance
}

pub fn run_kmeans(pixels: &mut [Rgb], k: i32) {
    let rng = &mut rand::rng();
    let samples = index::sample(rng, pixels.len(), k as usize);

    let mut centroids: Vec<Rgb> = vec![];
    for idx in samples {
        centroids.push(pixels[idx].clone());
    }

    let mut assignments = vec![0; pixels.len()];

    let mut diff = step_kmeans(pixels, &mut centroids, &mut assignments);
    while diff > DELTA_DIFF {
        diff = step_kmeans(pixels, &mut centroids, &mut assignments);
    }

    for (idx, pixel) in (*pixels).iter_mut().enumerate() {
        *pixel = centroids[assignments[idx]];
    }

    println!("finished assigning!");
}