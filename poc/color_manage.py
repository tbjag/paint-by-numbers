from PIL import Image
import numpy as np
from numpy.typing import NDArray
from pydantic import BaseModel, ConfigDict

class ColorMapResult(BaseModel):
    model_config = ConfigDict(arbitrary_types_allowed=True)
    img_color_indices: NDArray[np.int32]
    colors_by_index: list[list[int]]
    width: int
    height: int

def k_means_apply(img_array):
    height = len(img_array)
    width = len(img_array[0])
    num_pixels = height * width
    bits_chop = 2
    point_by_color = {}
    for h in range(height):
        for w in range(width):
            # convert to 4s
            r = img_array[h][w][0] >> bits_chop << bits_chop
            g = img_array[h][w][1] >> bits_chop << bits_chop
            b = img_array[h][w][2] >> bits_chop << bits_chop
            rgb = f'{r}.{g}.{b}'
            if rgb not in point_by_color:
                point_by_color[rgb] = [h * width + w]
            else:
                point_by_color[rgb].append([h * width + w])

    for color in point_by_color:
        rgb = [int(x) for x in color.split(".")]
        # there are color settings here we will ignore for now
        weight = len(point_by_color[color]) / num_pixels 
        

def create_colormap(img_array) -> ColorMapResult:
    height = len(img_array)
    width = len(img_array[0])
    print(img_array.shape)

    img_color_indices = np.empty((height, width), dtype=np.int32)
    color_index = 0
    colors = {}
    colors_by_index = []
    for h in range(height):
        for w in range(width):
            r = img_array[h][w][0]
            g = img_array[h][w][1]
            b = img_array[h][w][2]
            rgb = f'{r}.{g}.{b}'
            current_color_index = -1
            if rgb not in colors:
                colors[rgb] = color_index
                colors_by_index.append([int(r), int(g), int(b)])
                current_color_index = color_index
                color_index += 1
            else:
                current_color_index = colors[rgb]
            img_color_indices[h][w] = current_color_index
    
    return ColorMapResult(
        img_color_indices=img_color_indices,
        colors_by_index=colors_by_index,
        width=width,
        height=height
    )