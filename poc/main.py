from PIL import Image
import numpy as np
from pydantic import BaseModel

class RGB(BaseModel):
    r: int
    g: int
    b: int

image_path = '../images/casey.jpg'

img = Image.open(image_path)
img_array = np.asarray(img)

color_index = 0
colors = {}
colors_by_index = []


# colormap go through each point
# add to dict if already seen
print(img_array.shape)
height = len(img_array)
width = len(img_array[0])
for h in range(height):
    for w in range(width):
        r = img_array[h][w][0]
        g = img_array[h][w][1]
        b = img_array[h][w][2]
        print(r,g,b)
        
