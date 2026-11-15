mod kmeans;

use image::{ImageBuffer, ImageReader};

use crate::kmeans::{preprocess, run_kmeans};

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Rgb {
    r: u8,
    g: u8,
    b: u8
}

fn main() {
    let image_path = std::env::args().nth(1).expect("usage: paint-by-numbers <image>");
    let raw_img = ImageReader::open(image_path).expect("error reading image").decode().expect("error decoding image");
    let width = raw_img.width() as usize;
    let height = raw_img.height() as usize;
    println!("image read dimensions: {width}x{height}");

    let raw_img = raw_img.into_rgb8(); //consume as we dont need it anymore

    let mut pixels: Vec<Rgb> = Vec::with_capacity(width * height);
    for rgb in raw_img.pixels() { // @TODO can prob make this a map function
        let [r, g, b] = rgb.0;
        let v = Rgb{
            r, g, b
        };
        pixels.push(v);
    }

    let k = 10;

    preprocess(&mut pixels);
    run_kmeans(&mut pixels, k);
    
    let output = ImageBuffer::from_fn(width as u32, height as u32, |x, y| {
        let idx = y as usize * width + x as usize;
        image::Rgb([pixels[idx].r, pixels[idx].g, pixels[idx].b])
    });
    output.save("output/out.png").expect("failed saving image");
    println!("saved image!");
}
