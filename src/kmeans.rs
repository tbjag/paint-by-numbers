use std::collections::HashMap;
use std::vec;

use crate::Rgb;

use rand::seq::index;

const BITS_CHOP: u8 = 2;
const DELTA_DIFF: f32 = 1.0;

pub fn preprocess(pixels: &mut [Rgb]) {
    // so this mutates in place as far as i understand
    // just like odin here
    for pixel in pixels {
        // & !0b11 is same as bitchop code
        pixel.r = pixel.r >> BITS_CHOP << BITS_CHOP;
        pixel.g = pixel.g >> BITS_CHOP << BITS_CHOP;
        pixel.b = pixel.b >> BITS_CHOP << BITS_CHOP;
    }
}

fn get_distance(a: &Rgb, b: &Rgb) -> f32 {
    let (r, g, b) = (
        // learn tuple destructure with structs
        a.r as i32 - b.r as i32,
        a.g as i32 - b.g as i32,
        a.b as i32 - b.b as i32,
    );
    ((r * r + g * g + b * b) as f32).sqrt()
}

fn count_colors(pixels: &[Rgb]) -> Vec<(Rgb, u32)> {
    let mut c: HashMap<Rgb, u32> = HashMap::new();

    for pixel in pixels {
        *c.entry(*pixel).or_insert(0) += 1;
    }

    let mut c = c.into_iter().collect::<Vec<(Rgb, u32)>>();
    c.sort_by_key(|entry| (entry.0.r, entry.0.g, entry.0.b));
    c
}

fn step_kmeans(
    pixel_counts: &[(Rgb, u32)],
    centroids: &mut [Rgb],
    assignments: &mut [usize],
) -> f32 {
    for (pixel_idx, &(color, _)) in pixel_counts.iter().enumerate() {
        let mut min_dist_centroid_idx = 0;
        let mut min_distance = f32::MAX;
        for (centroid_idx, centroid) in (*centroids).iter().enumerate() {
            let distance = get_distance(&color, centroid);
            if distance < min_distance {
                min_dist_centroid_idx = centroid_idx;
                min_distance = distance;
            }
        }
        assignments[pixel_idx] = min_dist_centroid_idx;
    }

    let mut centroid_sums: Vec<[i32; 3]> = vec![[0; 3]; centroids.len()]; // @todo add typing to this
    let mut counts: Vec<i32> = vec![0; centroids.len()];
    for (pixel_idx, centroid_idx) in assignments.iter().enumerate() {
        let (pixel, pixel_count) = pixel_counts[pixel_idx];
        // so here these are pixel counts and we want to give weight to represent
        centroid_sums[*centroid_idx][0] += pixel.r as i32 * pixel_count as i32;
        centroid_sums[*centroid_idx][1] += pixel.g as i32 * pixel_count as i32;
        centroid_sums[*centroid_idx][2] += pixel.b as i32 * pixel_count as i32;
        counts[*centroid_idx] += pixel_count as i32;
    }

    let mut total_distance: f32 = 0.0;
    for (idx, centroid) in (*centroids).iter_mut().enumerate() {
        if counts[idx] == 0 {
            continue;
        }
        let num_pixels = counts[idx];
        let r = (centroid_sums[idx][0] / num_pixels) as u8;
        let g = (centroid_sums[idx][1] / num_pixels) as u8;
        let b = (centroid_sums[idx][2] / num_pixels) as u8;

        let new_centroid = Rgb { r, g, b };
        total_distance += get_distance(centroid, &new_centroid);
        *centroid = new_centroid;
    }

    total_distance
}

pub fn run_kmeans(pixels: &mut [Rgb], k: usize) {
    let pixel_counts = count_colors(pixels);
    let rng = &mut rand::rng(); // change rng to be seeded if needed
    let samples = index::sample(rng, pixel_counts.len(), k.min(pixel_counts.len()));

    let mut centroids: Vec<Rgb> = vec![]; // can prob turn this into a map
    for idx in samples {
        centroids.push(pixel_counts[idx].0);
    }

    let mut assignments = vec![0; pixel_counts.len()];

    let mut diff = step_kmeans(&pixel_counts, &mut centroids, &mut assignments);
    while diff > DELTA_DIFF {
        diff = step_kmeans(&pixel_counts, &mut centroids, &mut assignments);
    }

    let mut lookup: HashMap<Rgb, usize> = HashMap::new();
    for (&(color, _), &assignment) in pixel_counts.iter().zip(assignments.iter()) {
        lookup.insert(color, assignment);
    }
    for pixel in (*pixels).iter_mut() {
        *pixel = centroids[*lookup.get(pixel).unwrap()];
    }

    println!("finished assigning!");
}
