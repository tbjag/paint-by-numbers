use crate::Rgb;

const BITS_CHOP: u8 = 2;

pub fn preprocess(pixels: &mut [Rgb]) {
    // so this mutates in place as far as i understand
    // just like odin here
    for pixel in pixels { // & !0b11 is same as bitchop code
        pixel.r = pixel.r >> BITS_CHOP << BITS_CHOP;
        pixel.g = pixel.g >> BITS_CHOP << BITS_CHOP;
        pixel.b = pixel.b >> BITS_CHOP << BITS_CHOP;
    }
}

fn distance(a: &Rgb, b: &Rgb) -> f32 {
    let (r, g, b) = ( // learn tuple destructure with structs
            a.r as i32 - b.r as i32,
            a.g as i32 - b.g as i32,
            a.b as i32 - b.b as i32,
        );
    ((r * r + g * g + b * b) as f32).sqrt()
}

