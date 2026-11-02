import numpy as np
from PIL import Image

from color_manage import ColorMapResult, create_colormap

image_path = "../images/testinput.png"

img = Image.open(image_path)
img_array = np.asarray(img)

colormap: ColorMapResult = create_colormap(img_array)
print(colormap.colors_by_index)
# k-means diy
# maybe we can add bitchopping later? just model the result
