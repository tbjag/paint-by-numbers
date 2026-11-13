use crate::Rgb;

const BITS_CHOP: u8 = 2;

pub fn preprocess(pixels: &mut [Rgb]) {
    // so this mutates in place as far as i understand
    // just like odin here
    for pixel in pixels {
        pixel.r = pixel.r >> BITS_CHOP << BITS_CHOP;
        pixel.g = pixel.g >> BITS_CHOP << BITS_CHOP;
        pixel.b = pixel.b >> BITS_CHOP << BITS_CHOP;
    }
}